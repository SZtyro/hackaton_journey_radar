// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gtfs_delay_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GtfsDelayDto _$GtfsDelayDtoFromJson(Map<String, dynamic> json) => GtfsDelayDto(
      tripId: json['trip_id'] as String?,
      stopId: json['stop_id'] as String?,
      delaySeconds: (json['delay_seconds'] as num?)?.toInt(),
      delayType: json['delay_type'] as String?,
      reason: json['reason'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$GtfsDelayDtoToJson(GtfsDelayDto instance) =>
    <String, dynamic>{
      'trip_id': instance.tripId,
      'stop_id': instance.stopId,
      'delay_seconds': instance.delaySeconds,
      'delay_type': instance.delayType,
      'reason': instance.reason,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
