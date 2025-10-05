import 'package:journey_radar_mobile/entity/entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'gtfs_stop_dto.g.dart';

@JsonSerializable()
class GtfsStopDto {
  @JsonKey(name: 'stop_id')
  final String? stopId;

  @JsonKey(name: 'stop_code')
  final String? stopCode;

  @JsonKey(name: 'stop_name')
  final String? stopName;

  @JsonKey(name: 'stop_desc')
  final String? stopDesc;

  @JsonKey(name: 'stop_lat')
  final double? stopLat;

  @JsonKey(name: 'stop_lon')
  final double? stopLon;

  @JsonKey(name: 'zone_id')
  final String? zoneId;

  @JsonKey(name: 'stop_url')
  final String? stopUrl;

  @JsonKey(name: 'location_type')
  final int? locationType;

  @JsonKey(name: 'parent_station')
  final String? parentStation;

  @JsonKey(name: 'stop_timezone')
  final String? stopTimezone;

  @JsonKey(name: 'wheelchair_boarding')
  final int? wheelchairBoarding;

  @JsonKey(name: 'level_id')
  final String? levelId;

  @JsonKey(name: 'platform_code')
  final String? platformCode;

  const GtfsStopDto({
    this.stopId,
    this.stopCode,
    this.stopName,
    this.stopDesc,
    this.stopLat,
    this.stopLon,
    this.zoneId,
    this.stopUrl,
    this.locationType,
    this.parentStation,
    this.stopTimezone,
    this.wheelchairBoarding,
    this.levelId,
    this.platformCode,
  });

  factory GtfsStopDto.fromJson(Map<String, dynamic> json) =>
      _$GtfsStopDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GtfsStopDtoToJson(this);

  GtfsStopEntity toEntity() {
    return GtfsStopEntity(
      stopId: stopId,
      stopCode: stopCode,
      stopName: stopName,
      stopDesc: stopDesc,
      position: stopLat != null && stopLon != null
          ? LatLng(stopLat!, stopLon!)
          : null,
      zoneId: zoneId,
      stopUrl: stopUrl,
      locationType: locationType,
      parentStation: parentStation,
      stopTimezone: stopTimezone,
      wheelchairBoarding: wheelchairBoarding,
      levelId: levelId,
      platformCode: platformCode,
    );
  }

  factory GtfsStopDto.fromEntity(GtfsStopEntity entity) {
    return GtfsStopDto(
      stopId: entity.stopId,
      stopCode: entity.stopCode,
      stopName: entity.stopName,
      stopDesc: entity.stopDesc,
      stopLat: entity.position?.latitude,
      stopLon: entity.position?.longitude,
      zoneId: entity.zoneId,
      stopUrl: entity.stopUrl,
      locationType: entity.locationType,
      parentStation: entity.parentStation,
      stopTimezone: entity.stopTimezone,
      wheelchairBoarding: entity.wheelchairBoarding,
      levelId: entity.levelId,
      platformCode: entity.platformCode,
    );
  }
}
