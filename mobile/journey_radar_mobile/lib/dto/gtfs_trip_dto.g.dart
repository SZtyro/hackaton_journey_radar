// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gtfs_trip_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GtfsTripDto _$GtfsTripDtoFromJson(Map<String, dynamic> json) => GtfsTripDto(
      routeId: json['route_id'] as String,
      serviceId: json['service_id'] as String,
      tripId: json['trip_id'] as String,
      tripHeadsign: json['trip_headsign'] as String?,
      tripShortName: json['trip_short_name'] as String?,
      directionId: (json['direction_id'] as num?)?.toInt(),
      blockId: json['block_id'] as String?,
      shapeId: json['shape_id'] as String?,
      wheelchairAccessible: (json['wheelchair_accessible'] as num?)?.toInt(),
      bikesAllowed: (json['bikes_allowed'] as num?)?.toInt(),
      tripRouteType: (json['trip_route_type'] as num?)?.toInt(),
      tripPatternId: json['trip_pattern_id'] as String?,
    );

Map<String, dynamic> _$GtfsTripDtoToJson(GtfsTripDto instance) =>
    <String, dynamic>{
      'route_id': instance.routeId,
      'service_id': instance.serviceId,
      'trip_id': instance.tripId,
      'trip_headsign': instance.tripHeadsign,
      'trip_short_name': instance.tripShortName,
      'direction_id': instance.directionId,
      'block_id': instance.blockId,
      'shape_id': instance.shapeId,
      'wheelchair_accessible': instance.wheelchairAccessible,
      'bikes_allowed': instance.bikesAllowed,
      'trip_route_type': instance.tripRouteType,
      'trip_pattern_id': instance.tripPatternId,
    };
