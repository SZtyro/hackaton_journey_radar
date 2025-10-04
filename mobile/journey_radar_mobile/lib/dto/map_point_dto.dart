import 'package:journey_radar_mobile/entity/entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'map_point_dto.g.dart';

@JsonSerializable()
class MapPointDto {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'latitude')
  final double latitude;

  @JsonKey(name: 'longitude')
  final double longitude;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'buttonText')
  final String? buttonText;

  @JsonKey(name: 'iconType')
  final String iconType;

  @JsonKey(name: 'color')
  final String color;

  @JsonKey(name: 'createdAt')
  final String createdAt;

  @JsonKey(name: 'updatedAt')
  final String? updatedAt;

  const MapPointDto({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.title,
    this.description,
    this.buttonText,
    required this.iconType,
    required this.color,
    required this.createdAt,
    this.updatedAt,
  });

  factory MapPointDto.fromJson(Map<String, dynamic> json) =>
      _$MapPointDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MapPointDtoToJson(this);

  MapPointEntity toEntity() {
    return MapPointEntity(
      id: id,
      position: LatLng(latitude, longitude),
      title: title,
      description: description,
      buttonText: buttonText,
      iconType: iconType,
      color: color,
      createdAt: DateTime.parse(createdAt),
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }

  factory MapPointDto.fromEntity(MapPointEntity entity) {
    return MapPointDto(
      id: entity.id,
      latitude: entity.position.latitude,
      longitude: entity.position.longitude,
      title: entity.title,
      description: entity.description,
      buttonText: entity.buttonText,
      iconType: entity.iconType,
      color: entity.color,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt?.toIso8601String(),
    );
  }
}
