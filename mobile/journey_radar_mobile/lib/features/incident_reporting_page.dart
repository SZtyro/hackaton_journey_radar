import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:journey_radar_mobile/app_ui/app_scaffold.dart';
import 'package:journey_radar_mobile/app_ui/app_spacing.dart';
import 'package:journey_radar_mobile/app_ui/font_constants.dart';
import 'package:journey_radar_mobile/config/firebase_push_notifications_service.dart';
import 'package:journey_radar_mobile/config/logger.dart';
import 'package:journey_radar_mobile/config/service_locator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

enum IncidentType {
  accident('Wypadek'),
  laneClosure('Zamknięcie pasa'),
  vehicleBreakdown('Awaria pojazdu'),
  collision('Kolizja'),
  pedestrianAccident('Wypadek z pieszymi na torach'),
  other('Inne');

  const IncidentType(this.displayName);
  final String displayName;

  IconData get icon {
    switch (this) {
      case IncidentType.accident:
        return Icons.car_crash;
      case IncidentType.laneClosure:
        return Icons.block;
      case IncidentType.vehicleBreakdown:
        return Icons.build_circle; // Better icon for mechanical issues
      case IncidentType.collision:
        return Icons.car_repair;
      case IncidentType.pedestrianAccident:
        return Icons.person_pin_circle;
      case IncidentType.other:
        return Icons.more_horiz;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case IncidentType.accident:
        return Colors.red;
      case IncidentType.collision:
        return Colors.pink;
      case IncidentType.pedestrianAccident:
        return Colors.deepOrange;
      case IncidentType.laneClosure:
        return Colors.amber;
      case IncidentType.vehicleBreakdown:
        return Colors.teal;
      case IncidentType.other:
        return Colors.blueGrey;
    }
  }
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
  final MapController _mapController = MapController();

  IncidentType? _selectedIncidentType;
  String? _selectedRoute;
  String? _selectedStation;
  bool _isEmergency = false;
  bool _isSubmitting = false;

  // GPS Location variables
  LatLng? _currentLocation;
  LatLng? _incidentLocation; // Location selected on map for incident
  bool _isGettingLocation = false;
  String? _locationError;
  bool _hasAutoFetchedLocation =
      false; // Flag to track if we've auto-fetched location

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
  void initState() {
    super.initState();
    // Don't automatically fetch location on init - wait for user interaction
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Auto-fetch GPS location when page becomes visible (but only once)
    if (!_hasAutoFetchedLocation &&
        !_isGettingLocation &&
        _currentLocation == null) {
      _hasAutoFetchedLocation = true;
      _getCurrentLocation();
    }
  }

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
    if (_incidentLocation == null &&
        (_locationController.text.trim().isEmpty)) {
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
        'location': _incidentLocation != null
            ? 'GPS: ${_incidentLocation!.latitude.toStringAsFixed(6)}, ${_incidentLocation!.longitude.toStringAsFixed(6)}'
            : _locationController.text,
        'route': _selectedRoute,
        'station': _selectedStation,
        'isEmergency': _isEmergency,
        'timestamp': DateTime.now().toIso8601String(),
        'reporterId': 'user_123', // Mock user ID
        'status': 'reported',
        'gpsCoordinates': _incidentLocation != null
            ? {
                'latitude': _incidentLocation!.latitude,
                'longitude': _incidentLocation!.longitude,
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
      logE('Error submitting incident: $e');
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
      logE('Error sending incident notification: $e');
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
        _incidentLocation = LatLng(position.latitude,
            position.longitude); // Set incident location to current location
        _isGettingLocation = false;
        _locationError = null;
      });

      // Move map to current location after the widget is built
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _moveMapToCurrentLocation();
        });
      }

      logD('Current location: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      logE('Error getting location: $e');
      setState(() {
        _locationError = 'Błąd podczas pobierania lokalizacji: ${e.toString()}';
        _isGettingLocation = false;
      });
    }
  }

  void _clearLocation() {
    setState(() {
      _currentLocation = null;
      _incidentLocation = null;
      _locationError = null;
    });
  }

  void _onMapTap(TapPosition tapPosition, LatLng point) {
    setState(() {
      _incidentLocation = point;
    });
    logD('Incident location updated to: ${point.latitude}, ${point.longitude}');
  }

  void _moveMapToCurrentLocation() {
    if (_currentLocation != null && mounted) {
      try {
        _mapController.move(_currentLocation!, 15.0);
      } catch (e) {
        logE('Error moving map: $e');
      }
    }
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
      _incidentLocation = null;
      _locationError = null;
      _hasAutoFetchedLocation = false; // Reset flag so GPS can be fetched again
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
                      SizedBox(height: AppSpacing.m),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.2,
                          crossAxisSpacing: AppSpacing.ms,
                          mainAxisSpacing: AppSpacing.ms,
                        ),
                        itemCount: IncidentType.values.length,
                        itemBuilder: (context, index) {
                          final type = IncidentType.values[index];
                          final isSelected = _selectedIncidentType == type;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedIncidentType = type;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? type.backgroundColor.withOpacity(0.12)
                                    : Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHighest, // MD3 surface color
                                borderRadius:
                                    BorderRadius.circular(AppSpacing.ms),
                                border: Border.all(
                                  color: isSelected
                                      ? type.backgroundColor
                                      : Theme.of(context)
                                          .colorScheme
                                          .outline
                                          .withOpacity(
                                              0.3), // MD3 outline color
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: type.backgroundColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      type.icon,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                  SizedBox(height: AppSpacing.xs),
                                  Text(
                                    type.displayName,
                                    style: TextStyle(
                                      fontSize: FontConstants.fontSizeXS,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? type.backgroundColor
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurface, // MD3 on-surface color
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.m),

              // Show rest of form only after incident type is selected
              if (_selectedIncidentType != null) ...[
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _currentLocation != null
                                  ? 'Lokalizacja incydentu'
                                  : 'Lokalizacja *',
                              style: TextStyle(
                                fontSize: FontConstants.fontSizeM,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: AppSpacing.xs),
                            ElevatedButton.icon(
                              onPressed: _isGettingLocation
                                  ? null
                                  : _getCurrentLocation,
                              icon: _isGettingLocation
                                  ? SizedBox(
                                      width: AppSpacing.m,
                                      height: AppSpacing.m,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    )
                                  : const Icon(Icons.my_location),
                              label: Text(_isGettingLocation
                                  ? 'Pobieranie...'
                                  : 'Odśwież GPS'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.ms,
                                  vertical: AppSpacing.xxs,
                                ),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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

                        // Display mini map with incident location
                        if (_currentLocation != null) ...[
                          SizedBox(height: AppSpacing.ms),
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.xs),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.xs),
                              child: FlutterMap(
                                mapController: _mapController,
                                options: MapOptions(
                                  initialCenter: const LatLng(
                                      50.0647, 19.9450), // Krakow center
                                  initialZoom: 15.0,
                                  minZoom: 10.0,
                                  maxZoom: 18.0,
                                  interactionOptions: const InteractionOptions(
                                    flags: InteractiveFlag.all,
                                  ),
                                  onTap: _onMapTap,
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName:
                                        'com.journey_radar_mobile.app',
                                    maxZoom: 18,
                                    subdomains: const ['a', 'b', 'c'],
                                  ),
                                  // Current user location marker
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                        point: _currentLocation!,
                                        width: 20,
                                        height: 20,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white, width: 2),
                                          ),
                                          child: const Icon(
                                            Icons.person,
                                            color: Colors.white,
                                            size: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Incident location marker
                                  if (_incidentLocation != null)
                                    MarkerLayer(
                                      markers: [
                                        Marker(
                                          point: _incidentLocation!,
                                          width: 30,
                                          height: 30,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 3),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.red
                                                      .withOpacity(0.3),
                                                  blurRadius: 6,
                                                  spreadRadius: 2,
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.location_on,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: AppSpacing.xs),
                          Row(
                            children: [
                              Icon(Icons.my_location,
                                  color: Colors.blue, size: 16),
                              SizedBox(width: AppSpacing.xs),
                              Text(
                                'Twoja lokalizacja',
                                style: TextStyle(
                                  fontSize: FontConstants.fontSizeXS,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                              SizedBox(width: AppSpacing.m),
                              Icon(Icons.location_on,
                                  color: Colors.red, size: 16),
                              SizedBox(width: AppSpacing.xs),
                              Text(
                                'Lokalizacja incydentu',
                                style: TextStyle(
                                  fontSize: FontConstants.fontSizeXS,
                                  color: Colors.red.shade700,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSpacing.xs),
                          Text(
                            'Kliknij na mapie, aby zmienić lokalizację incydentu',
                            style: TextStyle(
                              fontSize: FontConstants.fontSizeXS,
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic,
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
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.xs),
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
                                    style:
                                        TextStyle(color: Colors.red.shade700),
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
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
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
            ],
          ),
        ),
      ),
    );
  }
}
