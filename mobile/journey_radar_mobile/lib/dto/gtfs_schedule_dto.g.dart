// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gtfs_schedule_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GtfsScheduleDto _$GtfsScheduleDtoFromJson(Map<String, dynamic> json) =>
    GtfsScheduleDto(
      stopId: json['stop_id'] as String,
      stopName: json['stop_name'] as String,
      routeId: json['route_id'] as String,
      routeShortName: json['route_short_name'] as String?,
      routeLongName: json['route_long_name'] as String?,
      routeColor: json['route_color'] as String?,
      tripId: json['trip_id'] as String,
      tripHeadsign: json['trip_headsign'] as String?,
      arrivalTime: json['arrival_time'] as String?,
      departureTime: json['departure_time'] as String?,
      stopSequence: (json['stop_sequence'] as num).toInt(),
      directionId: (json['direction_id'] as num?)?.toInt(),
      wheelchairAccessible: (json['wheelchair_accessible'] as num?)?.toInt(),
      bikesAllowed: (json['bikes_allowed'] as num?)?.toInt(),
      serviceId: json['service_id'] as String,
    );

Map<String, dynamic> _$GtfsScheduleDtoToJson(GtfsScheduleDto instance) =>
    <String, dynamic>{
      'stop_id': instance.stopId,
      'stop_name': instance.stopName,
      'route_id': instance.routeId,
      'route_short_name': instance.routeShortName,
      'route_long_name': instance.routeLongName,
      'route_color': instance.routeColor,
      'trip_id': instance.tripId,
      'trip_headsign': instance.tripHeadsign,
      'arrival_time': instance.arrivalTime,
      'departure_time': instance.departureTime,
      'stop_sequence': instance.stopSequence,
      'direction_id': instance.directionId,
      'wheelchair_accessible': instance.wheelchairAccessible,
      'bikes_allowed': instance.bikesAllowed,
      'service_id': instance.serviceId,
    };
