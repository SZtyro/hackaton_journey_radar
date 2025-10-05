import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:journey_radar_mobile/repository/repository.dart';
import 'package:journey_radar_mobile/entity/entity.dart';
import 'package:journey_radar_mobile/api/mock_map_api.dart';
import 'package:journey_radar_mobile/api/api.dart';
import 'package:journey_radar_mobile/dto/dto.dart';

/// Implementation of Repository that can use either real API or mock API.
class RepositoryImpl implements Repository {
  RepositoryImpl({
    required this.useMockApi,
    this.dio,
    this.baseUrl,
    this.api,
  });

  /// Flag to determine whether to use mock API or real API
  final bool useMockApi;

  /// Dio instance for real API calls (only used when useMockApi is false)
  final Dio? dio;

  /// Base URL for real API (only used when useMockApi is false)
  final String? baseUrl;

  /// API instance for real API calls (only used when useMockApi is false)
  final Api? api;

  // Map Points operations
  @override
  Future<Result<List<MapPointEntity>, Exception>> getMapPoints({
    int? limit,
    int? offset,
    String? iconType,
  }) async {
    if (useMockApi) {
      return _getMapPointsFromMock(
          limit: limit, offset: offset, iconType: iconType);
    } else {
      return _getMapPointsFromRealApi(
          limit: limit, offset: offset, iconType: iconType);
    }
  }

  @override
  Future<Result<MapPointEntity, Exception>> getMapPoint({
    required String id,
  }) async {
    if (useMockApi) {
      return _getMapPointFromMock(id: id);
    } else {
      return _getMapPointFromRealApi(id: id);
    }
  }

  @override
  Future<Result<MapPointEntity, Exception>> createMapPoint({
    required MapPointEntity mapPoint,
  }) async {
    if (useMockApi) {
      return _createMapPointFromMock(mapPoint: mapPoint);
    } else {
      return _createMapPointFromRealApi(mapPoint: mapPoint);
    }
  }

  @override
  Future<Result<MapPointEntity, Exception>> updateMapPoint({
    required String id,
    required MapPointEntity mapPoint,
  }) async {
    if (useMockApi) {
      return _updateMapPointFromMock(id: id, mapPoint: mapPoint);
    } else {
      return _updateMapPointFromRealApi(id: id, mapPoint: mapPoint);
    }
  }

  @override
  Future<Result<void, Exception>> deleteMapPoint({
    required String id,
  }) async {
    if (useMockApi) {
      return _deleteMapPointFromMock(id: id);
    } else {
      return _deleteMapPointFromRealApi(id: id);
    }
  }

  @override
  Future<Result<List<MapPointEntity>, Exception>> searchMapPoints({
    required String query,
    int? limit,
    int? offset,
  }) async {
    if (useMockApi) {
      return _searchMapPointsFromMock(
          query: query, limit: limit, offset: offset);
    } else {
      return _searchMapPointsFromRealApi(
          query: query, limit: limit, offset: offset);
    }
  }

  @override
  Future<Result<List<MapPointEntity>, Exception>> getNearbyMapPoints({
    required LatLng location,
    double? radius,
    int? limit,
  }) async {
    if (useMockApi) {
      return _getNearbyMapPointsFromMock(
          location: location, radius: radius, limit: limit);
    } else {
      return _getNearbyMapPointsFromRealApi(
          location: location, radius: radius, limit: limit);
    }
  }

  // Bus Routes operations
  @override
  Future<Result<List<BusRouteEntity>, Exception>> getBusRoutes({
    int? limit,
    int? offset,
    String? number,
  }) async {
    if (useMockApi) {
      return _getBusRoutesFromMock(
          limit: limit, offset: offset, number: number);
    } else {
      return _getBusRoutesFromRealApi(
          limit: limit, offset: offset, number: number);
    }
  }

  @override
  Future<Result<BusRouteEntity, Exception>> getBusRoute({
    required String id,
  }) async {
    if (useMockApi) {
      return _getBusRouteFromMock(id: id);
    } else {
      return _getBusRouteFromRealApi(id: id);
    }
  }

  @override
  Future<Result<BusRouteEntity, Exception>> createBusRoute({
    required BusRouteEntity busRoute,
  }) async {
    if (useMockApi) {
      return _createBusRouteFromMock(busRoute: busRoute);
    } else {
      return _createBusRouteFromRealApi(busRoute: busRoute);
    }
  }

  @override
  Future<Result<BusRouteEntity, Exception>> updateBusRoute({
    required String id,
    required BusRouteEntity busRoute,
  }) async {
    if (useMockApi) {
      return _updateBusRouteFromMock(id: id, busRoute: busRoute);
    } else {
      return _updateBusRouteFromRealApi(id: id, busRoute: busRoute);
    }
  }

  @override
  Future<Result<void, Exception>> deleteBusRoute({
    required String id,
  }) async {
    if (useMockApi) {
      return _deleteBusRouteFromMock(id: id);
    } else {
      return _deleteBusRouteFromRealApi(id: id);
    }
  }

  @override
  Future<Result<List<BusRouteEntity>, Exception>> searchBusRoutes({
    required String query,
    int? limit,
    int? offset,
  }) async {
    if (useMockApi) {
      return _searchBusRoutesFromMock(
          query: query, limit: limit, offset: offset);
    } else {
      return _searchBusRoutesFromRealApi(
          query: query, limit: limit, offset: offset);
    }
  }

  @override
  Future<Result<List<BusRouteEntity>, Exception>> getNearbyBusRoutes({
    required LatLng location,
    double? radius,
    int? limit,
  }) async {
    if (useMockApi) {
      return _getNearbyBusRoutesFromMock(
          location: location, radius: radius, limit: limit);
    } else {
      return _getNearbyBusRoutesFromRealApi(
          location: location, radius: radius, limit: limit);
    }
  }

  // Mock API implementations
  Future<Result<List<MapPointEntity>, Exception>> _getMapPointsFromMock({
    int? limit,
    int? offset,
    String? iconType,
  }) async {
    try {
      final mapPoints = await MockMapApi.getMapPoints(
        limit: limit,
        offset: offset,
        iconType: iconType,
      );
      return Success(mapPoints);
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<MapPointEntity, Exception>> _getMapPointFromMock({
    required String id,
  }) async {
    try {
      final mapPoint = await MockMapApi.getMapPoint(id);
      if (mapPoint != null) {
        return Success(mapPoint);
      } else {
        return Failure(Exception('Map point with id $id not found'));
      }
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<MapPointEntity, Exception>> _createMapPointFromMock({
    required MapPointEntity mapPoint,
  }) async {
    try {
      final createdPoint = await MockMapApi.createMapPoint(mapPoint);
      return Success(createdPoint);
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<MapPointEntity, Exception>> _updateMapPointFromMock({
    required String id,
    required MapPointEntity mapPoint,
  }) async {
    try {
      final updatedPoint = await MockMapApi.updateMapPoint(id, mapPoint);
      if (updatedPoint != null) {
        return Success(updatedPoint);
      } else {
        return Failure(Exception('Map point with id $id not found'));
      }
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<void, Exception>> _deleteMapPointFromMock({
    required String id,
  }) async {
    try {
      final deleted = await MockMapApi.deleteMapPoint(id);
      if (deleted) {
        return const Success(null);
      } else {
        return Failure(Exception('Map point with id $id not found'));
      }
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<List<MapPointEntity>, Exception>> _searchMapPointsFromMock({
    required String query,
    int? limit,
    int? offset,
  }) async {
    try {
      final mapPoints = await MockMapApi.searchMapPoints(
        query: query,
        limit: limit,
        offset: offset,
      );
      return Success(mapPoints);
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<List<MapPointEntity>, Exception>> _getNearbyMapPointsFromMock({
    required LatLng location,
    double? radius,
    int? limit,
  }) async {
    try {
      final mapPoints = await MockMapApi.getNearbyMapPoints(
        location: location,
        radius: radius,
        limit: limit,
      );
      return Success(mapPoints);
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<List<BusRouteEntity>, Exception>> _getBusRoutesFromMock({
    int? limit,
    int? offset,
    String? number,
  }) async {
    try {
      final busRoutes = await MockMapApi.getBusRoutes(
        limit: limit,
        offset: offset,
        number: number,
      );
      return Success(busRoutes);
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<BusRouteEntity, Exception>> _getBusRouteFromMock({
    required String id,
  }) async {
    try {
      final busRoute = await MockMapApi.getBusRoute(id);
      if (busRoute != null) {
        return Success(busRoute);
      } else {
        return Failure(Exception('Bus route with id $id not found'));
      }
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<BusRouteEntity, Exception>> _createBusRouteFromMock({
    required BusRouteEntity busRoute,
  }) async {
    try {
      final createdRoute = await MockMapApi.createBusRoute(busRoute);
      return Success(createdRoute);
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<BusRouteEntity, Exception>> _updateBusRouteFromMock({
    required String id,
    required BusRouteEntity busRoute,
  }) async {
    try {
      final updatedRoute = await MockMapApi.updateBusRoute(id, busRoute);
      if (updatedRoute != null) {
        return Success(updatedRoute);
      } else {
        return Failure(Exception('Bus route with id $id not found'));
      }
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<void, Exception>> _deleteBusRouteFromMock({
    required String id,
  }) async {
    try {
      final deleted = await MockMapApi.deleteBusRoute(id);
      if (deleted) {
        return const Success(null);
      } else {
        return Failure(Exception('Bus route with id $id not found'));
      }
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<List<BusRouteEntity>, Exception>> _searchBusRoutesFromMock({
    required String query,
    int? limit,
    int? offset,
  }) async {
    try {
      final busRoutes = await MockMapApi.searchBusRoutes(
        query: query,
        limit: limit,
        offset: offset,
      );
      return Success(busRoutes);
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<List<BusRouteEntity>, Exception>> _getNearbyBusRoutesFromMock({
    required LatLng location,
    double? radius,
    int? limit,
  }) async {
    try {
      final busRoutes = await MockMapApi.getNearbyBusRoutes(
        location: location,
        radius: radius,
        limit: limit,
      );
      return Success(busRoutes);
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  // Real API implementations
  Future<Result<List<MapPointEntity>, Exception>> _getMapPointsFromRealApi({
    int? limit,
    int? offset,
    String? iconType,
  }) async {
    try {
      if (api == null) {
        return Failure(Exception('API instance not available'));
      }

      final response = await api!.getMapPoints(
        limit: limit,
        offset: offset,
        iconType: iconType,
      );

      final mapPoints = response.data.map((dto) => dto.toEntity()).toList();
      return Success(mapPoints);
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<MapPointEntity, Exception>> _getMapPointFromRealApi({
    required String id,
  }) async {
    try {
      if (api == null) {
        return Failure(Exception('API instance not available'));
      }

      final response = await api!.getMapPoint(id: id);
      return Success(response.data.toEntity());
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<MapPointEntity, Exception>> _createMapPointFromRealApi({
    required MapPointEntity mapPoint,
  }) async {
    try {
      if (api == null) {
        return Failure(Exception('API instance not available'));
      }

      final dto = MapPointDto.fromEntity(mapPoint);
      final response = await api!.createMapPoint(mapPoint: dto);
      return Success(response.data.toEntity());
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<MapPointEntity, Exception>> _updateMapPointFromRealApi({
    required String id,
    required MapPointEntity mapPoint,
  }) async {
    try {
      if (api == null) {
        return Failure(Exception('API instance not available'));
      }

      final dto = MapPointDto.fromEntity(mapPoint);
      final response = await api!.updateMapPoint(id: id, mapPoint: dto);
      return Success(response.data.toEntity());
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<void, Exception>> _deleteMapPointFromRealApi({
    required String id,
  }) async {
    try {
      if (api == null) {
        return Failure(Exception('API instance not available'));
      }

      await api!.deleteMapPoint(id: id);
      return const Success(null);
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<List<MapPointEntity>, Exception>> _searchMapPointsFromRealApi({
    required String query,
    int? limit,
    int? offset,
  }) async {
    try {
      if (api == null) {
        return Failure(Exception('API instance not available'));
      }

      final response = await api!.searchMapPoints(
        query: query,
        limit: limit,
        offset: offset,
      );

      final mapPoints = response.data.map((dto) => dto.toEntity()).toList();
      return Success(mapPoints);
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<List<MapPointEntity>, Exception>>
      _getNearbyMapPointsFromRealApi({
    required LatLng location,
    double? radius,
    int? limit,
  }) async {
    try {
      if (api == null) {
        return Failure(Exception('API instance not available'));
      }

      final response = await api!.getNearbyMapPoints(
        latitude: location.latitude,
        longitude: location.longitude,
        radius: radius,
        limit: limit,
      );

      final mapPoints = response.data.map((dto) => dto.toEntity()).toList();
      return Success(mapPoints);
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<List<BusRouteEntity>, Exception>> _getBusRoutesFromRealApi({
    int? limit,
    int? offset,
    String? number,
  }) async {
    try {
      if (api == null) {
        return Failure(Exception('API instance not available'));
      }

      final response = await api!.getBusRoutes(
        limit: limit,
        offset: offset,
        number: number,
      );

      final busRoutes = response.data.map((dto) => dto.toEntity()).toList();
      return Success(busRoutes);
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<BusRouteEntity, Exception>> _getBusRouteFromRealApi({
    required String id,
  }) async {
    try {
      if (api == null) {
        return Failure(Exception('API instance not available'));
      }

      final response = await api!.getBusRoute(id: id);
      return Success(response.data.toEntity());
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<BusRouteEntity, Exception>> _createBusRouteFromRealApi({
    required BusRouteEntity busRoute,
  }) async {
    try {
      if (api == null) {
        return Failure(Exception('API instance not available'));
      }

      final dto = BusRouteDto.fromEntity(busRoute);
      final response = await api!.createBusRoute(busRoute: dto);
      return Success(response.data.toEntity());
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<BusRouteEntity, Exception>> _updateBusRouteFromRealApi({
    required String id,
    required BusRouteEntity busRoute,
  }) async {
    try {
      if (api == null) {
        return Failure(Exception('API instance not available'));
      }

      final dto = BusRouteDto.fromEntity(busRoute);
      final response = await api!.updateBusRoute(id: id, busRoute: dto);
      return Success(response.data.toEntity());
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<void, Exception>> _deleteBusRouteFromRealApi({
    required String id,
  }) async {
    try {
      if (api == null) {
        return Failure(Exception('API instance not available'));
      }

      await api!.deleteBusRoute(id: id);
      return const Success(null);
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<List<BusRouteEntity>, Exception>> _searchBusRoutesFromRealApi({
    required String query,
    int? limit,
    int? offset,
  }) async {
    try {
      if (api == null) {
        return Failure(Exception('API instance not available'));
      }

      final response = await api!.searchBusRoutes(
        query: query,
        limit: limit,
        offset: offset,
      );

      final busRoutes = response.data.map((dto) => dto.toEntity()).toList();
      return Success(busRoutes);
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<List<BusRouteEntity>, Exception>>
      _getNearbyBusRoutesFromRealApi({
    required LatLng location,
    double? radius,
    int? limit,
  }) async {
    try {
      if (api == null) {
        return Failure(Exception('API instance not available'));
      }

      final response = await api!.getNearbyBusRoutes(
        latitude: location.latitude,
        longitude: location.longitude,
        radius: radius,
        limit: limit,
      );

      final busRoutes = response.data.map((dto) => dto.toEntity()).toList();
      return Success(busRoutes);
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  // GTFS operations
  @override
  Future<Result<List<GtfsRouteEntity>, Exception>> getGtfsRoutes({
    int? limit,
    int? offset,
    String? routeType,
  }) async {
    if (useMockApi) {
      return _getGtfsRoutesFromMock(
          limit: limit, offset: offset, routeType: routeType);
    } else {
      return _getGtfsRoutesFromRealApi(
          limit: limit, offset: offset, routeType: routeType);
    }
  }

  @override
  Future<Result<List<GtfsStopEntity>, Exception>> getGtfsStops({
    int? limit,
    int? offset,
    String? stopId,
  }) async {
    if (useMockApi) {
      return _getGtfsStopsFromMock(
          limit: limit, offset: offset, stopId: stopId);
    } else {
      return _getGtfsStopsFromRealApi(
          limit: limit, offset: offset, stopId: stopId);
    }
  }

  @override
  Future<Result<List<GtfsShapeEntity>, Exception>> getGtfsShapes({
    required String routeId,
  }) async {
    if (useMockApi) {
      return _getGtfsShapesFromMock(routeId: routeId);
    } else {
      return _getGtfsShapesFromRealApi(routeId: routeId);
    }
  }

  @override
  Future<Result<List<GtfsStopEntity>, Exception>> getGtfsStopsForRoute({
    required String routeId,
  }) async {
    if (useMockApi) {
      return _getGtfsStopsForRouteFromMock(routeId: routeId);
    } else {
      return _getGtfsStopsForRouteFromRealApi(routeId: routeId);
    }
  }

  @override
  Future<Result<List<GtfsScheduleWithDelaysEntity>, Exception>>
      getGtfsScheduleForStop({
    required String stopId,
    int? limit,
  }) async {
    if (useMockApi) {
      return _getGtfsScheduleForStopFromMock(stopId: stopId, limit: limit);
    } else {
      return _getGtfsScheduleForStopFromRealApi(stopId: stopId, limit: limit);
    }
  }

  @override
  Future<Result<List<GtfsDelayEntity>, Exception>> getGtfsDelaysForRoute({
    required String routeId,
  }) async {
    if (useMockApi) {
      return _getGtfsDelaysForRouteFromMock(routeId: routeId);
    } else {
      return _getGtfsDelaysForRouteFromRealApi(routeId: routeId);
    }
  }

  @override
  Future<Result<List<GtfsStopEntity>, Exception>> getNearbyGtfsStops({
    required LatLng location,
    double? radius,
    int? limit,
  }) async {
    if (useMockApi) {
      return _getNearbyGtfsStopsFromMock(
          location: location, radius: radius, limit: limit);
    } else {
      return _getNearbyGtfsStopsFromRealApi(
          location: location, radius: radius, limit: limit);
    }
  }

  // GTFS Mock API implementations
  Future<Result<List<GtfsRouteEntity>, Exception>> _getGtfsRoutesFromMock({
    int? limit,
    int? offset,
    String? routeType,
  }) async {
    try {
      final routes = await MockMapApi.getGtfsRoutes(
        limit: limit,
        offset: offset,
        routeType: routeType,
      );
      return Success(routes);
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<List<GtfsStopEntity>, Exception>> _getGtfsStopsFromMock({
    int? limit,
    int? offset,
    String? stopId,
  }) async {
    try {
      final stops = await MockMapApi.getGtfsStops(
        limit: limit,
        offset: offset,
        stopId: stopId,
      );
      return Success(stops);
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<List<GtfsShapeEntity>, Exception>> _getGtfsShapesFromMock({
    required String routeId,
  }) async {
    try {
      final shapes = await MockMapApi.getGtfsShapes(routeId: routeId);
      return Success(shapes);
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<List<GtfsStopEntity>, Exception>>
      _getGtfsStopsForRouteFromMock({
    required String routeId,
  }) async {
    try {
      final stops = await MockMapApi.getGtfsStopsForRoute(routeId: routeId);
      return Success(stops);
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<List<GtfsScheduleWithDelaysEntity>, Exception>>
      _getGtfsScheduleForStopFromMock({
    required String stopId,
    int? limit,
  }) async {
    try {
      final schedule =
          await MockMapApi.getGtfsScheduleForStop(stopId: stopId, limit: limit);
      return Success(schedule);
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<List<GtfsDelayEntity>, Exception>>
      _getGtfsDelaysForRouteFromMock({
    required String routeId,
  }) async {
    try {
      final delays = await MockMapApi.getGtfsDelaysForRoute(routeId: routeId);
      return Success(delays);
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<List<GtfsStopEntity>, Exception>> _getNearbyGtfsStopsFromMock({
    required LatLng location,
    double? radius,
    int? limit,
  }) async {
    try {
      final stops = await MockMapApi.getNearbyGtfsStops(
        location: location,
        radius: radius,
        limit: limit,
      );
      return Success(stops);
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  // GTFS Real API implementations
  Future<Result<List<GtfsRouteEntity>, Exception>> _getGtfsRoutesFromRealApi({
    int? limit,
    int? offset,
    String? routeType,
  }) async {
    try {
      if (api == null) {
        return Failure(Exception('API instance not available'));
      }

      final response = await api!.getGtfsRoutes(
        limit: limit,
        offset: offset,
        routeType: routeType,
      );

      final routes = response.data.map((dto) => dto.toEntity()).toList();
      return Success(routes);
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<List<GtfsStopEntity>, Exception>> _getGtfsStopsFromRealApi({
    int? limit,
    int? offset,
    String? stopId,
  }) async {
    try {
      if (api == null) {
        return Failure(Exception('API instance not available'));
      }

      final response = await api!.getGtfsStops(
        limit: limit,
        offset: offset,
        stopId: stopId,
      );

      final stops = response.data.map((dto) => dto.toEntity()).toList();
      return Success(stops);
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<List<GtfsShapeEntity>, Exception>> _getGtfsShapesFromRealApi({
    required String routeId,
  }) async {
    try {
      if (api == null) {
        return Failure(Exception('API instance not available'));
      }

      final response = await api!.getGtfsShapes(routeId: routeId);
      final shapes = response.data.map((dto) => dto.toEntity()).toList();
      return Success(shapes);
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<List<GtfsStopEntity>, Exception>>
      _getGtfsStopsForRouteFromRealApi({
    required String routeId,
  }) async {
    try {
      if (api == null) {
        return Failure(Exception('API instance not available'));
      }

      final response = await api!.getGtfsStopsForRoute(routeId: routeId);
      final stops = response.data.map((dto) => dto.toEntity()).toList();
      return Success(stops);
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<List<GtfsScheduleWithDelaysEntity>, Exception>>
      _getGtfsScheduleForStopFromRealApi({
    required String stopId,
    int? limit,
  }) async {
    try {
      if (api == null) {
        return Failure(Exception('API instance not available'));
      }

      final response = await api!.getGtfsScheduleForStop(
        stopId: stopId,
        limit: limit,
      );

      final schedule = response.data.map((dto) => dto.toEntity()).toList();
      return Success(schedule);
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<List<GtfsDelayEntity>, Exception>>
      _getGtfsDelaysForRouteFromRealApi({
    required String routeId,
  }) async {
    try {
      if (api == null) {
        return Failure(Exception('API instance not available'));
      }

      final response = await api!.getGtfsDelaysForRoute(routeId: routeId);
      final delays = response.data.map((dto) => dto.toEntity()).toList();
      return Success(delays);
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  Future<Result<List<GtfsStopEntity>, Exception>>
      _getNearbyGtfsStopsFromRealApi({
    required LatLng location,
    double? radius,
    int? limit,
  }) async {
    try {
      if (api == null) {
        return Failure(Exception('API instance not available'));
      }

      final response = await api!.getNearbyGtfsStops(
        latitude: location.latitude,
        longitude: location.longitude,
        radius: radius,
        limit: limit,
      );

      final stops = response.data.map((dto) => dto.toEntity()).toList();
      return Success(stops);
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  // GTFS Agencies operations
  @override
  Future<Result<List<GtfsAgencyEntity>, Exception>> getGtfsAgencies() async {
    if (useMockApi) {
      try {
        // Mock implementation - return empty list
        return const Success([]);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getGtfsAgencies();
        final agencies = response.data.map((dto) => dto.toEntity()).toList();
        return Success(agencies);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<GtfsAgencyEntity, Exception>> getGtfsAgency({
    required String id,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getGtfsAgency(id: id);
        return Success(response.data.toEntity());
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<GtfsAgencyEntity, Exception>> createGtfsAgency({
    required GtfsAgencyEntity agency,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final dto = GtfsAgencyDto.fromEntity(agency);
        final response = await api!.createGtfsAgency(agency: dto);
        return Success(response.data.toEntity());
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<GtfsAgencyEntity, Exception>> updateGtfsAgency({
    required String id,
    required GtfsAgencyEntity agency,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final dto = GtfsAgencyDto.fromEntity(agency);
        final response = await api!.updateGtfsAgency(id: id, agency: dto);
        return Success(response.data.toEntity());
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<void, Exception>> deleteGtfsAgency({
    required String id,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        await api!.deleteGtfsAgency(id: id);
        return const Success(null);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<int, Exception>> getGtfsAgenciesCount() async {
    if (useMockApi) {
      return const Success(0);
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getGtfsAgenciesCount();
        return Success(response.data);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  // Additional GTFS Routes operations
  @override
  Future<Result<GtfsRouteEntity, Exception>> getGtfsRoute({
    required String id,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getGtfsRoute(id: id);
        return Success(response.data.toEntity());
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<GtfsRouteEntity, Exception>> createGtfsRoute({
    required GtfsRouteEntity route,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final dto = GtfsRouteDto.fromEntity(route);
        final response = await api!.createGtfsRoute(route: dto);
        return Success(response.data.toEntity());
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<GtfsRouteEntity, Exception>> updateGtfsRoute({
    required String id,
    required GtfsRouteEntity route,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final dto = GtfsRouteDto.fromEntity(route);
        final response = await api!.updateGtfsRoute(id: id, route: dto);
        return Success(response.data.toEntity());
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<void, Exception>> deleteGtfsRoute({
    required String id,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        await api!.deleteGtfsRoute(id: id);
        return const Success(null);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<int, Exception>> getGtfsRoutesCount() async {
    if (useMockApi) {
      return const Success(0);
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getGtfsRoutesCount();
        return Success(response.data);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<List<GtfsRouteEntity>, Exception>> getGtfsRoutesByType({
    required int routeType,
  }) async {
    if (useMockApi) {
      return const Success([]);
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getGtfsRoutesByType(routeType: routeType);
        final routes = response.data.map((dto) => dto.toEntity()).toList();
        return Success(routes);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<List<GtfsRouteEntity>, Exception>> getGtfsRoutesByAgency({
    required String agencyId,
  }) async {
    if (useMockApi) {
      return const Success([]);
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getGtfsRoutesByAgency(agencyId: agencyId);
        final routes = response.data.map((dto) => dto.toEntity()).toList();
        return Success(routes);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  // Additional GTFS Stops operations
  @override
  Future<Result<GtfsStopEntity, Exception>> getGtfsStop({
    required String id,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getGtfsStop(id: id);
        return Success(response.data.toEntity());
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<GtfsStopEntity, Exception>> createGtfsStop({
    required GtfsStopEntity stop,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final dto = GtfsStopDto.fromEntity(stop);
        final response = await api!.createGtfsStop(stop: dto);
        return Success(response.data.toEntity());
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<GtfsStopEntity, Exception>> updateGtfsStop({
    required String id,
    required GtfsStopEntity stop,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final dto = GtfsStopDto.fromEntity(stop);
        final response = await api!.updateGtfsStop(id: id, stop: dto);
        return Success(response.data.toEntity());
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<void, Exception>> deleteGtfsStop({
    required String id,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        await api!.deleteGtfsStop(id: id);
        return const Success(null);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<int, Exception>> getGtfsStopsCount() async {
    if (useMockApi) {
      return const Success(0);
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getGtfsStopsCount();
        return Success(response.data);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<List<GtfsStopEntity>, Exception>> getGtfsStopsByZone({
    required String zoneId,
  }) async {
    if (useMockApi) {
      return const Success([]);
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getGtfsStopsByZone(zoneId: zoneId);
        final stops = response.data.map((dto) => dto.toEntity()).toList();
        return Success(stops);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<List<GtfsStopEntity>, Exception>>
      getGtfsAccessibleStops() async {
    if (useMockApi) {
      return const Success([]);
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getGtfsAccessibleStops();
        final stops = response.data.map((dto) => dto.toEntity()).toList();
        return Success(stops);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  // GTFS Trips operations
  @override
  Future<Result<List<GtfsTripEntity>, Exception>> getGtfsTrips() async {
    if (useMockApi) {
      return const Success([]);
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getGtfsTrips();
        final trips = response.data.map((dto) => dto.toEntity()).toList();
        return Success(trips);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<GtfsTripEntity, Exception>> getGtfsTrip({
    required String id,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getGtfsTrip(id: id);
        return Success(response.data.toEntity());
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<GtfsTripEntity, Exception>> createGtfsTrip({
    required GtfsTripEntity trip,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final dto = GtfsTripDto.fromEntity(trip);
        final response = await api!.createGtfsTrip(trip: dto);
        return Success(response.data.toEntity());
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<GtfsTripEntity, Exception>> updateGtfsTrip({
    required String id,
    required GtfsTripEntity trip,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final dto = GtfsTripDto.fromEntity(trip);
        final response = await api!.updateGtfsTrip(id: id, trip: dto);
        return Success(response.data.toEntity());
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<void, Exception>> deleteGtfsTrip({
    required String id,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        await api!.deleteGtfsTrip(id: id);
        return const Success(null);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<int, Exception>> getGtfsTripsCount() async {
    if (useMockApi) {
      return const Success(0);
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getGtfsTripsCount();
        return Success(response.data);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<List<GtfsTripEntity>, Exception>> getGtfsTripsByService({
    required String serviceId,
  }) async {
    if (useMockApi) {
      return const Success([]);
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getGtfsTripsByService(serviceId: serviceId);
        final trips = response.data.map((dto) => dto.toEntity()).toList();
        return Success(trips);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<List<GtfsTripEntity>, Exception>> getGtfsTripsByRoute({
    required String routeId,
  }) async {
    if (useMockApi) {
      return const Success([]);
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getGtfsTripsByRoute(routeId: routeId);
        final trips = response.data.map((dto) => dto.toEntity()).toList();
        return Success(trips);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<List<GtfsTripEntity>, Exception>>
      getGtfsTripsByRouteAndDirection({
    required String routeId,
    required int directionId,
  }) async {
    if (useMockApi) {
      return const Success([]);
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getGtfsTripsByRouteAndDirection(
          routeId: routeId,
          directionId: directionId,
        );
        final trips = response.data.map((dto) => dto.toEntity()).toList();
        return Success(trips);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  // GTFS Stop Times operations
  @override
  Future<Result<List<GtfsStopTimeEntity>, Exception>> getGtfsStopTimes() async {
    if (useMockApi) {
      return const Success([]);
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getGtfsStopTimes();
        final stopTimes = response.data.map((dto) => dto.toEntity()).toList();
        return Success(stopTimes);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<GtfsStopTimeEntity, Exception>> getGtfsStopTime({
    required int id,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getGtfsStopTime(id: id);
        return Success(response.data.toEntity());
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<GtfsStopTimeEntity, Exception>> createGtfsStopTime({
    required GtfsStopTimeEntity stopTime,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final dto = GtfsStopTimeDto.fromEntity(stopTime);
        final response = await api!.createGtfsStopTime(stopTime: dto);
        return Success(response.data.toEntity());
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<GtfsStopTimeEntity, Exception>> updateGtfsStopTime({
    required int id,
    required GtfsStopTimeEntity stopTime,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final dto = GtfsStopTimeDto.fromEntity(stopTime);
        final response = await api!.updateGtfsStopTime(id: id, stopTime: dto);
        return Success(response.data.toEntity());
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<void, Exception>> deleteGtfsStopTime({
    required int id,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        await api!.deleteGtfsStopTime(id: id);
        return const Success(null);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<int, Exception>> getGtfsStopTimesCount() async {
    if (useMockApi) {
      return const Success(0);
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getGtfsStopTimesCount();
        return Success(response.data);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<List<GtfsStopTimeEntity>, Exception>> getGtfsStopTimesByTrip({
    required String tripId,
  }) async {
    if (useMockApi) {
      return const Success([]);
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getGtfsStopTimesByTrip(tripId: tripId);
        final stopTimes = response.data.map((dto) => dto.toEntity()).toList();
        return Success(stopTimes);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<List<GtfsStopTimeEntity>, Exception>> getGtfsStopTimesByStop({
    required String stopId,
  }) async {
    if (useMockApi) {
      return const Success([]);
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getGtfsStopTimesByStop(stopId: stopId);
        final stopTimes = response.data.map((dto) => dto.toEntity()).toList();
        return Success(stopTimes);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  // Additional GTFS Shapes operations
  @override
  Future<Result<GtfsShapeEntity, Exception>> getGtfsShape({
    required int id,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getGtfsShape(id: id);
        return Success(response.data.toEntity());
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<GtfsShapeEntity, Exception>> createGtfsShape({
    required GtfsShapeEntity shape,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final dto = GtfsShapeDto.fromEntity(shape);
        final response = await api!.createGtfsShape(shape: dto);
        return Success(response.data.toEntity());
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<GtfsShapeEntity, Exception>> updateGtfsShape({
    required int id,
    required GtfsShapeEntity shape,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final dto = GtfsShapeDto.fromEntity(shape);
        final response = await api!.updateGtfsShape(id: id, shape: dto);
        return Success(response.data.toEntity());
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<void, Exception>> deleteGtfsShape({
    required int id,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        await api!.deleteGtfsShape(id: id);
        return const Success(null);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<int, Exception>> getGtfsShapesCount() async {
    if (useMockApi) {
      return const Success(0);
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getGtfsShapesCount();
        return Success(response.data);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  // GTFS Calendar operations
  @override
  Future<Result<List<GtfsCalendarEntity>, Exception>> getGtfsCalendars() async {
    if (useMockApi) {
      return const Success([]);
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getGtfsCalendars();
        final calendars = response.data.map((dto) => dto.toEntity()).toList();
        return Success(calendars);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<GtfsCalendarEntity, Exception>> getGtfsCalendar({
    required String id,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getGtfsCalendar(id: id);
        return Success(response.data.toEntity());
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<GtfsCalendarEntity, Exception>> createGtfsCalendar({
    required GtfsCalendarEntity calendar,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final dto = GtfsCalendarDto.fromEntity(calendar);
        final response = await api!.createGtfsCalendar(calendar: dto);
        return Success(response.data.toEntity());
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<GtfsCalendarEntity, Exception>> updateGtfsCalendar({
    required String id,
    required GtfsCalendarEntity calendar,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final dto = GtfsCalendarDto.fromEntity(calendar);
        final response = await api!.updateGtfsCalendar(id: id, calendar: dto);
        return Success(response.data.toEntity());
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<void, Exception>> deleteGtfsCalendar({
    required String id,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        await api!.deleteGtfsCalendar(id: id);
        return const Success(null);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<int, Exception>> getGtfsCalendarsCount() async {
    if (useMockApi) {
      return const Success(0);
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getGtfsCalendarsCount();
        return Success(response.data);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  // GTFS Calendar Dates operations
  @override
  Future<Result<List<GtfsCalendarDatesEntity>, Exception>>
      getGtfsCalendarDates() async {
    if (useMockApi) {
      return const Success([]);
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getGtfsCalendarDates();
        final calendarDates =
            response.data.map((dto) => dto.toEntity()).toList();
        return Success(calendarDates);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<GtfsCalendarDatesEntity, Exception>> getGtfsCalendarDate({
    required int id,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getGtfsCalendarDate(id: id);
        return Success(response.data.toEntity());
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<GtfsCalendarDatesEntity, Exception>> createGtfsCalendarDate({
    required GtfsCalendarDatesEntity calendarDate,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final dto = GtfsCalendarDatesDto.fromEntity(calendarDate);
        final response = await api!.createGtfsCalendarDate(calendarDate: dto);
        return Success(response.data.toEntity());
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<GtfsCalendarDatesEntity, Exception>> updateGtfsCalendarDate({
    required int id,
    required GtfsCalendarDatesEntity calendarDate,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final dto = GtfsCalendarDatesDto.fromEntity(calendarDate);
        final response =
            await api!.updateGtfsCalendarDate(id: id, calendarDate: dto);
        return Success(response.data.toEntity());
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<void, Exception>> deleteGtfsCalendarDate({
    required int id,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        await api!.deleteGtfsCalendarDate(id: id);
        return const Success(null);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<int, Exception>> getGtfsCalendarDatesCount() async {
    if (useMockApi) {
      return const Success(0);
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getGtfsCalendarDatesCount();
        return Success(response.data);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  // GTFS Blocks operations
  @override
  Future<Result<List<GtfsBlockEntity>, Exception>> getGtfsBlocks() async {
    if (useMockApi) {
      return const Success([]);
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getGtfsBlocks();
        final blocks = response.data.map((dto) => dto.toEntity()).toList();
        return Success(blocks);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<GtfsBlockEntity, Exception>> getGtfsBlock({
    required String id,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getGtfsBlock(id: id);
        return Success(response.data.toEntity());
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<GtfsBlockEntity, Exception>> createGtfsBlock({
    required GtfsBlockEntity block,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final dto = GtfsBlockDto.fromEntity(block);
        final response = await api!.createGtfsBlock(block: dto);
        return Success(response.data.toEntity());
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<GtfsBlockEntity, Exception>> updateGtfsBlock({
    required String id,
    required GtfsBlockEntity block,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final dto = GtfsBlockDto.fromEntity(block);
        final response = await api!.updateGtfsBlock(id: id, block: dto);
        return Success(response.data.toEntity());
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<void, Exception>> deleteGtfsBlock({
    required String id,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        await api!.deleteGtfsBlock(id: id);
        return const Success(null);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<int, Exception>> getGtfsBlocksCount() async {
    if (useMockApi) {
      return const Success(0);
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getGtfsBlocksCount();
        return Success(response.data);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  // Reports operations
  @override
  Future<Result<List<ReportEntity>, Exception>> getReports() async {
    if (useMockApi) {
      return const Success([]);
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getReports();
        final reports = response.data.map((dto) => dto.toEntity()).toList();
        return Success(reports);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<ReportEntity, Exception>> getReport({
    required int id,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getReport(id: id);
        return Success(response.data.toEntity());
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<ReportEntity, Exception>> createReport({
    required ReportEntity report,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final dto = ReportDto.fromEntity(report);
        final response = await api!.createReport(report: dto);
        return Success(response.data.toEntity());
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<ReportEntity, Exception>> updateReport({
    required int id,
    required ReportEntity report,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final dto = ReportDto.fromEntity(report);
        final response = await api!.updateReport(id: id, report: dto);
        return Success(response.data.toEntity());
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<void, Exception>> deleteReport({
    required int id,
  }) async {
    if (useMockApi) {
      return Failure(Exception('Not implemented in mock API'));
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        await api!.deleteReport(id: id);
        return const Success(null);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<List<ReportEntity>, Exception>> getReportsByType({
    required String type,
  }) async {
    if (useMockApi) {
      return const Success([]);
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getReportsByType(type: type);
        final reports = response.data.map((dto) => dto.toEntity()).toList();
        return Success(reports);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<List<ReportEntity>, Exception>> getReportsByTimeRange({
    required int startTime,
    required int endTime,
  }) async {
    if (useMockApi) {
      return const Success([]);
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getReportsByTimeRange(
          startTime: startTime,
          endTime: endTime,
        );
        final reports = response.data.map((dto) => dto.toEntity()).toList();
        return Success(reports);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<List<ReportEntity>, Exception>> getReportsByRoute({
    required String routeId,
  }) async {
    if (useMockApi) {
      return const Success([]);
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getReportsByRoute(routeId: routeId);
        final reports = response.data.map((dto) => dto.toEntity()).toList();
        return Success(reports);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<List<ReportEntity>, Exception>> getEmergencyReportsByRoute({
    required String routeId,
  }) async {
    if (useMockApi) {
      return const Success([]);
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response =
            await api!.getEmergencyReportsByRoute(routeId: routeId);
        final reports = response.data.map((dto) => dto.toEntity()).toList();
        return Success(reports);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<List<ReportEntity>, Exception>> getRecentReports({
    required int hours,
  }) async {
    if (useMockApi) {
      return const Success([]);
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getRecentReports(hours: hours);
        final reports = response.data.map((dto) => dto.toEntity()).toList();
        return Success(reports);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<List<ReportEntity>, Exception>> getReportsByEmergencyStatus({
    required bool isEmergency,
  }) async {
    if (useMockApi) {
      return const Success([]);
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getReportsByEmergencyStatus(
          isEmergency: isEmergency,
        );
        final reports = response.data.map((dto) => dto.toEntity()).toList();
        return Success(reports);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<int, Exception>> getReportsCount() async {
    if (useMockApi) {
      return const Success(0);
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getReportsCount();
        return Success(response.data);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<int, Exception>> getReportsCountByType({
    required String type,
  }) async {
    if (useMockApi) {
      return const Success(0);
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getReportsCountByType(type: type);
        return Success(response.data);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }

  @override
  Future<Result<int, Exception>> getEmergencyReportsCount() async {
    if (useMockApi) {
      return const Success(0);
    } else {
      try {
        if (api == null) {
          return Failure(Exception('API instance not available'));
        }
        final response = await api!.getEmergencyReportsCount();
        return Success(response.data);
      } on Exception catch (exception) {
        return Failure(exception);
      }
    }
  }
}
