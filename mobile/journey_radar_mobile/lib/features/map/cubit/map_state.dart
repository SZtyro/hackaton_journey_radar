part of 'map_cubit.dart';

class MapState extends Equatable {
  final StateStatus getLocationStatus;
  final StateStatus getMapPointsStatus;
  final StateStatus getBusRoutesStatus;
  final StateStatus searchMapPointsStatus;
  final StateStatus getNearbyMapPointsStatus;

  // GTFS statuses
  final StateStatus getGtfsRoutesStatus;
  final StateStatus getGtfsStopsStatus;
  final StateStatus getGtfsShapesStatus;
  final StateStatus getGtfsScheduleStatus;
  final StateStatus getGtfsDelaysStatus;

  final LatLng? currentLocation;
  final List<MapPointEntity>? mapPoints;
  final List<BusRouteEntity>? busRoutes;
  final List<MapPointEntity>? searchResults;
  final List<MapPointEntity>? nearbyMapPoints;

  // GTFS data
  final List<GtfsRouteEntity>? gtfsRoutes;
  final List<GtfsStopEntity>? gtfsStops;
  final List<GtfsShapeEntity>? gtfsShapes;
  final List<GtfsScheduleWithDelaysEntity>? gtfsSchedule;
  final List<GtfsDelayEntity>? gtfsDelays;

  final MapPointEntity? selectedMapPoint;
  final BusRouteEntity? selectedBusRoute;
  final GtfsStopEntity? selectedGtfsStop;
  final GtfsRouteEntity? selectedGtfsRoute;

  final Exception? exception;

  const MapState({
    this.getLocationStatus = StateStatus.initial,
    this.getMapPointsStatus = StateStatus.initial,
    this.getBusRoutesStatus = StateStatus.initial,
    this.searchMapPointsStatus = StateStatus.initial,
    this.getNearbyMapPointsStatus = StateStatus.initial,
    this.getGtfsRoutesStatus = StateStatus.initial,
    this.getGtfsStopsStatus = StateStatus.initial,
    this.getGtfsShapesStatus = StateStatus.initial,
    this.getGtfsScheduleStatus = StateStatus.initial,
    this.getGtfsDelaysStatus = StateStatus.initial,
    this.currentLocation,
    this.mapPoints,
    this.busRoutes,
    this.searchResults,
    this.nearbyMapPoints,
    this.gtfsRoutes,
    this.gtfsStops,
    this.gtfsShapes,
    this.gtfsSchedule,
    this.gtfsDelays,
    this.selectedMapPoint,
    this.selectedBusRoute,
    this.selectedGtfsStop,
    this.selectedGtfsRoute,
    this.exception,
  });

  MapState copyWith({
    StateStatus? getLocationStatus,
    StateStatus? getMapPointsStatus,
    StateStatus? getBusRoutesStatus,
    StateStatus? searchMapPointsStatus,
    StateStatus? getNearbyMapPointsStatus,
    StateStatus? getGtfsRoutesStatus,
    StateStatus? getGtfsStopsStatus,
    StateStatus? getGtfsShapesStatus,
    StateStatus? getGtfsScheduleStatus,
    StateStatus? getGtfsDelaysStatus,
    LatLng? currentLocation,
    List<MapPointEntity>? mapPoints,
    List<BusRouteEntity>? busRoutes,
    List<MapPointEntity>? searchResults,
    List<MapPointEntity>? nearbyMapPoints,
    List<GtfsRouteEntity>? gtfsRoutes,
    List<GtfsStopEntity>? gtfsStops,
    List<GtfsShapeEntity>? gtfsShapes,
    List<GtfsScheduleWithDelaysEntity>? gtfsSchedule,
    List<GtfsDelayEntity>? gtfsDelays,
    MapPointEntity? selectedMapPoint,
    BusRouteEntity? selectedBusRoute,
    GtfsStopEntity? selectedGtfsStop,
    GtfsRouteEntity? selectedGtfsRoute,
    Exception? exception,
  }) {
    return MapState(
      getLocationStatus: getLocationStatus ?? this.getLocationStatus,
      getMapPointsStatus: getMapPointsStatus ?? this.getMapPointsStatus,
      getBusRoutesStatus: getBusRoutesStatus ?? this.getBusRoutesStatus,
      searchMapPointsStatus:
          searchMapPointsStatus ?? this.searchMapPointsStatus,
      getNearbyMapPointsStatus:
          getNearbyMapPointsStatus ?? this.getNearbyMapPointsStatus,
      getGtfsRoutesStatus: getGtfsRoutesStatus ?? this.getGtfsRoutesStatus,
      getGtfsStopsStatus: getGtfsStopsStatus ?? this.getGtfsStopsStatus,
      getGtfsShapesStatus: getGtfsShapesStatus ?? this.getGtfsShapesStatus,
      getGtfsScheduleStatus:
          getGtfsScheduleStatus ?? this.getGtfsScheduleStatus,
      getGtfsDelaysStatus: getGtfsDelaysStatus ?? this.getGtfsDelaysStatus,
      currentLocation: currentLocation ?? this.currentLocation,
      mapPoints: mapPoints ?? this.mapPoints,
      busRoutes: busRoutes ?? this.busRoutes,
      searchResults: searchResults ?? this.searchResults,
      nearbyMapPoints: nearbyMapPoints ?? this.nearbyMapPoints,
      gtfsRoutes: gtfsRoutes ?? this.gtfsRoutes,
      gtfsStops: gtfsStops ?? this.gtfsStops,
      gtfsShapes: gtfsShapes ?? this.gtfsShapes,
      gtfsSchedule: gtfsSchedule ?? this.gtfsSchedule,
      gtfsDelays: gtfsDelays ?? this.gtfsDelays,
      selectedMapPoint: selectedMapPoint ?? this.selectedMapPoint,
      selectedBusRoute: selectedBusRoute ?? this.selectedBusRoute,
      selectedGtfsStop: selectedGtfsStop ?? this.selectedGtfsStop,
      selectedGtfsRoute: selectedGtfsRoute ?? this.selectedGtfsRoute,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [
        getLocationStatus,
        getMapPointsStatus,
        getBusRoutesStatus,
        searchMapPointsStatus,
        getNearbyMapPointsStatus,
        getGtfsRoutesStatus,
        getGtfsStopsStatus,
        getGtfsShapesStatus,
        getGtfsScheduleStatus,
        getGtfsDelaysStatus,
        currentLocation,
        mapPoints,
        busRoutes,
        searchResults,
        nearbyMapPoints,
        gtfsRoutes,
        gtfsStops,
        gtfsShapes,
        gtfsSchedule,
        gtfsDelays,
        selectedMapPoint,
        selectedBusRoute,
        selectedGtfsStop,
        selectedGtfsRoute,
        exception,
      ];
}
