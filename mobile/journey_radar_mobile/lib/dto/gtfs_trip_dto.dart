import 'package:journey_radar_mobile/entity/entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gtfs_trip_dto.g.dart';

@JsonSerializable()
class GtfsTripDto {
  @JsonKey(name: 'route_id')
  final String routeId;

  @JsonKey(name: 'service_id')
  final String serviceId;

  @JsonKey(name: 'trip_id')
  final String tripId;

  @JsonKey(name: 'trip_headsign')
  final String? tripHeadsign;

  @JsonKey(name: 'trip_short_name')
  final String? tripShortName;

  @JsonKey(name: 'direction_id')
  final int? directionId;

  @JsonKey(name: 'block_id')
  final String? blockId;

  @JsonKey(name: 'shape_id')
  final String? shapeId;

  @JsonKey(name: 'wheelchair_accessible')
  final int? wheelchairAccessible;

  @JsonKey(name: 'bikes_allowed')
  final int? bikesAllowed;

  @JsonKey(name: 'trip_route_type')
  final int? tripRouteType;

  @JsonKey(name: 'trip_pattern_id')
  final String? tripPatternId;

  const GtfsTripDto({
    required this.routeId,
    required this.serviceId,
    required this.tripId,
    this.tripHeadsign,
    this.tripShortName,
    this.directionId,
    this.blockId,
    this.shapeId,
    this.wheelchairAccessible,
    this.bikesAllowed,
    this.tripRouteType,
    this.tripPatternId,
  });

  factory GtfsTripDto.fromJson(Map<String, dynamic> json) =>
      _$GtfsTripDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GtfsTripDtoToJson(this);

  GtfsTripEntity toEntity() {
    return GtfsTripEntity(
      routeId: routeId,
      serviceId: serviceId,
      tripId: tripId,
      tripHeadsign: tripHeadsign,
      tripShortName: tripShortName,
      directionId: directionId,
      blockId: blockId,
      shapeId: shapeId,
      wheelchairAccessible: wheelchairAccessible,
      bikesAllowed: bikesAllowed,
      tripRouteType: tripRouteType,
      tripPatternId: tripPatternId,
    );
  }

  factory GtfsTripDto.fromEntity(GtfsTripEntity entity) {
    return GtfsTripDto(
      routeId: entity.routeId,
      serviceId: entity.serviceId,
      tripId: entity.tripId,
      tripHeadsign: entity.tripHeadsign,
      tripShortName: entity.tripShortName,
      directionId: entity.directionId,
      blockId: entity.blockId,
      shapeId: entity.shapeId,
      wheelchairAccessible: entity.wheelchairAccessible,
      bikesAllowed: entity.bikesAllowed,
      tripRouteType: entity.tripRouteType,
      tripPatternId: entity.tripPatternId,
    );
  }
}
