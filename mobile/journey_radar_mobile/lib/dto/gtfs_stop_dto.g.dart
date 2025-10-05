// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gtfs_stop_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GtfsStopDto _$GtfsStopDtoFromJson(Map<String, dynamic> json) => GtfsStopDto(
      stopId: json['stop_id'] as String?,
      stopCode: json['stop_code'] as String?,
      stopName: json['stop_name'] as String?,
      stopDesc: json['stop_desc'] as String?,
      stopLat: (json['stop_lat'] as num?)?.toDouble(),
      stopLon: (json['stop_lon'] as num?)?.toDouble(),
      zoneId: json['zone_id'] as String?,
      stopUrl: json['stop_url'] as String?,
      locationType: (json['location_type'] as num?)?.toInt(),
      parentStation: json['parent_station'] as String?,
      stopTimezone: json['stop_timezone'] as String?,
      wheelchairBoarding: (json['wheelchair_boarding'] as num?)?.toInt(),
      levelId: json['level_id'] as String?,
      platformCode: json['platform_code'] as String?,
    );

Map<String, dynamic> _$GtfsStopDtoToJson(GtfsStopDto instance) =>
    <String, dynamic>{
      'stop_id': instance.stopId,
      'stop_code': instance.stopCode,
      'stop_name': instance.stopName,
      'stop_desc': instance.stopDesc,
      'stop_lat': instance.stopLat,
      'stop_lon': instance.stopLon,
      'zone_id': instance.zoneId,
      'stop_url': instance.stopUrl,
      'location_type': instance.locationType,
      'parent_station': instance.parentStation,
      'stop_timezone': instance.stopTimezone,
      'wheelchair_boarding': instance.wheelchairBoarding,
      'level_id': instance.levelId,
      'platform_code': instance.platformCode,
    };
