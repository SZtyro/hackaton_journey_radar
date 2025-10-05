import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:journey_radar_mobile/config/config.dart';
import 'package:journey_radar_mobile/entity/entity.dart';
import 'package:journey_radar_mobile/generated/locale_keys.g.dart';
import 'package:journey_radar_mobile/repository/repository.dart';
import 'package:journey_radar_mobile/config/service_locator.dart';
import 'package:latlong2/latlong.dart';
import 'package:journey_radar_mobile/app_ui/app_spacing.dart';
import 'package:journey_radar_mobile/app_ui/components/components.dart';
import 'package:journey_radar_mobile/services/location_service.dart';

/// Enhanced MapPage with API integration for loading map points and bus routes from backend.
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
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
          MarkerStyles.mapPoint(
            point: point.position,
            onTap: () => _showPointInfo(point),
            iconData: _getIconForType(point.iconType),
            backgroundColor: _parseColor(point.color),
            size: MarkerSize.extraSmall,
          ),
        );
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
              '${LocaleKeys.coordinates.tr()}: ${point.position.latitude.toStringAsFixed(4)}, ${point.position.longitude.toStringAsFixed(4)}',
              variant: AppTextVariant.caption,
            ),
            AppText(
              '${LocaleKeys.createdAt.tr()}: ${point.createdAt.toString().split(' ')[0]}',
              variant: AppTextVariant.caption,
            ),
          ],
        ),
        actions: [
          AppButton(
            text: LocaleKeys.close.tr(),
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

  void _refreshData() {
    _loadMapData();
  }

  void _alignToNorth() {
    _mapController.rotate(0.0);
  }

  void _zoomIn() {
    final currentZoom = _mapController.camera.zoom;
    final newZoom = (currentZoom + 1).clamp(8.0, 18.0);
    _mapController.move(
      _mapController.camera.center,
      newZoom,
    );
  }

  void _zoomOut() {
    final currentZoom = _mapController.camera.zoom;
    final newZoom = (currentZoom - 1).clamp(8.0, 18.0);
    _mapController.move(
      _mapController.camera.center,
      newZoom,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appName),
        actions: [
          AppIcon(
            icon: _isLoadingLocation
                ? Icons.location_searching
                : Icons.my_location,
            onPressed: _centerOnUserLocation,
            tooltip: LocaleKeys.myLocation.tr(),
          ),
          SizedBox(width: AppSpacing.s),
          AppIcon(
            icon: Icons.refresh,
            onPressed: _refreshData,
            tooltip: LocaleKeys.refresh.tr(),
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
              // Enable smooth animations
              cameraConstraint: CameraConstraint.contain(
                bounds: LatLngBounds(
                  const LatLng(49.0, 19.0),
                  const LatLng(51.0, 21.0),
                ),
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
                    MarkerStyles.userLocation(
                      point: _userLocation!,
                      onTap: () => _centerOnUserLocation(),
                      size: MarkerSize.extraSmall,
                    ),
                  ],
                ),
            ],
          ),

          // Loading indicator
          if (_isLoadingData)
            AppLoading(
              message: LocaleKeys.loading.tr(),
              variant: AppLoadingVariant.circular,
              size: AppLoadingSize.medium,
            ),

          // Error message
          if (_errorMessage != null)
            Positioned(
              top: AppSpacing.m,
              left: AppSpacing.m,
              right: AppSpacing.m,
              child: AppCard(
                variant: AppCardVariant.elevated,
                child: Row(
                  children: [
                    AppIcon(
                      icon: Icons.error,
                      variant: AppIconVariant.error,
                      size: AppIconSize.medium,
                    ),
                    SizedBox(width: AppSpacing.s),
                    Expanded(
                      child: AppText(
                        _errorMessage!,
                        variant: AppTextVariant.error,
                      ),
                    ),
                    SizedBox(width: AppSpacing.s),
                    AppButton(
                      text: LocaleKeys.refresh.tr(),
                      variant: AppButtonVariant.primary,
                      size: AppButtonSize.small,
                      onPressed: _refreshData,
                    ),
                  ],
                ),
              ),
            ),

          // Floating Action Buttons for map controls
          Positioned(
            right: AppSpacing.m,
            bottom: AppSpacing.m,
            child: Column(
              children: [
                // Compass button
                AppMiniFloatingActionButton(
                  icon: Icons.navigation,
                  onPressed: _alignToNorth,
                  tooltip: LocaleKeys.alignNorth.tr(),
                  variant: AppFABVariant.surface,
                ),
                SizedBox(height: AppSpacing.s),
                // Zoom in button
                AppMiniFloatingActionButton(
                  icon: Icons.add,
                  onPressed: _zoomIn,
                  tooltip: LocaleKeys.zoomIn.tr(),
                  variant: AppFABVariant.surface,
                ),
                SizedBox(height: AppSpacing.s),
                // Zoom out button
                AppMiniFloatingActionButton(
                  icon: Icons.remove,
                  onPressed: _zoomOut,
                  tooltip: LocaleKeys.zoomOut.tr(),
                  variant: AppFABVariant.surface,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
