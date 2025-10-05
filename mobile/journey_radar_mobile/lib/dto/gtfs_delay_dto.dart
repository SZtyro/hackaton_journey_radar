import 'package:journey_radar_mobile/entity/entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gtfs_delay_dto.g.dart';

@JsonSerializable()
class GtfsDelayDto {
  @JsonKey(name: 'trip_id')
  final String tripId;

  @JsonKey(name: 'stop_id')
  final String stopId;

  @JsonKey(name: 'delay_seconds')
  final int delaySeconds;

  @JsonKey(name: 'delay_type')
  final String delayType; // 'arrival' or 'departure'

  @JsonKey(name: 'reason')
  final String? reason;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  const GtfsDelayDto({
    required this.tripId,
    required this.stopId,
    required this.delaySeconds,
    required this.delayType,
    this.reason,
    required this.createdAt,
    this.updatedAt,
  });

  factory GtfsDelayDto.fromJson(Map<String, dynamic> json) =>
      _$GtfsDelayDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GtfsDelayDtoToJson(this);

  GtfsDelayEntity toEntity() {
    return GtfsDelayEntity(
      tripId: tripId,
      stopId: stopId,
      delaySeconds: delaySeconds,
      delayType: delayType,
      reason: reason,
      createdAt: DateTime.parse(createdAt),
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }

  factory GtfsDelayDto.fromEntity(GtfsDelayEntity entity) {
    return GtfsDelayDto(
      tripId: entity.tripId,
      stopId: entity.stopId,
      delaySeconds: entity.delaySeconds,
      delayType: entity.delayType,
      reason: entity.reason,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt?.toIso8601String(),
    );
  }
}
