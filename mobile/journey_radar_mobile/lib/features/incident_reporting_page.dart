import 'package:flutter/material.dart';
import 'package:journey_radar_mobile/app_ui/app_scaffold.dart';
import 'package:journey_radar_mobile/app_ui/app_spacing.dart';
import 'package:journey_radar_mobile/app_ui/font_constants.dart';
import 'package:journey_radar_mobile/config/firebase_push_notifications_service.dart';
import 'package:journey_radar_mobile/config/logger.dart';
import 'package:journey_radar_mobile/config/service_locator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

enum IncidentType {
  vehicleBreakdown('Awaria pojazdu'),
  networkFailure('Awaria sieci'),
  collision('Kolizja'),
  pedestrianAccident('Wypadek z pieszymi na torach'),
  other('Inne');

  const IncidentType(this.displayName);
  final String displayName;
}

class IncidentReportingPage extends StatefulWidget {
  const IncidentReportingPage({super.key});

  @override
  State<IncidentReportingPage> createState() => _IncidentReportingPageState();
}

class _IncidentReportingPageState extends State<IncidentReportingPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final firebaseApi = getIt<FirebasePushNotificationService>();

  IncidentType? _selectedIncidentType;
  String? _selectedRoute;
  String? _selectedStation;
  bool _isEmergency = false;
  bool _isSubmitting = false;

  // GPS Location variables
  LatLng? _currentLocation;
  bool _isGettingLocation = false;
  String? _locationError;

  // Mock data for routes and stations
  final List<String> _routes = [
    'Linia 1 - Bronowice ↔ Nowy Bieżanów',
    'Linia 2 - Czerwone Maki ↔ Mistrzejowice',
    'Linia 3 - Mistrzejowice ↔ Kurdwanów',
    'Linia 4 - Wzgórza Krzesławickie ↔ Bronowice',
    'Linia 5 - Krowodrza Górka ↔ Nowy Bieżanów',
  ];

  final List<String> _stations = [
    'Bronowice',
    'Czerwone Maki',
    'Mistrzejowice',
    'Kurdwanów',
    'Wzgórza Krzesławickie',
    'Krowodrza Górka',
    'Nowy Bieżanów',
    'Plac Centralny',
    'Dworzec Główny',
    'Rondo Mogilskie',
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submitIncident() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedIncidentType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Proszę wybrać typ incydentu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check if location is provided (either GPS or manual)
    if (_currentLocation == null && (_locationController.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Proszę podać lokalizację lub pobrać ją z GPS'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Mock incident data
      final incidentData = {
        'type': _selectedIncidentType!.name,
        'typeDisplayName': _selectedIncidentType!.displayName,
        'description': _descriptionController.text,
        'location': _currentLocation != null
            ? 'GPS: ${_currentLocation!.latitude.toStringAsFixed(6)}, ${_currentLocation!.longitude.toStringAsFixed(6)}'
            : _locationController.text,
        'route': _selectedRoute,
        'station': _selectedStation,
        'isEmergency': _isEmergency,
        'timestamp': DateTime.now().toIso8601String(),
        'reporterId': 'user_123', // Mock user ID
        'status': 'reported',
        'gpsCoordinates': _currentLocation != null
            ? {
                'latitude': _currentLocation!.latitude,
                'longitude': _currentLocation!.longitude,
              }
            : null,
      };

      logD('Submitting incident: $incidentData');

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Send push notification to other users on the same route
      await _sendIncidentNotification(incidentData);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Incydent został zgłoszony pomyślnie!\n'
              'Powiadomienia zostały wysłane do innych użytkowników na tej trasie.',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
          ),
        );

        // Reset form
        _resetForm();
      }
    } catch (e) {
      logD('Error submitting incident: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Błąd podczas zgłaszania incydentu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _sendIncidentNotification(
      Map<String, dynamic> incidentData) async {
    try {
      // Generate a route ID from the selected route
      final routeId = _generateRouteId(incidentData['route']);

      await firebaseApi.sendIncidentNotification(
        routeId: routeId,
        incidentType: incidentData['typeDisplayName'],
        incidentDescription: incidentData['description'],
        location: incidentData['location'],
        isEmergency: incidentData['isEmergency'],
        station: incidentData['station'],
        gpsCoordinates: incidentData['gpsCoordinates'] != null
            ? {
                'latitude': incidentData['gpsCoordinates']['latitude'],
                'longitude': incidentData['gpsCoordinates']['longitude'],
              }
            : null,
      );

      logD('Incident notification sent successfully for route: $routeId');
    } catch (e) {
      logD('Error sending incident notification: $e');
      // Don't rethrow here to avoid breaking the form submission
    }
  }

  String _generateRouteId(String route) {
    // Convert route name to a simple ID for topic subscription
    return route
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
      _locationError = null;
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationError =
              'Usługi lokalizacji są wyłączone. Włącz je w ustawieniach urządzenia.';
          _isGettingLocation = false;
        });
        return;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationError =
                'Brak uprawnień do lokalizacji. Zezwól na dostęp w ustawieniach aplikacji.';
            _isGettingLocation = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationError =
              'Uprawnienia do lokalizacji są trwale odrzucone. Otwórz ustawienia aplikacji, aby je włączyć.';
          _isGettingLocation = false;
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _isGettingLocation = false;
        _locationError = null;
      });

      logD('Current location: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      logD('Error getting location: $e');
      setState(() {
        _locationError = 'Błąd podczas pobierania lokalizacji: ${e.toString()}';
        _isGettingLocation = false;
      });
    }
  }

  void _clearLocation() {
    setState(() {
      _currentLocation = null;
      _locationError = null;
    });
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _descriptionController.clear();
    _locationController.clear();
    setState(() {
      _selectedIncidentType = null;
      _selectedRoute = null;
      _selectedStation = null;
      _isEmergency = false;
      _currentLocation = null;
      _locationError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Zgłaszanie incydentu'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.m),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Emergency toggle
              Card(
                child: SwitchListTile(
                  title: const Text('Pilny incydent'),
                  subtitle: const Text(
                      'Zaznacz jeśli sytuacja wymaga natychmiastowej interwencji'),
                  value: _isEmergency,
                  onChanged: (value) {
                    setState(() {
                      _isEmergency = value;
                    });
                  },
                  activeColor: Colors.red,
                ),
              ),

              SizedBox(height: AppSpacing.m),

              // Incident type selection
              Card(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.m),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Typ incydentu *',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      ...IncidentType.values
                          .map((type) => RadioListTile<IncidentType>(
                                title: Text(type.displayName),
                                value: type,
                                groupValue: _selectedIncidentType,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedIncidentType = value;
                                  });
                                },
                              )),
                    ],
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.m),

              // Route selection
              Card(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.m),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Trasa',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      DropdownButtonFormField<String>(
                        value: _selectedRoute,
                        decoration: const InputDecoration(
                          hintText: 'Wybierz trasę',
                          border: OutlineInputBorder(),
                        ),
                        items: _routes
                            .map((route) => DropdownMenuItem(
                                  value: route,
                                  child: Text(route),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedRoute = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.m),

              // Station selection
              Card(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.m),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Stacja',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      DropdownButtonFormField<String>(
                        value: _selectedStation,
                        decoration: const InputDecoration(
                          hintText: 'Wybierz stację',
                          border: OutlineInputBorder(),
                        ),
                        items: _stations
                            .map((station) => DropdownMenuItem(
                                  value: station,
                                  child: Text(station),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedStation = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.m),

              // Location section - always visible
              Card(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.m),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _currentLocation != null
                                ? 'Lokalizacja GPS'
                                : 'Lokalizacja *',
                            style: TextStyle(
                              fontSize: FontConstants.fontSizeM,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed:
                                _isGettingLocation ? null : _getCurrentLocation,
                            icon: _isGettingLocation
                                ? SizedBox(
                                    width: AppSpacing.m,
                                    height: AppSpacing.m,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : const Icon(Icons.my_location),
                            label: Text(
                                _isGettingLocation ? 'Pobieranie...' : 'GPS'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.ms,
                                  vertical: AppSpacing.xxs),
                              minimumSize: Size(0, AppSpacing.xxxl),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.xs),

                      // Manual location text field - only show if no GPS location
                      if (_currentLocation == null)
                        TextFormField(
                          controller: _locationController,
                          decoration: const InputDecoration(
                            hintText: 'Opisz dokładną lokalizację incydentu',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 2,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Proszę podać lokalizację';
                            }
                            return null;
                          },
                        ),

                      // Display current GPS location
                      if (_currentLocation != null) ...[
                        Container(
                          padding: EdgeInsets.all(AppSpacing.ms),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(AppSpacing.xs),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Szerokość: ${_currentLocation!.latitude.toStringAsFixed(6)}°',
                                style: TextStyle(color: Colors.green.shade700),
                              ),
                              Text(
                                'Długość: ${_currentLocation!.longitude.toStringAsFixed(6)}°',
                                style: TextStyle(color: Colors.green.shade700),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // Display error message
                      if (_locationError != null) ...[
                        SizedBox(height: AppSpacing.ms),
                        Container(
                          padding: EdgeInsets.all(AppSpacing.ms),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(AppSpacing.xs),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline,
                                  color: Colors.red.shade700,
                                  size: AppSpacing.m + AppSpacing.xxs),
                              SizedBox(width: AppSpacing.xs),
                              Expanded(
                                child: Text(
                                  _locationError!,
                                  style: TextStyle(color: Colors.red.shade700),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.m),

              // Description
              Card(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.m),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Opis incydentu *',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: 'Opisz szczegóły incydentu',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Proszę podać opis incydentu';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.l),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitIncident,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isEmergency
                        ? Colors.red
                        : Theme.of(context).secondaryHeaderColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.m),
                  ),
                  child: _isSubmitting
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: AppSpacing.m + AppSpacing.xxs,
                              height: AppSpacing.m + AppSpacing.xxs,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            SizedBox(width: AppSpacing.ms),
                            Text('Zgłaszanie...'),
                          ],
                        )
                      : Text(
                          _isEmergency
                              ? 'ZGŁOŚ PILNY INCYIDENT'
                              : 'Zgłoś incydent',
                          style: TextStyle(
                            fontSize: FontConstants.fontSizeM,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              SizedBox(height: AppSpacing.m),

              // Info card
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.m),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue.shade700,
                      ),
                      SizedBox(width: AppSpacing.ms),
                      Expanded(
                        child: Text(
                          'Po zgłoszeniu incydentu, powiadomienia zostaną wysłane do wszystkich użytkowników na tej trasie.',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: FontConstants.fontSizeXS,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
