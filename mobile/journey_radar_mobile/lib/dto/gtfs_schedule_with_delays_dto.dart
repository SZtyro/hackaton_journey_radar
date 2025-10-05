import 'package:journey_radar_mobile/entity/entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gtfs_schedule_with_delays_dto.g.dart';

@JsonSerializable()
class GtfsScheduleWithDelaysDto {
  @JsonKey(name: 'stop_id')
  final String stopId;

  @JsonKey(name: 'stop_name')
  final String stopName;

  @JsonKey(name: 'route_id')
  final String routeId;

  @JsonKey(name: 'route_short_name')
  final String? routeShortName;

  @JsonKey(name: 'route_long_name')
  final String? routeLongName;

  @JsonKey(name: 'route_color')
  final String? routeColor;

  @JsonKey(name: 'trip_id')
  final String tripId;

  @JsonKey(name: 'trip_headsign')
  final String? tripHeadsign;

  @JsonKey(name: 'scheduled_arrival_time')
  final String? scheduledArrivalTime;

  @JsonKey(name: 'scheduled_departure_time')
  final String? scheduledDepartureTime;

  @JsonKey(name: 'real_time_arrival_time')
  final String? realTimeArrivalTime;

  @JsonKey(name: 'real_time_departure_time')
  final String? realTimeDepartureTime;

  @JsonKey(name: 'delay_seconds')
  final int? delaySeconds;

  @JsonKey(name: 'delay_type')
  final String? delayType;

  @JsonKey(name: 'delay_reason')
  final String? delayReason;

  @JsonKey(name: 'stop_sequence')
  final int stopSequence;

  @JsonKey(name: 'direction_id')
  final int? directionId;

  @JsonKey(name: 'wheelchair_accessible')
  final int? wheelchairAccessible;

  @JsonKey(name: 'bikes_allowed')
  final int? bikesAllowed;

  @JsonKey(name: 'service_id')
  final String serviceId;

  @JsonKey(name: 'is_real_time')
  final bool isRealTime;

  const GtfsScheduleWithDelaysDto({
    required this.stopId,
    required this.stopName,
    required this.routeId,
    this.routeShortName,
    this.routeLongName,
    this.routeColor,
    required this.tripId,
    this.tripHeadsign,
    this.scheduledArrivalTime,
    this.scheduledDepartureTime,
    this.realTimeArrivalTime,
    this.realTimeDepartureTime,
    this.delaySeconds,
    this.delayType,
    this.delayReason,
    required this.stopSequence,
    this.directionId,
    this.wheelchairAccessible,
    this.bikesAllowed,
    required this.serviceId,
    required this.isRealTime,
  });

  factory GtfsScheduleWithDelaysDto.fromJson(Map<String, dynamic> json) =>
      _$GtfsScheduleWithDelaysDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GtfsScheduleWithDelaysDtoToJson(this);

  GtfsScheduleWithDelaysEntity toEntity() {
    return GtfsScheduleWithDelaysEntity(
      stopId: stopId,
      stopName: stopName,
      routeId: routeId,
      routeShortName: routeShortName,
      routeLongName: routeLongName,
      routeColor: routeColor,
      tripId: tripId,
      tripHeadsign: tripHeadsign,
      scheduledArrivalTime: scheduledArrivalTime,
      scheduledDepartureTime: scheduledDepartureTime,
      realTimeArrivalTime: realTimeArrivalTime,
      realTimeDepartureTime: realTimeDepartureTime,
      delaySeconds: delaySeconds,
      delayType: delayType,
      delayReason: delayReason,
      stopSequence: stopSequence,
      directionId: directionId,
      wheelchairAccessible: wheelchairAccessible,
      bikesAllowed: bikesAllowed,
      serviceId: serviceId,
      isRealTime: isRealTime,
    );
  }

  factory GtfsScheduleWithDelaysDto.fromEntity(
      GtfsScheduleWithDelaysEntity entity) {
    return GtfsScheduleWithDelaysDto(
      stopId: entity.stopId,
      stopName: entity.stopName,
      routeId: entity.routeId,
      routeShortName: entity.routeShortName,
      routeLongName: entity.routeLongName,
      routeColor: entity.routeColor,
      tripId: entity.tripId,
      tripHeadsign: entity.tripHeadsign,
      scheduledArrivalTime: entity.scheduledArrivalTime,
      scheduledDepartureTime: entity.scheduledDepartureTime,
      realTimeArrivalTime: entity.realTimeArrivalTime,
      realTimeDepartureTime: entity.realTimeDepartureTime,
      delaySeconds: entity.delaySeconds,
      delayType: entity.delayType,
      delayReason: entity.delayReason,
      stopSequence: entity.stopSequence,
      directionId: entity.directionId,
      wheelchairAccessible: entity.wheelchairAccessible,
      bikesAllowed: entity.bikesAllowed,
      serviceId: entity.serviceId,
      isRealTime: entity.isRealTime,
    );
  }
}
