import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:journey_radar_mobile/entity/entity.dart';
import 'package:latlong2/latlong.dart';
import 'package:journey_radar_mobile/app_ui/app_spacing.dart';
import 'package:journey_radar_mobile/app_ui/components/components.dart';
import 'package:journey_radar_mobile/services/location_service.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  final List<Marker> _markers = [];
  final List<BusRouteEntity> _BusRouteEntities = [];
  final List<MapPointEntity> _MapPointEntities = [];
  final LocationService _locationService = LocationService();

  LatLng? _userLocation;
  bool _isLoadingLocation = false;
  bool _showBusRouteEntities = true;
  bool _showMapPointEntities = true;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final location = await _locationService.getCurrentLatLng();
      if (location != null) {
        setState(() {
          _userLocation = location;
        });
        _mapController.move(location, 15.0);
      }
    } catch (e) {
      print('Błąd podczas pobierania lokalizacji: $e');
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  void _updateMarkers() {
    setState(() {
      _markers.clear();

      if (_showMapPointEntities) {
        for (final point in _MapPointEntities) {
          _markers.add(
            Marker(
              point: point.position,
              width: AppSpacing.s,
              height: AppSpacing.m,
              child: GestureDetector(
                onTap: () => _showPointInfo(point),
                child: Container(
                  decoration: BoxDecoration(
                    color: _parseColor(point.color),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getIconForType(point.iconType),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          );
        }
      }
    });
  }

  Color _parseColor(String colorString) {
    return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'landmark':
        return Icons.landscape;
      case 'bus':
        return Icons.directions_bus;
      case 'restaurant':
        return Icons.restaurant;
      case 'shopping':
        return Icons.shopping_cart;
      default:
        return Icons.place;
    }
  }

  void _showPointInfo(MapPointEntity point) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText(
          point.title,
          variant: AppTextVariant.title,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (point.description != null) ...[
              AppText(
                point.description!,
                variant: AppTextVariant.body,
              ),
              SizedBox(height: AppSpacing.s),
            ],
            AppText(
              'Współrzędne: ${point.position.latitude.toStringAsFixed(4)}, ${point.position.longitude.toStringAsFixed(4)}',
              variant: AppTextVariant.caption,
            ),
          ],
        ),
        actions: [
          AppButton(
            text: 'Zamknij',
            variant: AppButtonVariant.secondary,
            onPressed: () => Navigator.of(context).pop(),
          ),
          if (point.buttonText != null)
            AppButton(
              text: point.buttonText!,
              variant: AppButtonVariant.primary,
              onPressed: () {
                Navigator.of(context).pop();
                _onMapPointButtonPressed(point);
              },
            ),
        ],
      ),
    );
  }

  void _onMapPointButtonPressed(MapPointEntity) {
    // Implementacja akcji przycisku
  }

  void _showBusSchedule() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText(
          'Rozkład jazdy',
          variant: AppTextVariant.title,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              'Najbliższe odjazdy:',
              variant: AppTextVariant.subtitle,
            ),
            SizedBox(height: AppSpacing.s),
            AppText('Linia 1: 10:15, 10:25, 10:35',
                variant: AppTextVariant.body),
            AppText('Linia 2: 10:20, 10:30, 10:40',
                variant: AppTextVariant.body),
          ],
        ),
        actions: [
          AppButton(
            text: 'Zamknij',
            variant: AppButtonVariant.primary,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showPlaceInfo(String placeName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText(
          placeName,
          variant: AppTextVariant.title,
        ),
        content: AppText(
          'To jest jedno z ważnych miejsc w Krakowie. Kliknij "Zamknij", aby kontynuować eksplorację mapy.',
          variant: AppTextVariant.body,
        ),
        actions: [
          AppButton(
            text: 'Zamknij',
            variant: AppButtonVariant.primary,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showAddReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText(
          'Dodaj raport o incydencie',
          variant: AppTextVariant.title,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              'Wybierz typ incydentu:',
              variant: AppTextVariant.subtitle,
            ),
            SizedBox(height: AppSpacing.s),
            AppDropdown<String>(
              label: 'Typ incydentu',
              hint: 'Wybierz typ',
              items: [
                AppDropdownItem(
                  value: 'traffic',
                  text: 'Korek drogowy',
                  icon: Icons.traffic,
                ),
                AppDropdownItem(
                  value: 'accident',
                  text: 'Wypadek',
                  icon: Icons.car_crash,
                ),
                AppDropdownItem(
                  value: 'construction',
                  text: 'Roboty drogowe',
                  icon: Icons.construction,
                ),
                AppDropdownItem(
                  value: 'police',
                  text: 'Kontrola policyjna',
                  icon: Icons.local_police,
                ),
                AppDropdownItem(
                  value: 'other',
                  text: 'Inne',
                  icon: Icons.warning,
                ),
              ],
            ),
            SizedBox(height: AppSpacing.s),
            AppTextField(
              label: 'Opis (opcjonalnie)',
              hint: 'Dodatkowe informacje o incydencie',
              variant: AppTextFieldVariant.outlined,
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          AppButton(
            text: 'Anuluj',
            variant: AppButtonVariant.secondary,
            onPressed: () => Navigator.of(context).pop(),
          ),
          AppButton(
            text: 'Dodaj raport',
            variant: AppButtonVariant.primary,
            onPressed: () {
              Navigator.of(context).pop();
              _showReportAddedSnackbar();
            },
          ),
        ],
      ),
    );
  }

  void _showReportAddedSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AppText(
          'Raport został dodany! Dziękujemy za informację.',
          variant: AppTextVariant.body,
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  void _centerOnUserLocation() async {
    if (_userLocation != null) {
      _mapController.move(_userLocation!, 15.0);
    } else {
      setState(() {
        _isLoadingLocation = true;
      });

      final location = await _locationService.getCurrentLatLng();
      if (location != null) {
        setState(() {
          _userLocation = location;
        });
        _mapController.move(location, 15.0);
      }

      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  void _centerOnKrakow() {
    _mapController.move(
      const LatLng(50.0647, 19.9450), // Centrum Krakowa
      13.0,
    );
  }

  void _toggleBusRouteEntities() {
    setState(() {
      _showBusRouteEntities = !_showBusRouteEntities;
    });
  }

  void _toggleMapPointEntities() {
    setState(() {
      _showMapPointEntities = !_showMapPointEntities;
    });
    _updateMarkers();
  }

  void _showAddBusRouteEntityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText(
          'Dodaj trasę autobusową',
          variant: AppTextVariant.title,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              label: 'Nazwa linii',
              hint: 'np. Linia 3',
              variant: AppTextFieldVariant.outlined,
            ),
            SizedBox(height: AppSpacing.s),
            AppTextField(
              label: 'Numer linii',
              hint: 'np. 3',
              variant: AppTextFieldVariant.outlined,
            ),
            SizedBox(height: AppSpacing.s),
            AppText(
              'Kliknij na mapie, aby dodać punkty trasy',
              variant: AppTextVariant.caption,
            ),
          ],
        ),
        actions: [
          AppButton(
            text: 'Anuluj',
            variant: AppButtonVariant.secondary,
            onPressed: () => Navigator.of(context).pop(),
          ),
          AppButton(
            text: 'Dodaj trasę',
            variant: AppButtonVariant.primary,
            onPressed: () {
              Navigator.of(context).pop();
              _showRouteAddedSnackbar();
            },
          ),
        ],
      ),
    );
  }

  void _showAddPointDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText(
          'Dodaj punkt na mapie',
          variant: AppTextVariant.title,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              label: 'Nazwa punktu',
              hint: 'np. Restauracja',
              variant: AppTextFieldVariant.outlined,
            ),
            SizedBox(height: AppSpacing.s),
            AppTextField(
              label: 'Opis (opcjonalnie)',
              hint: 'Dodatkowe informacje',
              variant: AppTextFieldVariant.outlined,
              maxLines: 2,
            ),
            SizedBox(height: AppSpacing.s),
            AppDropdown<String>(
              label: 'Typ punktu',
              hint: 'Wybierz typ',
              items: [
                AppDropdownItem(
                  value: 'landmark',
                  text: 'Zabytki',
                  icon: Icons.landscape,
                ),
                AppDropdownItem(
                  value: 'bus',
                  text: 'Przystanek',
                  icon: Icons.directions_bus,
                ),
                AppDropdownItem(
                  value: 'restaurant',
                  text: 'Restauracja',
                  icon: Icons.restaurant,
                ),
                AppDropdownItem(
                  value: 'shopping',
                  text: 'Sklep',
                  icon: Icons.shopping_cart,
                ),
              ],
            ),
            SizedBox(height: AppSpacing.s),
            AppText(
              'Kliknij na mapie, aby dodać punkt',
              variant: AppTextVariant.caption,
            ),
          ],
        ),
        actions: [
          AppButton(
            text: 'Anuluj',
            variant: AppButtonVariant.secondary,
            onPressed: () => Navigator.of(context).pop(),
          ),
          AppButton(
            text: 'Dodaj punkt',
            variant: AppButtonVariant.primary,
            onPressed: () {
              Navigator.of(context).pop();
              _showPointAddedSnackbar();
            },
          ),
        ],
      ),
    );
  }

  void _showRouteAddedSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AppText(
          'Trasa autobusowa została dodana!',
          variant: AppTextVariant.body,
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showPointAddedSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AppText(
          'Punkt został dodany na mapę!',
          variant: AppTextVariant.body,
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa Krakowa'),
        actions: [
          AppIcon(
            icon: _isLoadingLocation
                ? Icons.location_searching
                : Icons.my_location,
            onPressed: _centerOnUserLocation,
            tooltip: 'Moja lokalizacja',
          ),
          SizedBox(width: AppSpacing.s),
          AppIcon(
            icon: Icons.location_city,
            onPressed: _centerOnKrakow,
            tooltip: 'Centrum Krakowa',
          ),
          SizedBox(width: AppSpacing.s),
        ],
      ),
      body: Stack(
        children: [
          // Mapa
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(50.0647, 19.9450), // Centrum Krakowa
              initialZoom: 13.0,
              minZoom: 8.0,
              maxZoom: 18.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
              onTap: (tapPosition, point) {
                // Możliwość dodawania punktów przez kliknięcie na mapę
                print(
                    'Kliknięto na mapę: ${point.latitude}, ${point.longitude}');
              },
            ),
            children: [
              // OpenStreetMap tiles
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.journey_radar_mobile.app',
                maxZoom: 18,
                subdomains: const ['a', 'b', 'c'],
              ),
              // Trasy autobusowe
              if (_showBusRouteEntities)
                ..._BusRouteEntities.map((route) => PolylineLayer(
                      polylines: [
                        Polyline(
                          points: route.coordinates,
                          color: _parseColor(route.color),
                          strokeWidth: 4.0,
                        ),
                      ],
                    )),
              // Markery punktów
              MarkerLayer(markers: _markers),
              // Marker lokalizacji użytkownika
              if (_userLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _userLocation!,
                      width: 30,
                      height: 30,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Panel kontrolny
          Positioned(
            right: AppSpacing.m,
            bottom: AppSpacing.m,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Przycisk dodawania tras autobusowych
                FloatingActionButton(
                  onPressed: _showAddBusRouteEntityDialog,
                  heroTag: 'add_bus_route',
                  tooltip: 'Dodaj trasę autobusową',
                  child: const Icon(Icons.route),
                ),
                SizedBox(height: AppSpacing.s),
                // Przycisk dodawania punktów
                FloatingActionButton(
                  onPressed: _showAddPointDialog,
                  heroTag: 'add_point',
                  tooltip: 'Dodaj punkt',
                  child: const Icon(Icons.add_location),
                ),
                SizedBox(height: AppSpacing.s),
                // Przycisk przełączania tras autobusowych
                FloatingActionButton(
                  onPressed: _toggleBusRouteEntities,
                  heroTag: 'toggle_routes',
                  tooltip: _showBusRouteEntities ? 'Ukryj trasy' : 'Pokaż trasy',
                  backgroundColor:
                      _showBusRouteEntities ? Colors.green : Colors.grey,
                  child: Icon(_showBusRouteEntities
                      ? Icons.visibility
                      : Icons.visibility_off),
                ),
                SizedBox(height: AppSpacing.s),
                // Przycisk przełączania punktów
                FloatingActionButton(
                  onPressed: _toggleMapPointEntities,
                  heroTag: 'toggle_points',
                  tooltip:
                      _showMapPointEntities ? 'Ukryj punkty' : 'Pokaż punkty',
                  backgroundColor:
                      _showMapPointEntities ? Colors.blue : Colors.grey,
                  child: Icon(_showMapPointEntities
                      ? Icons.location_on
                      : Icons.location_off),
                ),
                SizedBox(height: AppSpacing.s),
                // Przycisk dodawania raportu
                FloatingActionButton.extended(
                  onPressed: _showAddReportDialog,
                  heroTag: 'add_report',
                  icon: const Icon(Icons.add_alert),
                  label: const Text('Raport'),
                ),
              ],
            ),
          ),

          // Info card
          Positioned(
            top: AppSpacing.m,
            left: AppSpacing.m,
            right: AppSpacing.m,
            child: AppCard(
              variant: AppCardVariant.elevated,
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.s),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                          size: AppSpacing.m,
                        ),
                        SizedBox(width: AppSpacing.s),
                        Expanded(
                          child: AppText(
                            'Mapa Krakowa - Funkcje',
                            variant: AppTextVariant.subtitle,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.s),
                    AppText(
                      '• Kliknij na punkty, aby zobaczyć szczegóły',
                      variant: AppTextVariant.caption,
                    ),
                    AppText(
                      '• Użyj przycisków po prawej, aby dodawać trasy i punkty',
                      variant: AppTextVariant.caption,
                    ),
                    AppText(
                      '• Niebieska kropka pokazuje Twoją lokalizację',
                      variant: AppTextVariant.caption,
                    ),
                    if (_userLocation != null) ...[
                      SizedBox(height: AppSpacing.s),
                      AppText(
                        'Twoja lokalizacja: ${_userLocation!.latitude.toStringAsFixed(4)}, ${_userLocation!.longitude.toStringAsFixed(4)}',
                        variant: AppTextVariant.caption,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
