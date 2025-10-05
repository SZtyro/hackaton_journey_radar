// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportDto _$ReportDtoFromJson(Map<String, dynamic> json) => ReportDto(
      id: (json['id'] as num?)?.toInt(),
      createdDate: json['createdDate'] == null
          ? null
          : DateTime.parse(json['createdDate'] as String),
      version: (json['version'] as num?)?.toInt(),
      draft: json['draft'] as bool?,
      type: $enumDecode(_$ReportTypeEnumMap, json['type']),
      typeDisplayName: json['typeDisplayName'] as String?,
      description: json['description'] as String?,
      route: json['route'] == null
          ? null
          : GtfsRouteDto.fromJson(json['route'] as Map<String, dynamic>),
      timestamp: DateTime.parse(json['timestamp'] as String),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      emergency: json['emergency'] as bool,
    );

Map<String, dynamic> _$ReportDtoToJson(ReportDto instance) => <String, dynamic>{
      'id': instance.id,
      'createdDate': instance.createdDate?.toIso8601String(),
      'version': instance.version,
      'draft': instance.draft,
      'type': _$ReportTypeEnumMap[instance.type]!,
      'typeDisplayName': instance.typeDisplayName,
      'description': instance.description,
      'route': instance.route?.toJson(),
      'timestamp': instance.timestamp.toIso8601String(),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'emergency': instance.emergency,
    };

const _$ReportTypeEnumMap = {
  ReportType.accident: 'ACCIDENT',
  ReportType.laneClosure: 'LANE_CLOSURE',
  ReportType.vehicleBreakdown: 'VEHICLE_BREAKDOWN',
  ReportType.collision: 'COLLISION',
  ReportType.pedestrianAccident: 'PEDESTRIAN_ACCIDENT',
  ReportType.other: 'OTHER',
};
