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

  List<Marker> _buildGtfsStopMarkers(List<GtfsStopEntity> stops) {
    return stops.map((stop) {
      return AppMarkerHelper.busStop(
        point: stop.position,
        onTap: () => _showGtfsStopInfo(stop),
        size: MarkerSize.small,
      );
    }).toList();
  }

  List<Polyline> _buildAllGtfsRoutePolylines(
      List<GtfsShapeEntity> shapes, List<GtfsRouteEntity>? routes) {
    if (shapes.isEmpty) return [];

    // Grupuj kształty według shapeId
    final Map<String, List<GtfsShapeEntity>> groupedShapes = {};
    for (final shape in shapes) {
      groupedShapes.putIfAbsent(shape.shapeId, () => []).add(shape);
    }

    List<Polyline> polylines = [];

    for (final entry in groupedShapes.entries) {
      final shapeId = entry.key;
      final shapeList = entry.value;

      // Sortuj według sekwencji
      shapeList.sort((a, b) => a.sequence.compareTo(b.sequence));

      // Znajdź kolor trasy
      String routeColor = '#000000';
      if (routes != null) {
        // Mapuj shapeId do routeId (uproszczona logika)
        final routeId = shapeId.replaceAll('shape_', 'route_');
        final route = routes.firstWhere(
          (r) => r.routeId == routeId,
          orElse: () => routes.first,
        );
        routeColor = route.routeColor ?? '#000000';
      }

      polylines.add(
        Polyline(
          points: shapeList.map((shape) => shape.position).toList(),
          color: _parseColor(routeColor),
          strokeWidth: 4.0,
        ),
      );
    }

    return polylines;
  }

  Color _parseColor(String colorString) {
    return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
  }

  void _showGtfsStopInfo(GtfsStopEntity stop) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText(
          stop.stopName,
          variant: AppTextVariant.title,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (stop.stopCode != null) ...[
              AppText(
                'Kod przystanku: ${stop.stopCode}',
                variant: AppTextVariant.body,
              ),
              SizedBox(height: AppSpacing.s),
            ],
            AppText(
              'Współrzędne: ${stop.position.latitude.toStringAsFixed(4)}, ${stop.position.longitude.toStringAsFixed(4)}',
              variant: AppTextVariant.caption,
            ),
            if (stop.wheelchairBoarding != null) ...[
              SizedBox(height: AppSpacing.s),
              AppText(
                'Dostępność dla wózków: ${_getWheelchairAccessibilityText(stop.wheelchairBoarding!)}',
                variant: AppTextVariant.caption,
              ),
            ],
          ],
        ),
        actions: [
          AppButton(
            text: LocaleKeys.schedule.tr(),
            variant: AppButtonVariant.primary,
            onPressed: () {
              Navigator.of(context).pop();
              _showGtfsSchedule(stop);
            },
          ),
          AppButton(
            text: LocaleKeys.close.tr(),
            variant: AppButtonVariant.secondary,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showGtfsSchedule(GtfsStopEntity stop) {
    // Pobierz rozkład jazdy dla przystanku
    context
        .read<MapCubit>()
        .getGtfsScheduleForStop(stopId: stop.stopId, limit: 10);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText(
          'Rozkład jazdy - ${stop.stopName}',
          variant: AppTextVariant.title,
        ),
        content: BlocBuilder<MapCubit, MapState>(
          builder: (context, state) {
            if (state.getGtfsScheduleStatus == StateStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.gtfsSchedule == null || state.gtfsSchedule!.isEmpty) {
              return const AppText('Brak danych o rozkładzie jazdy');
            }

            return SizedBox(
              width: double.maxFinite,
              height: 300,
              child: ListView.builder(
                itemCount: state.gtfsSchedule!.length,
                itemBuilder: (context, index) {
                  final schedule = state.gtfsSchedule![index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _parseColor(schedule.routeColor ?? '#000000'),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            schedule.routeShortName ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      title: Text(schedule.routeLongName ?? ''),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Kierunek: ${schedule.tripHeadsign ?? ''}'),
                          if (schedule.delaySeconds != null &&
                              schedule.delaySeconds! > 0)
                            Text(
                              'Opóźnienie: ${_formatDelay(schedule.delaySeconds!)}',
                              style: const TextStyle(color: Colors.red),
                            ),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            schedule.realTimeArrivalTime ??
                                schedule.scheduledArrivalTime ??
                                '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (schedule.isRealTime)
                            const Icon(Icons.access_time,
                                color: Colors.green, size: 16),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
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

  String _getWheelchairAccessibilityText(int accessibility) {
    switch (accessibility) {
      case 0:
        return 'Nieznane';
      case 1:
        return 'Dostępne';
      case 2:
        return 'Niedostępne';
      default:
        return 'Nieznane';
    }
  }

  String _formatDelay(int delaySeconds) {
    if (delaySeconds < 60) {
      return '${delaySeconds}s';
    } else {
      final minutes = delaySeconds ~/ 60;
      final seconds = delaySeconds % 60;
      return '${minutes}m ${seconds}s';
    }
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
    context.read<MapCubit>().getGtfsRoutes(limit: 10);
    context.read<MapCubit>().getGtfsStops(limit: 20);
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
                  // Trasy GTFS
                  if (state.gtfsShapes != null && state.gtfsShapes!.isNotEmpty)
                    PolylineLayer(
                      polylines: _buildAllGtfsRoutePolylines(
                          state.gtfsShapes!, state.gtfsRoutes),
                    ),
                  // Markery przystanków GTFS
                  if (state.gtfsStops != null)
                    MarkerLayer(
                        markers: _buildGtfsStopMarkers(state.gtfsStops!)),
                  // Marker lokalizacji użytkownika
                  if (state.currentLocation != null)
                    MarkerLayer(
                      markers: [
                        AppMarkerHelper.userLocation(
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
                  state.getBusRoutesStatus == StateStatus.loading ||
                  state.getGtfsRoutesStatus == StateStatus.loading ||
                  state.getGtfsStopsStatus == StateStatus.loading)
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
