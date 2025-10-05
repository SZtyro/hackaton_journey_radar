// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gtfs_shape_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GtfsShapeDto _$GtfsShapeDtoFromJson(Map<String, dynamic> json) => GtfsShapeDto(
      shapeId: json['shape_id'] as String,
      shapePtLat: (json['shape_pt_lat'] as num).toDouble(),
      shapePtLon: (json['shape_pt_lon'] as num).toDouble(),
      shapePtSequence: (json['shape_pt_sequence'] as num).toInt(),
      shapeDistTraveled: (json['shape_dist_traveled'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$GtfsShapeDtoToJson(GtfsShapeDto instance) =>
    <String, dynamic>{
      'shape_id': instance.shapeId,
      'shape_pt_lat': instance.shapePtLat,
      'shape_pt_lon': instance.shapePtLon,
      'shape_pt_sequence': instance.shapePtSequence,
      'shape_dist_traveled': instance.shapeDistTraveled,
    };
