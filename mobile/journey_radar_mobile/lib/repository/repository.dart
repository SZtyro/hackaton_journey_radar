import 'package:journey_radar_mobile/entity/entity.dart';
import 'package:latlong2/latlong.dart';

/// Repository interface for map operations including map points and bus routes.
abstract class Repository {
  // GTFS operations
  /// Retrieves GTFS routes with optional filtering.
  Future<Result<List<GtfsRouteEntity>, Exception>> getGtfsRoutes({
    int? limit,
    int? offset,
    String? routeType,
  });

  /// Retrieves GTFS stops with optional filtering.
  Future<Result<List<GtfsStopEntity>, Exception>> getGtfsStops({
    int? limit,
    int? offset,
    String? stopId,
  });

  /// Retrieves GTFS shapes for a specific route.
  Future<Result<List<GtfsShapeEntity>, Exception>> getGtfsShapes({
    required String routeId,
  });

  /// Retrieves GTFS stops for a specific route.
  Future<Result<List<GtfsStopEntity>, Exception>> getGtfsStopsForRoute({
    required String routeId,
  });

  /// Retrieves GTFS schedule for a specific stop.
  Future<Result<List<GtfsScheduleWithDelaysEntity>, Exception>>
      getGtfsScheduleForStop({
    required String stopId,
    int? limit,
  });

  /// Retrieves GTFS delays for a specific route.
  Future<Result<List<GtfsDelayEntity>, Exception>> getGtfsDelaysForRoute({
    required String routeId,
  });

  /// Retrieves GTFS stops near a specific location.
  Future<Result<List<GtfsStopEntity>, Exception>> getNearbyGtfsStops({
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
