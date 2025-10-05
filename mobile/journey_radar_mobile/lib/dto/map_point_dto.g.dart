// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_point_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapPointDto _$MapPointDtoFromJson(Map<String, dynamic> json) => MapPointDto(
      id: json['id'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      title: json['title'] as String,
      description: json['description'] as String?,
      buttonText: json['buttonText'] as String?,
      iconType: json['iconType'] as String,
      color: json['color'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$MapPointDtoToJson(MapPointDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'title': instance.title,
      'description': instance.description,
      'buttonText': instance.buttonText,
      'iconType': instance.iconType,
      'color': instance.color,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
