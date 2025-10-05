import 'package:journey_radar_mobile/dto/report_dto.dart';
import 'package:journey_radar_mobile/entity/entity.dart';

/// Report entity representing a transit incident report
class ReportEntity {
  const ReportEntity({
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

  final int? id;
  final DateTime? createdDate;
  final int? version;
  final bool? draft;
  final ReportType type;
  final String? typeDisplayName;
  final String? description;
  final GtfsRouteEntity? route;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final bool emergency;

  /// Creates a copy of this entity with modified fields
  ReportEntity copyWith({
    int? id,
    DateTime? createdDate,
    int? version,
    bool? draft,
    ReportType? type,
    String? typeDisplayName,
    String? description,
    GtfsRouteEntity? route,
    DateTime? timestamp,
    double? latitude,
    double? longitude,
    bool? emergency,
  }) {
    return ReportEntity(
      id: id ?? this.id,
      createdDate: createdDate ?? this.createdDate,
      version: version ?? this.version,
      draft: draft ?? this.draft,
      type: type ?? this.type,
      typeDisplayName: typeDisplayName ?? this.typeDisplayName,
      description: description ?? this.description,
      route: route ?? this.route,
      timestamp: timestamp ?? this.timestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      emergency: emergency ?? this.emergency,
    );
  }
}
