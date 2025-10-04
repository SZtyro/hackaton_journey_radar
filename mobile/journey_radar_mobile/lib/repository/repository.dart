import 'package:journey_radar_mobile/entity/entity.dart';
import 'package:latlong2/latlong.dart';

/// Repository interface for map operations including map points and bus routes.
abstract class Repository {
  // Map Points operations
  /// Retrieves all map points with optional filtering.
  Future<Result<List<MapPointEntity>, Exception>> getMapPoints({
    int? limit,
    int? offset,
    String? iconType,
  });

  /// Retrieves a specific map point by ID.
  Future<Result<MapPointEntity, Exception>> getMapPoint({
    required String id,
  });

  /// Creates a new map point.
  Future<Result<MapPointEntity, Exception>> createMapPoint({
    required MapPointEntity mapPoint,
  });

  /// Updates an existing map point.
  Future<Result<MapPointEntity, Exception>> updateMapPoint({
    required String id,
    required MapPointEntity mapPoint,
  });

  /// Deletes a map point by ID.
  Future<Result<void, Exception>> deleteMapPoint({
    required String id,
  });

  /// Searches map points by query string.
  Future<Result<List<MapPointEntity>, Exception>> searchMapPoints({
    required String query,
    int? limit,
    int? offset,
  });

  /// Retrieves map points near a specific location.
  Future<Result<List<MapPointEntity>, Exception>> getNearbyMapPoints({
    required LatLng location,
    double? radius,
    int? limit,
  });

  // Bus Routes operations
  /// Retrieves all bus routes with optional filtering.
  Future<Result<List<BusRouteEntity>, Exception>> getBusRoutes({
    int? limit,
    int? offset,
    String? number,
  });

  /// Retrieves a specific bus route by ID.
  Future<Result<BusRouteEntity, Exception>> getBusRoute({
    required String id,
  });

  /// Creates a new bus route.
  Future<Result<BusRouteEntity, Exception>> createBusRoute({
    required BusRouteEntity busRoute,
  });

  /// Updates an existing bus route.
  Future<Result<BusRouteEntity, Exception>> updateBusRoute({
    required String id,
    required BusRouteEntity busRoute,
  });

  /// Deletes a bus route by ID.
  Future<Result<void, Exception>> deleteBusRoute({
    required String id,
  });

  /// Searches bus routes by query string.
  Future<Result<List<BusRouteEntity>, Exception>> searchBusRoutes({
    required String query,
    int? limit,
    int? offset,
  });

  /// Retrieves bus routes near a specific location.
  Future<Result<List<BusRouteEntity>, Exception>> getNearbyBusRoutes({
    required LatLng location,
    double? radius,
    int? limit,
  });
}

/// Result type for handling success and failure cases.
abstract class Result<T, E> {
  const Result();
}

class Success<T, E> extends Result<T, E> {
  final T data;
  const Success(this.data);
}

class Failure<T, E> extends Result<T, E> {
  final E error;
  const Failure(this.error);
}
