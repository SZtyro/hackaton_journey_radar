// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bus_route_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusRouteDto _$BusRouteDtoFromJson(Map<String, dynamic> json) => BusRouteDto(
      id: json['id'] as String,
      name: json['name'] as String,
      number: json['number'] as String,
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => (e as Map<String, dynamic>).map(
                (k, e) => MapEntry(k, (e as num).toDouble()),
              ))
          .toList(),
      color: json['color'] as String,
      description: json['description'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$BusRouteDtoToJson(BusRouteDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'number': instance.number,
      'coordinates': instance.coordinates,
      'color': instance.color,
      'description': instance.description,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
