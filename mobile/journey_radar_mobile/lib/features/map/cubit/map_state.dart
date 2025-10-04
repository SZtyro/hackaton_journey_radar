part of 'map_cubit.dart';

class MapState extends Equatable {
  final StateStatus getLocationStatus;
  final StateStatus getMapPointsStatus;
  final StateStatus getBusRoutesStatus;
  final StateStatus searchMapPointsStatus;
  final StateStatus getNearbyMapPointsStatus;

  final LatLng? currentLocation;
  final List<MapPointEntity>? mapPoints;
  final List<BusRouteEntity>? busRoutes;
  final List<MapPointEntity>? searchResults;
  final List<MapPointEntity>? nearbyMapPoints;

  final MapPointEntity? selectedMapPoint;
  final BusRouteEntity? selectedBusRoute;

  final Exception? exception;

  const MapState({
    this.getLocationStatus = StateStatus.initial,
    this.getMapPointsStatus = StateStatus.initial,
    this.getBusRoutesStatus = StateStatus.initial,
    this.searchMapPointsStatus = StateStatus.initial,
    this.getNearbyMapPointsStatus = StateStatus.initial,
    this.currentLocation,
    this.mapPoints,
    this.busRoutes,
    this.searchResults,
    this.nearbyMapPoints,
    this.selectedMapPoint,
    this.selectedBusRoute,
    this.exception,
  });

  MapState copyWith({
    StateStatus? getLocationStatus,
    StateStatus? getMapPointsStatus,
    StateStatus? getBusRoutesStatus,
    StateStatus? searchMapPointsStatus,
    StateStatus? getNearbyMapPointsStatus,
    LatLng? currentLocation,
    List<MapPointEntity>? mapPoints,
    List<BusRouteEntity>? busRoutes,
    List<MapPointEntity>? searchResults,
    List<MapPointEntity>? nearbyMapPoints,
    MapPointEntity? selectedMapPoint,
    BusRouteEntity? selectedBusRoute,
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
      currentLocation: currentLocation ?? this.currentLocation,
      mapPoints: mapPoints ?? this.mapPoints,
      busRoutes: busRoutes ?? this.busRoutes,
      searchResults: searchResults ?? this.searchResults,
      nearbyMapPoints: nearbyMapPoints ?? this.nearbyMapPoints,
      selectedMapPoint: selectedMapPoint ?? this.selectedMapPoint,
      selectedBusRoute: selectedBusRoute ?? this.selectedBusRoute,
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
        currentLocation,
        mapPoints,
        busRoutes,
        searchResults,
        nearbyMapPoints,
        selectedMapPoint,
        selectedBusRoute,
        exception,
      ];
}
