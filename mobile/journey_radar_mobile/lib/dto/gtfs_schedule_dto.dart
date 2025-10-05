import 'package:journey_radar_mobile/entity/entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gtfs_schedule_dto.g.dart';

@JsonSerializable()
class GtfsScheduleDto {
  @JsonKey(name: 'stop_id')
  final String stopId;

  @JsonKey(name: 'stop_name')
  final String stopName;

  @JsonKey(name: 'route_id')
  final String routeId;

  @JsonKey(name: 'route_short_name')
  final String? routeShortName;

  @JsonKey(name: 'route_long_name')
  final String? routeLongName;

  @JsonKey(name: 'route_color')
  final String? routeColor;

  @JsonKey(name: 'trip_id')
  final String tripId;

  @JsonKey(name: 'trip_headsign')
  final String? tripHeadsign;

  @JsonKey(name: 'arrival_time')
  final String? arrivalTime;

  @JsonKey(name: 'departure_time')
  final String? departureTime;

  @JsonKey(name: 'stop_sequence')
  final int stopSequence;

  @JsonKey(name: 'direction_id')
  final int? directionId;

  @JsonKey(name: 'wheelchair_accessible')
  final int? wheelchairAccessible;

  @JsonKey(name: 'bikes_allowed')
  final int? bikesAllowed;

  @JsonKey(name: 'service_id')
  final String serviceId;

  const GtfsScheduleDto({
    required this.stopId,
    required this.stopName,
    required this.routeId,
    this.routeShortName,
    this.routeLongName,
    this.routeColor,
    required this.tripId,
    this.tripHeadsign,
    this.arrivalTime,
    this.departureTime,
    required this.stopSequence,
    this.directionId,
    this.wheelchairAccessible,
    this.bikesAllowed,
    required this.serviceId,
  });

  factory GtfsScheduleDto.fromJson(Map<String, dynamic> json) =>
      _$GtfsScheduleDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GtfsScheduleDtoToJson(this);

  GtfsScheduleEntity toEntity() {
    return GtfsScheduleEntity(
      stopId: stopId,
      stopName: stopName,
      routeId: routeId,
      routeShortName: routeShortName,
      routeLongName: routeLongName,
      routeColor: routeColor,
      tripId: tripId,
      tripHeadsign: tripHeadsign,
      arrivalTime: arrivalTime,
      departureTime: departureTime,
      stopSequence: stopSequence,
      directionId: directionId,
      wheelchairAccessible: wheelchairAccessible,
      bikesAllowed: bikesAllowed,
      serviceId: serviceId,
    );
  }

  factory GtfsScheduleDto.fromEntity(GtfsScheduleEntity entity) {
    return GtfsScheduleDto(
      stopId: entity.stopId,
      stopName: entity.stopName,
      routeId: entity.routeId,
      routeShortName: entity.routeShortName,
      routeLongName: entity.routeLongName,
      routeColor: entity.routeColor,
      tripId: entity.tripId,
      tripHeadsign: entity.tripHeadsign,
      arrivalTime: entity.arrivalTime,
      departureTime: entity.departureTime,
      stopSequence: entity.stopSequence,
      directionId: entity.directionId,
      wheelchairAccessible: entity.wheelchairAccessible,
      bikesAllowed: entity.bikesAllowed,
      serviceId: entity.serviceId,
    );
  }
}
