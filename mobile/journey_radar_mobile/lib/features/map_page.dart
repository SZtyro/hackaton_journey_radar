import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:journey_radar_mobile/app_ui/app_spacing.dart';
import 'package:journey_radar_mobile/app_ui/components/components.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  final List<Marker> _markers = [];

  // Kraków coordinates
  static const double _krakowLat = 50.0647;
  static const double _krakowLng = 19.9450;
  static const double _initialZoom = 12.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_markers.isEmpty) {
      _addKrakowMarkers();
    }
  }

  void _addKrakowMarkers() {
    // Dodajemy znaczniki dla ważnych miejsc w Krakowie
    final krakowPlaces = [
      {
        'name': 'Rynek Główny',
        'lat': 50.0614,
        'lng': 19.9372,
        'icon': Icons.location_city,
      },
      {
        'name': 'Wawel',
        'lat': 50.0546,
        'lng': 19.9354,
        'icon': Icons.castle,
      },
      {
        'name': 'Kazimierz',
        'lat': 50.0519,
        'lng': 19.9447,
        'icon': Icons.temple_buddhist,
      },
      {
        'name': 'Nowa Huta',
        'lat': 50.0726,
        'lng': 20.0325,
        'icon': Icons.factory,
      },
      {
        'name': 'Lotnisko Kraków-Balice',
        'lat': 50.0777,
        'lng': 19.7848,
        'icon': Icons.flight,
      },
    ];

    setState(() {
      _markers.clear();
      for (final place in krakowPlaces) {
        _markers.add(
          Marker(
            point: LatLng(place['lat'] as double, place['lng'] as double),
            width: 40,
            height: 40,
            child: GestureDetector(
              onTap: () => _showPlaceInfo(place['name'] as String),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  place['icon'] as IconData,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        );
      }
    });
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

  void _centerOnKrakow() {
    _mapController.move(
      const LatLng(_krakowLat, _krakowLng),
      _initialZoom,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa Krakowa'),
        actions: [
          AppIcon(
            icon: Icons.my_location,
            onPressed: _centerOnKrakow,
            tooltip: 'Centruj na Krakowie',
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
              initialCenter: const LatLng(_krakowLat, _krakowLng),
              initialZoom: _initialZoom,
              minZoom: 8.0,
              maxZoom: 18.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              // OpenStreetMap tiles
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.journey_radar_mobile.app',
                maxZoom: 18,
                subdomains: const ['a', 'b', 'c'],
              ),
              // Markers
              MarkerLayer(markers: _markers),
            ],
          ),

          // Floating Action Button - Dodaj raport
          Positioned(
            right: AppSpacing.m,
            bottom: AppSpacing.m,
            child: FloatingActionButton.extended(
              onPressed: _showAddReportDialog,
              heroTag: 'add_report',
              icon: const Icon(Icons.add_alert),
              label: const Text('Dodaj raport'),
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
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.primary,
                      size: AppSpacing.m,
                    ),
                    SizedBox(width: AppSpacing.s),
                    Expanded(
                      child: AppText(
                        'Kraków - miasto królów. Kliknij na znaczniki, aby dowiedzieć się więcej o miejscach.',
                        variant: AppTextVariant.caption,
                      ),
                    ),
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
