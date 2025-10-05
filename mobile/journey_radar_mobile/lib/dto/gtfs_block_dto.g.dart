// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gtfs_block_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GtfsBlockDto _$GtfsBlockDtoFromJson(Map<String, dynamic> json) => GtfsBlockDto(
      blockId: json['block_id'] as String,
      shift: json['shift'] as String?,
    );

Map<String, dynamic> _$GtfsBlockDtoToJson(GtfsBlockDto instance) =>
    <String, dynamic>{
      'block_id': instance.blockId,
      'shift': instance.shift,
    };
