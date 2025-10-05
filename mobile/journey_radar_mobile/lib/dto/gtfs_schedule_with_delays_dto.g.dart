// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gtfs_schedule_with_delays_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GtfsScheduleWithDelaysDto _$GtfsScheduleWithDelaysDtoFromJson(
        Map<String, dynamic> json) =>
    GtfsScheduleWithDelaysDto(
      stopId: json['stop_id'] as String?,
      stopName: json['stop_name'] as String?,
      routeId: json['route_id'] as String?,
      routeShortName: json['route_short_name'] as String?,
      routeLongName: json['route_long_name'] as String?,
      routeColor: json['route_color'] as String?,
      tripId: json['trip_id'] as String?,
      tripHeadsign: json['trip_headsign'] as String?,
      scheduledArrivalTime: json['scheduled_arrival_time'] as String?,
      scheduledDepartureTime: json['scheduled_departure_time'] as String?,
      realTimeArrivalTime: json['real_time_arrival_time'] as String?,
      realTimeDepartureTime: json['real_time_departure_time'] as String?,
      delaySeconds: (json['delay_seconds'] as num?)?.toInt(),
      delayType: json['delay_type'] as String?,
      delayReason: json['delay_reason'] as String?,
      stopSequence: (json['stop_sequence'] as num?)?.toInt(),
      directionId: (json['direction_id'] as num?)?.toInt(),
      wheelchairAccessible: (json['wheelchair_accessible'] as num?)?.toInt(),
      bikesAllowed: (json['bikes_allowed'] as num?)?.toInt(),
      serviceId: json['service_id'] as String?,
      isRealTime: json['is_real_time'] as bool?,
    );

Map<String, dynamic> _$GtfsScheduleWithDelaysDtoToJson(
        GtfsScheduleWithDelaysDto instance) =>
    <String, dynamic>{
      'stop_id': instance.stopId,
      'stop_name': instance.stopName,
      'route_id': instance.routeId,
      'route_short_name': instance.routeShortName,
      'route_long_name': instance.routeLongName,
      'route_color': instance.routeColor,
      'trip_id': instance.tripId,
      'trip_headsign': instance.tripHeadsign,
      'scheduled_arrival_time': instance.scheduledArrivalTime,
      'scheduled_departure_time': instance.scheduledDepartureTime,
      'real_time_arrival_time': instance.realTimeArrivalTime,
      'real_time_departure_time': instance.realTimeDepartureTime,
      'delay_seconds': instance.delaySeconds,
      'delay_type': instance.delayType,
      'delay_reason': instance.delayReason,
      'stop_sequence': instance.stopSequence,
      'direction_id': instance.directionId,
      'wheelchair_accessible': instance.wheelchairAccessible,
      'bikes_allowed': instance.bikesAllowed,
      'service_id': instance.serviceId,
      'is_real_time': instance.isRealTime,
    };
