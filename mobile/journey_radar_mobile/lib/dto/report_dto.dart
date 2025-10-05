// ignore_for_file: public_member_api_docs

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:journey_radar_mobile/dto/dto.dart';
import 'package:journey_radar_mobile/entity/entity.dart';

part 'report_dto.g.dart';

/// Report type enum
enum ReportType {
  @JsonValue('ACCIDENT')
  accident,
  @JsonValue('LANE_CLOSURE')
  laneClosure,
  @JsonValue('VEHICLE_BREAKDOWN')
  vehicleBreakdown,
  @JsonValue('COLLISION')
  collision,
  @JsonValue('PEDESTRIAN_ACCIDENT')
  pedestrianAccident,
  @JsonValue('OTHER')
  other,
}

/// Report DTO for transit incident reports
@JsonSerializable(explicitToJson: true)
class ReportDto {
  const ReportDto({
    this.id,
    this.createdDate,
    this.version,
    this.draft,
    required this.type,
    this.typeDisplayName,
    this.description,
    this.route,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.emergency,
  });

  factory ReportDto.fromJson(Map<String, dynamic> json) =>
      _$ReportDtoFromJson(json);

  final int? id;
  final DateTime? createdDate;
  final int? version;
  final bool? draft;
  final ReportType type;
  final String? typeDisplayName;
  final String? description;
  final GtfsRouteDto? route;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final bool emergency;

  Map<String, dynamic> toJson() => _$ReportDtoToJson(this);

  /// Converts this DTO to an entity
  ReportEntity toEntity() {
    return ReportEntity(
      id: id,
      createdDate: createdDate,
      version: version,
      draft: draft,
      type: type,
      typeDisplayName: typeDisplayName,
      description: description,
      route: route?.toEntity(),
      timestamp: timestamp,
      latitude: latitude,
      longitude: longitude,
      emergency: emergency,
    );
  }

  /// Creates a DTO from an entity
  factory ReportDto.fromEntity(ReportEntity entity) {
    return ReportDto(
      id: entity.id,
      createdDate: entity.createdDate,
      version: entity.version,
      draft: entity.draft,
      type: entity.type,
      typeDisplayName: entity.typeDisplayName,
      description: entity.description,
      route:
          entity.route != null ? GtfsRouteDto.fromEntity(entity.route!) : null,
      timestamp: entity.timestamp,
      latitude: entity.latitude,
      longitude: entity.longitude,
      emergency: entity.emergency,
    );
  }
}
