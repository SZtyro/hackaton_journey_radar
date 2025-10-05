import 'package:journey_radar_mobile/entity/entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'gtfs_shape_dto.g.dart';

@JsonSerializable()
class GtfsShapeDto {
  @JsonKey(name: 'shape_id')
  final String? shapeId;

  @JsonKey(name: 'shape_pt_lat')
  final double? shapePtLat;

  @JsonKey(name: 'shape_pt_lon')
  final double? shapePtLon;

  @JsonKey(name: 'shape_pt_sequence')
  final int? shapePtSequence;

  @JsonKey(name: 'shape_dist_traveled')
  final double? shapeDistTraveled;

  const GtfsShapeDto({
    this.shapeId,
    this.shapePtLat,
    this.shapePtLon,
    this.shapePtSequence,
    this.shapeDistTraveled,
  });

  factory GtfsShapeDto.fromJson(Map<String, dynamic> json) =>
      _$GtfsShapeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GtfsShapeDtoToJson(this);

  GtfsShapeEntity toEntity() {
    return GtfsShapeEntity(
      shapeId: shapeId,
      position: shapePtLat != null && shapePtLon != null
          ? LatLng(shapePtLat!, shapePtLon!)
          : null,
      sequence: shapePtSequence,
      distanceTraveled: shapeDistTraveled,
    );
  }

  factory GtfsShapeDto.fromEntity(GtfsShapeEntity entity) {
    return GtfsShapeDto(
      shapeId: entity.shapeId,
      shapePtLat: entity.position?.latitude,
      shapePtLon: entity.position?.longitude,
      shapePtSequence: entity.sequence,
      shapeDistTraveled: entity.distanceTraveled,
    );
  }
}
