import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:journey_radar_mobile/entity/entity.dart';
import 'package:journey_radar_mobile/repository/repository.dart';
import 'package:journey_radar_mobile/config/service_locator.dart';
import 'package:latlong2/latlong.dart';
import 'package:journey_radar_mobile/app_ui/app_spacing.dart';
import 'package:journey_radar_mobile/app_ui/components/components.dart';
import 'package:journey_radar_mobile/services/location_service.dart';

/// Enhanced MapPage with API integration for loading map points and bus routes from backend.
class MapPageWithApi extends StatefulWidget {
  const MapPageWithApi({super.key});

  @override
  State<MapPageWithApi> createState() => _MapPageWithApiState();
}

class _MapPageWithApiState extends State<MapPageWithApi> {
  final MapController _mapController = MapController();
  final List<Marker> _markers = [];
  List<BusRouteEntity> _busRoutes = [];
  final LocationService _locationService = LocationService();

  LatLng? _userLocation;
  bool _isLoadingLocation = false;
  bool _isLoadingData = false;
  String? _errorMessage;

  late final Repository _mapRepository;

  @override
  void initState() {
    super.initState();
    // Get repository from main service locator
    _mapRepository = getIt<Repository>();
    _initializeLocation();
    _loadMapData();
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

  Future<void> _loadMapData() async {
    setState(() {
      _isLoadingData = true;
      _errorMessage = null;
    });

    try {
      // Load map points and bus routes from API
      final mapPointsResult = await _mapRepository.getMapPoints(limit: 50);
      final busRoutesResult = await _mapRepository.getBusRoutes(limit: 20);

      if (mapPointsResult is Success<List<MapPointEntity>, Exception>) {
        _updateMapPoints(mapPointsResult.data);
      }

      if (busRoutesResult is Success<List<BusRouteEntity>, Exception>) {
        setState(() {
          _busRoutes = busRoutesResult.data;
        });
      }

      if (mapPointsResult is Failure<List<MapPointEntity>, Exception> ||
          busRoutesResult is Failure<List<BusRouteEntity>, Exception>) {
        setState(() {
          _errorMessage = 'Błąd podczas ładowania danych z serwera';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Błąd: $e';
      });
    } finally {
      setState(() {
        _isLoadingData = false;
      });
    }
  }

  void _updateMapPoints(List<MapPointEntity> mapPoints) {
    setState(() {
      _markers.clear();

      for (final point in mapPoints) {
        _markers.add(
          Marker(
            point: point.position,
            width: 40,
            height: 40,
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
    });
  }

  void _updateBusRoutes(List<BusRouteEntity> busRoutes) {
    // Bus routes will be displayed as polylines in the map
    // This would be implemented in the FlutterMap children
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
            AppText(
              'Utworzono: ${point.createdAt.toString().split(' ')[0]}',
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
        ],
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

  void _refreshData() {
    _loadMapData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa Krakowa (${useMockApi ? 'Mock API' : 'Real API'})'),
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
          AppIcon(
            icon: Icons.refresh,
            onPressed: _refreshData,
            tooltip: 'Odśwież dane',
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
              initialCenter: const LatLng(50.0647, 19.9450),
              initialZoom: 13.0,
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
              // Trasy autobusowe
              ..._busRoutes.map((route) => PolylineLayer(
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

          // Loading indicator
          if (_isLoadingData)
            const Center(
              child: CircularProgressIndicator(),
            ),

          // Error message
          if (_errorMessage != null)
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
                        Icons.error,
                        color: Colors.red,
                        size: AppSpacing.m,
                      ),
                      SizedBox(width: AppSpacing.s),
                      Expanded(
                        child: AppText(
                          _errorMessage!,
                          variant: AppTextVariant.body,
                        ),
                      ),
                      AppButton(
                        text: 'Odśwież',
                        variant: AppButtonVariant.primary,
                        onPressed: _refreshData,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Info card
          Positioned(
            bottom: AppSpacing.m,
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
                            'Mapa z ${useMockApi ? 'Mock API' : 'Real API'} - Funkcje',
                            variant: AppTextVariant.subtitle,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.s),
                    AppText(
                      '• Dane ładowane z ${useMockApi ? 'mock API (symulacja backendu)' : 'prawdziwego API'}',
                      variant: AppTextVariant.caption,
                    ),
                    AppText(
                      '• Kliknij na punkty, aby zobaczyć szczegóły',
                      variant: AppTextVariant.caption,
                    ),
                    AppText(
                      '• Użyj przycisku odświeżania, aby załadować nowe dane',
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
