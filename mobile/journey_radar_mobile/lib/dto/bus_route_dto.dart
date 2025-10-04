import 'package:journey_radar_mobile/entity/entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'bus_route_dto.g.dart';

@JsonSerializable()
class BusRouteDto {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'number')
  final String number;

  @JsonKey(name: 'coordinates')
  final List<Map<String, double>> coordinates;

  @JsonKey(name: 'color')
  final String color;

  @JsonKey(name: 'description')
  final String description;

  @JsonKey(name: 'createdAt')
  final String createdAt;

  @JsonKey(name: 'updatedAt')
  final String? updatedAt;

  const BusRouteDto({
    required this.id,
    required this.name,
    required this.number,
    required this.coordinates,
    required this.color,
    required this.description,
    required this.createdAt,
    this.updatedAt,
  });

  factory BusRouteDto.fromJson(Map<String, dynamic> json) =>
      _$BusRouteDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BusRouteDtoToJson(this);

  BusRouteEntity toEntity() {
    return BusRouteEntity(
      id: id,
      name: name,
      number: number,
      coordinates: coordinates
          .map((coord) => LatLng(coord['lat']!, coord['lng']!))
          .toList(),
      color: color,
      description: description,
      createdAt: DateTime.parse(createdAt),
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }

  factory BusRouteDto.fromEntity(BusRouteEntity entity) {
    return BusRouteDto(
      id: entity.id,
      name: entity.name,
      number: entity.number,
      coordinates: entity.coordinates
          .map((coord) => {'lat': coord.latitude, 'lng': coord.longitude})
          .toList(),
      color: entity.color,
      description: entity.description,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt?.toIso8601String(),
    );
  }
}
