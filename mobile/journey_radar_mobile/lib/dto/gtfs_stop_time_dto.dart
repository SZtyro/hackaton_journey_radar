import 'package:journey_radar_mobile/entity/entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gtfs_stop_time_dto.g.dart';

@JsonSerializable()
class GtfsStopTimeDto {
  @JsonKey(name: 'trip_id')
  final String tripId;

  @JsonKey(name: 'arrival_time')
  final String? arrivalTime;

  @JsonKey(name: 'departure_time')
  final String? departureTime;

  @JsonKey(name: 'stop_id')
  final String stopId;

  @JsonKey(name: 'stop_sequence')
  final int stopSequence;

  @JsonKey(name: 'stop_headsign')
  final String? stopHeadsign;

  @JsonKey(name: 'pickup_type')
  final int? pickupType;

  @JsonKey(name: 'drop_off_type')
  final int? dropOffType;

  @JsonKey(name: 'continuous_pickup')
  final int? continuousPickup;

  @JsonKey(name: 'continuous_drop_off')
  final int? continuousDropOff;

  @JsonKey(name: 'shape_dist_traveled')
  final double? shapeDistTraveled;

  @JsonKey(name: 'timepoint')
  final int? timepoint;

  const GtfsStopTimeDto({
    required this.tripId,
    this.arrivalTime,
    this.departureTime,
    required this.stopId,
    required this.stopSequence,
    this.stopHeadsign,
    this.pickupType,
    this.dropOffType,
    this.continuousPickup,
    this.continuousDropOff,
    this.shapeDistTraveled,
    this.timepoint,
  });

  factory GtfsStopTimeDto.fromJson(Map<String, dynamic> json) =>
      _$GtfsStopTimeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GtfsStopTimeDtoToJson(this);

  GtfsStopTimeEntity toEntity() {
    return GtfsStopTimeEntity(
      tripId: tripId,
      arrivalTime: arrivalTime,
      departureTime: departureTime,
      stopId: stopId,
      stopSequence: stopSequence,
      stopHeadsign: stopHeadsign,
      pickupType: pickupType,
      dropOffType: dropOffType,
      continuousPickup: continuousPickup,
      continuousDropOff: continuousDropOff,
      shapeDistTraveled: shapeDistTraveled,
      timepoint: timepoint,
    );
  }

  factory GtfsStopTimeDto.fromEntity(GtfsStopTimeEntity entity) {
    return GtfsStopTimeDto(
      tripId: entity.tripId,
      arrivalTime: entity.arrivalTime,
      departureTime: entity.departureTime,
      stopId: entity.stopId,
      stopSequence: entity.stopSequence,
      stopHeadsign: entity.stopHeadsign,
      pickupType: entity.pickupType,
      dropOffType: entity.dropOffType,
      continuousPickup: entity.continuousPickup,
      continuousDropOff: entity.continuousDropOff,
      shapeDistTraveled: entity.shapeDistTraveled,
      timepoint: entity.timepoint,
    );
  }
}
