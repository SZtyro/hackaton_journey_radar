// ignore_for_file: public_member_api_docs

import 'package:dio/dio.dart';
import 'package:journey_radar_mobile/dto/dto.dart';
import 'package:retrofit/retrofit.dart';

part 'api.g.dart';

@RestApi()
abstract class Api {
  factory Api({
    required Dio dio,
    required String baseUrl,
  }) {
    return _Api(dio, baseUrl: baseUrl);
  }

  // Map Points endpoints
  @GET('/api/map/points')
  Future<HttpResponse<List<MapPointDto>>> getMapPoints({
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('iconType') String? iconType,
  });

  @GET('/api/map/points/{id}')
  Future<HttpResponse<MapPointDto>> getMapPoint({
    @Path('id') required String id,
  });

  @POST('/api/map/points')
  Future<HttpResponse<MapPointDto>> createMapPoint({
    @Body() required MapPointDto mapPoint,
  });

  @PUT('/api/map/points/{id}')
  Future<HttpResponse<MapPointDto>> updateMapPoint({
    @Path('id') required String id,
    @Body() required MapPointDto mapPoint,
  });

  @DELETE('/api/map/points/{id}')
  Future<HttpResponse<void>> deleteMapPoint({
    @Path('id') required String id,
  });

  // Bus Routes endpoints
  @GET('/api/map/bus-routes')
  Future<HttpResponse<List<BusRouteDto>>> getBusRoutes({
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('number') String? number,
  });

  @GET('/api/map/bus-routes/{id}')
  Future<HttpResponse<BusRouteDto>> getBusRoute({
    @Path('id') required String id,
  });

  @POST('/api/map/bus-routes')
  Future<HttpResponse<BusRouteDto>> createBusRoute({
    @Body() required BusRouteDto busRoute,
  });

  @PUT('/api/map/bus-routes/{id}')
  Future<HttpResponse<BusRouteDto>> updateBusRoute({
    @Path('id') required String id,
    @Body() required BusRouteDto busRoute,
  });

  @DELETE('/api/map/bus-routes/{id}')
  Future<HttpResponse<void>> deleteBusRoute({
    @Path('id') required String id,
  });

  // Search endpoints
  @GET('/api/map/search/points')
  Future<HttpResponse<List<MapPointDto>>> searchMapPoints({
    @Query('query') required String query,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  });

  @GET('/api/map/search/bus-routes')
  Future<HttpResponse<List<BusRouteDto>>> searchBusRoutes({
    @Query('query') required String query,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  });

  // Nearby endpoints
  @GET('/api/map/nearby/points')
  Future<HttpResponse<List<MapPointDto>>> getNearbyMapPoints({
    @Query('latitude') required double latitude,
    @Query('longitude') required double longitude,
    @Query('radius') double? radius,
    @Query('limit') int? limit,
  });

  @GET('/api/map/nearby/bus-routes')
  Future<HttpResponse<List<BusRouteDto>>> getNearbyBusRoutes({
    @Query('latitude') required double latitude,
    @Query('longitude') required double longitude,
    @Query('radius') double? radius,
    @Query('limit') int? limit,
  });

  // GTFS endpoints
  @GET('/api/gtfs/routes')
  Future<HttpResponse<List<GtfsRouteDto>>> getGtfsRoutes({
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('routeType') String? routeType,
  });

  @GET('/api/gtfs/stops')
  Future<HttpResponse<List<GtfsStopDto>>> getGtfsStops({
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('stopId') String? stopId,
  });

  @GET('/api/gtfs/shapes/{routeId}')
  Future<HttpResponse<List<GtfsShapeDto>>> getGtfsShapes({
    @Path('routeId') required String routeId,
  });

  @GET('/api/gtfs/routes/{routeId}/stops')
  Future<HttpResponse<List<GtfsStopDto>>> getGtfsStopsForRoute({
    @Path('routeId') required String routeId,
  });

  @GET('/api/gtfs/stops/{stopId}/schedule')
  Future<HttpResponse<List<GtfsScheduleWithDelaysDto>>> getGtfsScheduleForStop({
    @Path('stopId') required String stopId,
    @Query('limit') int? limit,
  });

  @GET('/api/gtfs/routes/{routeId}/delays')
  Future<HttpResponse<List<GtfsDelayDto>>> getGtfsDelaysForRoute({
    @Path('routeId') required String routeId,
  });

  @GET('/api/gtfs/stops/nearby')
  Future<HttpResponse<List<GtfsStopDto>>> getNearbyGtfsStops({
    @Query('latitude') required double latitude,
    @Query('longitude') required double longitude,
    @Query('radius') double? radius,
    @Query('limit') int? limit,
  });
}
