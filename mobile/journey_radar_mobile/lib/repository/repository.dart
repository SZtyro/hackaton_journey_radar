import 'package:journey_radar_mobile/entity/entity.dart';
import 'package:latlong2/latlong.dart';

/// Repository interface for map operations including map points and bus routes.
abstract class Repository {
  // Map Points operations
  Future<Result<List<MapPointEntity>, Exception>> getMapPoints({
    int? limit,
    int? offset,
    String? iconType,
  });

  Future<Result<MapPointEntity, Exception>> getMapPoint({
    required String id,
  });

  Future<Result<MapPointEntity, Exception>> createMapPoint({
    required MapPointEntity mapPoint,
  });

  Future<Result<MapPointEntity, Exception>> updateMapPoint({
    required String id,
    required MapPointEntity mapPoint,
  });

  Future<Result<void, Exception>> deleteMapPoint({
    required String id,
  });

  Future<Result<List<MapPointEntity>, Exception>> searchMapPoints({
    required String query,
    int? limit,
    int? offset,
  });

  Future<Result<List<MapPointEntity>, Exception>> getNearbyMapPoints({
    required LatLng location,
    double? radius,
    int? limit,
  });

  // Bus Routes operations
  Future<Result<List<BusRouteEntity>, Exception>> getBusRoutes({
    int? limit,
    int? offset,
    String? number,
  });

  Future<Result<BusRouteEntity, Exception>> getBusRoute({
    required String id,
  });

  Future<Result<BusRouteEntity, Exception>> createBusRoute({
    required BusRouteEntity busRoute,
  });

  Future<Result<BusRouteEntity, Exception>> updateBusRoute({
    required String id,
    required BusRouteEntity busRoute,
  });

  Future<Result<void, Exception>> deleteBusRoute({
    required String id,
  });

  Future<Result<List<BusRouteEntity>, Exception>> searchBusRoutes({
    required String query,
    int? limit,
    int? offset,
  });

  Future<Result<List<BusRouteEntity>, Exception>> getNearbyBusRoutes({
    required LatLng location,
    double? radius,
    int? limit,
  });

  // GTFS Agencies operations
  Future<Result<List<GtfsAgencyEntity>, Exception>> getGtfsAgencies();

  Future<Result<GtfsAgencyEntity, Exception>> getGtfsAgency({
    required String id,
  });

  Future<Result<GtfsAgencyEntity, Exception>> createGtfsAgency({
    required GtfsAgencyEntity agency,
  });

  Future<Result<GtfsAgencyEntity, Exception>> updateGtfsAgency({
    required String id,
    required GtfsAgencyEntity agency,
  });

  Future<Result<void, Exception>> deleteGtfsAgency({
    required String id,
  });

  Future<Result<int, Exception>> getGtfsAgenciesCount();

  // GTFS Routes operations
  Future<Result<List<GtfsRouteEntity>, Exception>> getGtfsRoutes({
    int? limit,
    int? offset,
    String? routeType,
  });

  Future<Result<GtfsRouteEntity, Exception>> getGtfsRoute({
    required String id,
  });

  Future<Result<GtfsRouteEntity, Exception>> createGtfsRoute({
    required GtfsRouteEntity route,
  });

  Future<Result<GtfsRouteEntity, Exception>> updateGtfsRoute({
    required String id,
    required GtfsRouteEntity route,
  });

  Future<Result<void, Exception>> deleteGtfsRoute({
    required String id,
  });

  Future<Result<int, Exception>> getGtfsRoutesCount();

  Future<Result<List<GtfsRouteEntity>, Exception>> getGtfsRoutesByType({
    required int routeType,
  });

  Future<Result<List<GtfsRouteEntity>, Exception>> getGtfsRoutesByAgency({
    required String agencyId,
  });

  // GTFS Stops operations
  Future<Result<List<GtfsStopEntity>, Exception>> getGtfsStops({
    int? limit,
    int? offset,
    String? stopId,
  });

  Future<Result<GtfsStopEntity, Exception>> getGtfsStop({
    required String id,
  });

  Future<Result<GtfsStopEntity, Exception>> createGtfsStop({
    required GtfsStopEntity stop,
  });

  Future<Result<GtfsStopEntity, Exception>> updateGtfsStop({
    required String id,
    required GtfsStopEntity stop,
  });

  Future<Result<void, Exception>> deleteGtfsStop({
    required String id,
  });

  Future<Result<int, Exception>> getGtfsStopsCount();

  Future<Result<List<GtfsStopEntity>, Exception>> getNearbyGtfsStops({
    required LatLng location,
    double? radius,
    int? limit,
  });

  Future<Result<List<GtfsStopEntity>, Exception>> getGtfsStopsByZone({
    required String zoneId,
  });

  Future<Result<List<GtfsStopEntity>, Exception>> getGtfsAccessibleStops();

  // GTFS Trips operations
  Future<Result<List<GtfsTripEntity>, Exception>> getGtfsTrips();

  Future<Result<GtfsTripEntity, Exception>> getGtfsTrip({
    required String id,
  });

  Future<Result<GtfsTripEntity, Exception>> createGtfsTrip({
    required GtfsTripEntity trip,
  });

  Future<Result<GtfsTripEntity, Exception>> updateGtfsTrip({
    required String id,
    required GtfsTripEntity trip,
  });

  Future<Result<void, Exception>> deleteGtfsTrip({
    required String id,
  });

  Future<Result<int, Exception>> getGtfsTripsCount();

  Future<Result<List<GtfsTripEntity>, Exception>> getGtfsTripsByService({
    required String serviceId,
  });

  Future<Result<List<GtfsTripEntity>, Exception>> getGtfsTripsByRoute({
    required String routeId,
  });

  Future<Result<List<GtfsTripEntity>, Exception>>
      getGtfsTripsByRouteAndDirection({
    required String routeId,
    required int directionId,
  });

  // GTFS Stop Times operations
  Future<Result<List<GtfsStopTimeEntity>, Exception>> getGtfsStopTimes();

  Future<Result<GtfsStopTimeEntity, Exception>> getGtfsStopTime({
    required int id,
  });

  Future<Result<GtfsStopTimeEntity, Exception>> createGtfsStopTime({
    required GtfsStopTimeEntity stopTime,
  });

  Future<Result<GtfsStopTimeEntity, Exception>> updateGtfsStopTime({
    required int id,
    required GtfsStopTimeEntity stopTime,
  });

  Future<Result<void, Exception>> deleteGtfsStopTime({
    required int id,
  });

  Future<Result<int, Exception>> getGtfsStopTimesCount();

  Future<Result<List<GtfsStopTimeEntity>, Exception>> getGtfsStopTimesByTrip({
    required String tripId,
  });

  Future<Result<List<GtfsStopTimeEntity>, Exception>> getGtfsStopTimesByStop({
    required String stopId,
  });

  // GTFS Shapes operations
  Future<Result<List<GtfsShapeEntity>, Exception>> getGtfsShapes({
    required String routeId,
  });

  Future<Result<GtfsShapeEntity, Exception>> getGtfsShape({
    required int id,
  });

  Future<Result<GtfsShapeEntity, Exception>> createGtfsShape({
    required GtfsShapeEntity shape,
  });

  Future<Result<GtfsShapeEntity, Exception>> updateGtfsShape({
    required int id,
    required GtfsShapeEntity shape,
  });

  Future<Result<void, Exception>> deleteGtfsShape({
    required int id,
  });

  Future<Result<int, Exception>> getGtfsShapesCount();

  // GTFS Calendar operations
  Future<Result<List<GtfsCalendarEntity>, Exception>> getGtfsCalendars();

  Future<Result<GtfsCalendarEntity, Exception>> getGtfsCalendar({
    required String id,
  });

  Future<Result<GtfsCalendarEntity, Exception>> createGtfsCalendar({
    required GtfsCalendarEntity calendar,
  });

  Future<Result<GtfsCalendarEntity, Exception>> updateGtfsCalendar({
    required String id,
    required GtfsCalendarEntity calendar,
  });

  Future<Result<void, Exception>> deleteGtfsCalendar({
    required String id,
  });

  Future<Result<int, Exception>> getGtfsCalendarsCount();

  // GTFS Calendar Dates operations
  Future<Result<List<GtfsCalendarDatesEntity>, Exception>>
      getGtfsCalendarDates();

  Future<Result<GtfsCalendarDatesEntity, Exception>> getGtfsCalendarDate({
    required int id,
  });

  Future<Result<GtfsCalendarDatesEntity, Exception>> createGtfsCalendarDate({
    required GtfsCalendarDatesEntity calendarDate,
  });

  Future<Result<GtfsCalendarDatesEntity, Exception>> updateGtfsCalendarDate({
    required int id,
    required GtfsCalendarDatesEntity calendarDate,
  });

  Future<Result<void, Exception>> deleteGtfsCalendarDate({
    required int id,
  });

  Future<Result<int, Exception>> getGtfsCalendarDatesCount();

  // GTFS Blocks operations
  Future<Result<List<GtfsBlockEntity>, Exception>> getGtfsBlocks();

  Future<Result<GtfsBlockEntity, Exception>> getGtfsBlock({
    required String id,
  });

  Future<Result<GtfsBlockEntity, Exception>> createGtfsBlock({
    required GtfsBlockEntity block,
  });

  Future<Result<GtfsBlockEntity, Exception>> updateGtfsBlock({
    required String id,
    required GtfsBlockEntity block,
  });

  Future<Result<void, Exception>> deleteGtfsBlock({
    required String id,
  });

  Future<Result<int, Exception>> getGtfsBlocksCount();

  // Legacy/Custom GTFS operations (keeping for backward compatibility)
  Future<Result<List<GtfsStopEntity>, Exception>> getGtfsStopsForRoute({
    required String routeId,
  });

  Future<Result<List<GtfsScheduleWithDelaysEntity>, Exception>>
      getGtfsScheduleForStop({
    required String stopId,
    int? limit,
  });

  Future<Result<List<GtfsDelayEntity>, Exception>> getGtfsDelaysForRoute({
    required String routeId,
  });

  // Reports operations
  Future<Result<List<ReportEntity>, Exception>> getReports();

  Future<Result<ReportEntity, Exception>> getReport({
    required int id,
  });

  Future<Result<ReportEntity, Exception>> createReport({
    required ReportEntity report,
  });

  Future<Result<ReportEntity, Exception>> updateReport({
    required int id,
    required ReportEntity report,
  });

  Future<Result<void, Exception>> deleteReport({
    required int id,
  });

  Future<Result<List<ReportEntity>, Exception>> getReportsByType({
    required String type,
  });

  Future<Result<List<ReportEntity>, Exception>> getReportsByTimeRange({
    required int startTime,
    required int endTime,
  });

  Future<Result<List<ReportEntity>, Exception>> getReportsByRoute({
    required String routeId,
  });

  Future<Result<List<ReportEntity>, Exception>> getEmergencyReportsByRoute({
    required String routeId,
  });

  Future<Result<List<ReportEntity>, Exception>> getRecentReports({
    required int hours,
  });

  Future<Result<List<ReportEntity>, Exception>> getReportsByEmergencyStatus({
    required bool isEmergency,
  });

  Future<Result<int, Exception>> getReportsCount();

  Future<Result<int, Exception>> getReportsCountByType({
    required String type,
  });

  Future<Result<int, Exception>> getEmergencyReportsCount();
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
