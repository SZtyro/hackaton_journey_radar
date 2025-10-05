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

  // GTFS Agencies endpoints
  @GET('/api/gtfs/agencies')
  Future<HttpResponse<List<GtfsAgencyDto>>> getGtfsAgencies();

  @GET('/api/gtfs/agencies/{id}')
  Future<HttpResponse<GtfsAgencyDto>> getGtfsAgency({
    @Path('id') required String id,
  });

  @POST('/api/gtfs/agencies')
  Future<HttpResponse<GtfsAgencyDto>> createGtfsAgency({
    @Body() required GtfsAgencyDto agency,
  });

  @PUT('/api/gtfs/agencies/{id}')
  Future<HttpResponse<GtfsAgencyDto>> updateGtfsAgency({
    @Path('id') required String id,
    @Body() required GtfsAgencyDto agency,
  });

  @DELETE('/api/gtfs/agencies/{id}')
  Future<HttpResponse<void>> deleteGtfsAgency({
    @Path('id') required String id,
  });

  @GET('/api/gtfs/agencies/count')
  Future<HttpResponse<int>> getGtfsAgenciesCount();

  // GTFS Routes endpoints
  @GET('/api/gtfs/routes')
  Future<HttpResponse<List<GtfsRouteDto>>> getGtfsRoutes({
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('routeType') String? routeType,
  });

  @GET('/api/gtfs/routes/{id}')
  Future<HttpResponse<GtfsRouteDto>> getGtfsRoute({
    @Path('id') required String id,
  });

  @POST('/api/gtfs/routes')
  Future<HttpResponse<GtfsRouteDto>> createGtfsRoute({
    @Body() required GtfsRouteDto route,
  });

  @PUT('/api/gtfs/routes/{id}')
  Future<HttpResponse<GtfsRouteDto>> updateGtfsRoute({
    @Path('id') required String id,
    @Body() required GtfsRouteDto route,
  });

  @DELETE('/api/gtfs/routes/{id}')
  Future<HttpResponse<void>> deleteGtfsRoute({
    @Path('id') required String id,
  });

  @GET('/api/gtfs/routes/count')
  Future<HttpResponse<int>> getGtfsRoutesCount();

  @GET('/api/gtfs/routes/by-type/{routeType}')
  Future<HttpResponse<List<GtfsRouteDto>>> getGtfsRoutesByType({
    @Path('routeType') required int routeType,
  });

  @GET('/api/gtfs/routes/by-agency/{agencyId}')
  Future<HttpResponse<List<GtfsRouteDto>>> getGtfsRoutesByAgency({
    @Path('agencyId') required String agencyId,
  });

  // GTFS Stops endpoints
  @GET('/api/gtfs/stops')
  Future<HttpResponse<List<GtfsStopDto>>> getGtfsStops({
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('stopId') String? stopId,
  });

  @GET('/api/gtfs/stops/{id}')
  Future<HttpResponse<GtfsStopDto>> getGtfsStop({
    @Path('id') required String id,
  });

  @POST('/api/gtfs/stops')
  Future<HttpResponse<GtfsStopDto>> createGtfsStop({
    @Body() required GtfsStopDto stop,
  });

  @PUT('/api/gtfs/stops/{id}')
  Future<HttpResponse<GtfsStopDto>> updateGtfsStop({
    @Path('id') required String id,
    @Body() required GtfsStopDto stop,
  });

  @DELETE('/api/gtfs/stops/{id}')
  Future<HttpResponse<void>> deleteGtfsStop({
    @Path('id') required String id,
  });

  @GET('/api/gtfs/stops/count')
  Future<HttpResponse<int>> getGtfsStopsCount();

  @GET('/api/gtfs/stops/nearby')
  Future<HttpResponse<List<GtfsStopDto>>> getNearbyGtfsStops({
    @Query('latitude') required double latitude,
    @Query('longitude') required double longitude,
    @Query('radius') double? radius,
    @Query('limit') int? limit,
  });

  @GET('/api/gtfs/stops/by-zone/{zoneId}')
  Future<HttpResponse<List<GtfsStopDto>>> getGtfsStopsByZone({
    @Path('zoneId') required String zoneId,
  });

  @GET('/api/gtfs/stops/accessible')
  Future<HttpResponse<List<GtfsStopDto>>> getGtfsAccessibleStops();

  // GTFS Trips endpoints
  @GET('/api/gtfs/trips')
  Future<HttpResponse<List<GtfsTripDto>>> getGtfsTrips();

  @GET('/api/gtfs/trips/{id}')
  Future<HttpResponse<GtfsTripDto>> getGtfsTrip({
    @Path('id') required String id,
  });

  @POST('/api/gtfs/trips')
  Future<HttpResponse<GtfsTripDto>> createGtfsTrip({
    @Body() required GtfsTripDto trip,
  });

  @PUT('/api/gtfs/trips/{id}')
  Future<HttpResponse<GtfsTripDto>> updateGtfsTrip({
    @Path('id') required String id,
    @Body() required GtfsTripDto trip,
  });

  @DELETE('/api/gtfs/trips/{id}')
  Future<HttpResponse<void>> deleteGtfsTrip({
    @Path('id') required String id,
  });

  @GET('/api/gtfs/trips/count')
  Future<HttpResponse<int>> getGtfsTripsCount();

  @GET('/api/gtfs/trips/by-service/{serviceId}')
  Future<HttpResponse<List<GtfsTripDto>>> getGtfsTripsByService({
    @Path('serviceId') required String serviceId,
  });

  @GET('/api/gtfs/trips/by-route/{routeId}')
  Future<HttpResponse<List<GtfsTripDto>>> getGtfsTripsByRoute({
    @Path('routeId') required String routeId,
  });

  @GET('/api/gtfs/trips/by-route/{routeId}/direction/{directionId}')
  Future<HttpResponse<List<GtfsTripDto>>> getGtfsTripsByRouteAndDirection({
    @Path('routeId') required String routeId,
    @Path('directionId') required int directionId,
  });

  // GTFS Stop Times endpoints
  @GET('/api/gtfs/stop-times')
  Future<HttpResponse<List<GtfsStopTimeDto>>> getGtfsStopTimes();

  @GET('/api/gtfs/stop-times/{id}')
  Future<HttpResponse<GtfsStopTimeDto>> getGtfsStopTime({
    @Path('id') required int id,
  });

  @POST('/api/gtfs/stop-times')
  Future<HttpResponse<GtfsStopTimeDto>> createGtfsStopTime({
    @Body() required GtfsStopTimeDto stopTime,
  });

  @PUT('/api/gtfs/stop-times/{id}')
  Future<HttpResponse<GtfsStopTimeDto>> updateGtfsStopTime({
    @Path('id') required int id,
    @Body() required GtfsStopTimeDto stopTime,
  });

  @DELETE('/api/gtfs/stop-times/{id}')
  Future<HttpResponse<void>> deleteGtfsStopTime({
    @Path('id') required int id,
  });

  @GET('/api/gtfs/stop-times/count')
  Future<HttpResponse<int>> getGtfsStopTimesCount();

  @GET('/api/gtfs/stop-times/by-trip/{tripId}')
  Future<HttpResponse<List<GtfsStopTimeDto>>> getGtfsStopTimesByTrip({
    @Path('tripId') required String tripId,
  });

  @GET('/api/gtfs/stop-times/by-stop/{stopId}')
  Future<HttpResponse<List<GtfsStopTimeDto>>> getGtfsStopTimesByStop({
    @Path('stopId') required String stopId,
  });

  // GTFS Shapes endpoints
  @GET('/api/gtfs/shapes')
  Future<HttpResponse<List<GtfsShapeDto>>> getAllGtfsShapes();

  @GET('/api/gtfs/shapes/{routeId}')
  Future<HttpResponse<List<GtfsShapeDto>>> getGtfsShapes({
    @Path('routeId') required String routeId,
  });

  @GET('/api/gtfs/shapes/{id}')
  Future<HttpResponse<GtfsShapeDto>> getGtfsShape({
    @Path('id') required int id,
  });

  @POST('/api/gtfs/shapes')
  Future<HttpResponse<GtfsShapeDto>> createGtfsShape({
    @Body() required GtfsShapeDto shape,
  });

  @PUT('/api/gtfs/shapes/{id}')
  Future<HttpResponse<GtfsShapeDto>> updateGtfsShape({
    @Path('id') required int id,
    @Body() required GtfsShapeDto shape,
  });

  @DELETE('/api/gtfs/shapes/{id}')
  Future<HttpResponse<void>> deleteGtfsShape({
    @Path('id') required int id,
  });

  @GET('/api/gtfs/shapes/count')
  Future<HttpResponse<int>> getGtfsShapesCount();

  // GTFS Calendar endpoints
  @GET('/api/gtfs/calendar')
  Future<HttpResponse<List<GtfsCalendarDto>>> getGtfsCalendars();

  @GET('/api/gtfs/calendar/{id}')
  Future<HttpResponse<GtfsCalendarDto>> getGtfsCalendar({
    @Path('id') required String id,
  });

  @POST('/api/gtfs/calendar')
  Future<HttpResponse<GtfsCalendarDto>> createGtfsCalendar({
    @Body() required GtfsCalendarDto calendar,
  });

  @PUT('/api/gtfs/calendar/{id}')
  Future<HttpResponse<GtfsCalendarDto>> updateGtfsCalendar({
    @Path('id') required String id,
    @Body() required GtfsCalendarDto calendar,
  });

  @DELETE('/api/gtfs/calendar/{id}')
  Future<HttpResponse<void>> deleteGtfsCalendar({
    @Path('id') required String id,
  });

  @GET('/api/gtfs/calendar/count')
  Future<HttpResponse<int>> getGtfsCalendarsCount();

  // GTFS Calendar Dates endpoints
  @GET('/api/gtfs/calendar-dates')
  Future<HttpResponse<List<GtfsCalendarDatesDto>>> getGtfsCalendarDates();

  @GET('/api/gtfs/calendar-dates/{id}')
  Future<HttpResponse<GtfsCalendarDatesDto>> getGtfsCalendarDate({
    @Path('id') required int id,
  });

  @POST('/api/gtfs/calendar-dates')
  Future<HttpResponse<GtfsCalendarDatesDto>> createGtfsCalendarDate({
    @Body() required GtfsCalendarDatesDto calendarDate,
  });

  @PUT('/api/gtfs/calendar-dates/{id}')
  Future<HttpResponse<GtfsCalendarDatesDto>> updateGtfsCalendarDate({
    @Path('id') required int id,
    @Body() required GtfsCalendarDatesDto calendarDate,
  });

  @DELETE('/api/gtfs/calendar-dates/{id}')
  Future<HttpResponse<void>> deleteGtfsCalendarDate({
    @Path('id') required int id,
  });

  @GET('/api/gtfs/calendar-dates/count')
  Future<HttpResponse<int>> getGtfsCalendarDatesCount();

  // GTFS Blocks endpoints
  @GET('/api/gtfs/blocks')
  Future<HttpResponse<List<GtfsBlockDto>>> getGtfsBlocks();

  @GET('/api/gtfs/blocks/{id}')
  Future<HttpResponse<GtfsBlockDto>> getGtfsBlock({
    @Path('id') required String id,
  });

  @POST('/api/gtfs/blocks')
  Future<HttpResponse<GtfsBlockDto>> createGtfsBlock({
    @Body() required GtfsBlockDto block,
  });

  @PUT('/api/gtfs/blocks/{id}')
  Future<HttpResponse<GtfsBlockDto>> updateGtfsBlock({
    @Path('id') required String id,
    @Body() required GtfsBlockDto block,
  });

  @DELETE('/api/gtfs/blocks/{id}')
  Future<HttpResponse<void>> deleteGtfsBlock({
    @Path('id') required String id,
  });

  @GET('/api/gtfs/blocks/count')
  Future<HttpResponse<int>> getGtfsBlocksCount();

  // Legacy/Custom GTFS endpoints (keeping for backward compatibility)
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

  // Reports endpoints
  @GET('/api/reports')
  Future<HttpResponse<List<ReportDto>>> getReports();

  @GET('/api/reports/{id}')
  Future<HttpResponse<ReportDto>> getReport({
    @Path('id') required int id,
  });

  @POST('/api/reports')
  Future<HttpResponse<ReportDto>> createReport({
    @Body() required ReportDto report,
  });

  @PUT('/api/reports/{id}')
  Future<HttpResponse<ReportDto>> updateReport({
    @Path('id') required int id,
    @Body() required ReportDto report,
  });

  @DELETE('/api/reports/{id}')
  Future<HttpResponse<void>> deleteReport({
    @Path('id') required int id,
  });

  @GET('/api/reports/type/{type}')
  Future<HttpResponse<List<ReportDto>>> getReportsByType({
    @Path('type') required String type,
  });

  @GET('/api/reports/timerange')
  Future<HttpResponse<List<ReportDto>>> getReportsByTimeRange({
    @Query('startTime') required int startTime,
    @Query('endTime') required int endTime,
  });

  @GET('/api/reports/route/{routeId}')
  Future<HttpResponse<List<ReportDto>>> getReportsByRoute({
    @Path('routeId') required String routeId,
  });

  @GET('/api/reports/route/{routeId}/emergency')
  Future<HttpResponse<List<ReportDto>>> getEmergencyReportsByRoute({
    @Path('routeId') required String routeId,
  });

  @GET('/api/reports/recent/{hours}')
  Future<HttpResponse<List<ReportDto>>> getRecentReports({
    @Path('hours') required int hours,
  });

  @GET('/api/reports/emergency/{isEmergency}')
  Future<HttpResponse<List<ReportDto>>> getReportsByEmergencyStatus({
    @Path('isEmergency') required bool isEmergency,
  });

  @GET('/api/reports/count')
  Future<HttpResponse<int>> getReportsCount();

  @GET('/api/reports/count/type/{type}')
  Future<HttpResponse<int>> getReportsCountByType({
    @Path('type') required String type,
  });

  @GET('/api/reports/count/emergency')
  Future<HttpResponse<int>> getEmergencyReportsCount();
}
