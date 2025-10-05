import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:journey_radar_mobile/config/config.dart';
import 'package:journey_radar_mobile/entity/entity.dart';
import 'package:journey_radar_mobile/generated/locale_keys.g.dart';
import 'package:journey_radar_mobile/repository/repository.dart';
import 'package:journey_radar_mobile/config/service_locator.dart';
import 'package:journey_radar_mobile/app_ui/app_spacing.dart';
import 'package:journey_radar_mobile/app_ui/components/components.dart';
import 'package:journey_radar_mobile/services/location_service.dart';
import 'package:journey_radar_mobile/features/map/cubit/map_cubit.dart';
import 'package:journey_radar_mobile/shared/state_status.dart';
import 'package:journey_radar_mobile/config/constants.dart';

/// Enhanced MapPage with API integration for loading map points and bus routes from backend.
class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapCubit(
        mapRepository: getIt<Repository>(),
        locationService: getIt<LocationService>(),
      )..initialCubitLoad(),
      child: const _MapPageView(),
    );
  }
}

class _MapPageView extends StatefulWidget {
  const _MapPageView();

  @override
  State<_MapPageView> createState() => _MapPageViewState();
}

class _MapPageViewState extends State<_MapPageView> {
  final MapController _mapController = MapController();

  List<Marker> _buildMarkers(List<MapPointEntity> mapPoints) {
    return mapPoints.map((point) {
      return MarkerStyles.mapPoint(
        point: point.position,
        onTap: () => _showPointInfo(point),
        iconData: _getIconForType(point.iconType),
        backgroundColor: _parseColor(point.color),
        size: MarkerSize.extraSmall,
      );
    }).toList();
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

  void _centerOnUserLocation(BuildContext context) {
    final state = context.read<MapCubit>().state;
    if (state.currentLocation != null) {
      _mapController.move(
          state.currentLocation!, MapConstants.userLocationZoom);
    } else {
      context.read<MapCubit>().getCurrentLocation();
    }
  }

  void _refreshData(BuildContext context) {
    context
        .read<MapCubit>()
        .getMapPoints(limit: MapConstants.defaultMapPointsLimit);
    context
        .read<MapCubit>()
        .getBusRoutes(limit: MapConstants.defaultBusRoutesLimit);
  }

  void _alignToNorth() {
    _mapController.rotate(MapConstants.northRotation);
  }

  void _zoomIn() {
    final currentZoom = _mapController.camera.zoom;
    final newZoom = (currentZoom + MapConstants.zoomStep)
        .clamp(MapConstants.minZoom, MapConstants.maxZoom);
    _mapController.move(
      _mapController.camera.center,
      newZoom,
    );
  }

  void _zoomOut() {
    final currentZoom = _mapController.camera.zoom;
    final newZoom = (currentZoom - MapConstants.zoomStep)
        .clamp(MapConstants.minZoom, MapConstants.maxZoom);
    _mapController.move(
      _mapController.camera.center,
      newZoom,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppConstants.appName),
            actions: [
              AppIcon(
                icon: state.getLocationStatus == StateStatus.loading
                    ? Icons.location_searching
                    : Icons.my_location,
                onPressed: () => _centerOnUserLocation(context),
                tooltip: LocaleKeys.myLocation.tr(),
              ),
              SizedBox(width: AppSpacing.s),
              AppIcon(
                icon: Icons.refresh,
                onPressed: () => _refreshData(context),
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
                  initialCenter: MapConstants.krakowCenter,
                  initialZoom: MapConstants.initialZoom,
                  minZoom: MapConstants.minZoom,
                  maxZoom: MapConstants.maxZoom,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                  // Enable smooth animations
                  cameraConstraint: CameraConstraint.contain(
                    bounds: MapConstants.krakowBounds,
                  ),
                ),
                children: [
                  // OpenStreetMap tiles
                  TileLayer(
                    urlTemplate: MapConstants.openStreetMapUrl,
                    userAgentPackageName: MapConstants.userAgentPackageName,
                    maxZoom: MapConstants.maxZoom,
                    subdomains: MapConstants.tileSubdomains,
                  ),
                  // Trasy autobusowe
                  if (state.busRoutes != null)
                    ...state.busRoutes!.map((route) => PolylineLayer(
                          polylines: [
                            Polyline(
                              points: route.coordinates,
                              color: _parseColor(route.color),
                              strokeWidth: MapConstants.busRouteStrokeWidth,
                            ),
                          ],
                        )),
                  // Markery punktów
                  if (state.mapPoints != null)
                    MarkerLayer(markers: _buildMarkers(state.mapPoints!)),
                  // Marker lokalizacji użytkownika
                  if (state.currentLocation != null)
                    MarkerLayer(
                      markers: [
                        MarkerStyles.userLocation(
                          point: state.currentLocation!,
                          onTap: () => _centerOnUserLocation(context),
                          size: MarkerSize.extraSmall,
                        ),
                      ],
                    ),
                ],
              ),

              // Loading indicator
              if (state.getMapPointsStatus == StateStatus.loading ||
                  state.getBusRoutesStatus == StateStatus.loading)
                AppLoading(
                  message: LocaleKeys.loading.tr(),
                  variant: AppLoadingVariant.circular,
                  size: AppLoadingSize.medium,
                ),

              // Error message
              if (state.exception != null)
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
                            state.exception.toString(),
                            variant: AppTextVariant.error,
                          ),
                        ),
                        SizedBox(width: AppSpacing.s),
                        AppButton(
                          text: LocaleKeys.refresh.tr(),
                          variant: AppButtonVariant.primary,
                          size: AppButtonSize.small,
                          onPressed: () => _refreshData(context),
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
      },
    );
  }
}
