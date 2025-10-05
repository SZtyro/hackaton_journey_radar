import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

class GtfsStopEntity extends Equatable {
  final String stopId;
  final String? stopCode;
  final String stopName;
  final String? stopDesc;
  final LatLng position;
  final String? zoneId;
  final String? stopUrl;
  final int? locationType;
  final String? parentStation;
  final String? stopTimezone;
  final int? wheelchairBoarding;
  final String? levelId;
  final String? platformCode;

  const GtfsStopEntity({
    required this.stopId,
    this.stopCode,
    required this.stopName,
    this.stopDesc,
    required this.position,
    this.zoneId,
    this.stopUrl,
    this.locationType,
    this.parentStation,
    this.stopTimezone,
    this.wheelchairBoarding,
    this.levelId,
    this.platformCode,
  });

  GtfsStopEntity copyWith({
    String? stopId,
    String? stopCode,
    String? stopName,
    String? stopDesc,
    LatLng? position,
    String? zoneId,
    String? stopUrl,
    int? locationType,
    String? parentStation,
    String? stopTimezone,
    int? wheelchairBoarding,
    String? levelId,
    String? platformCode,
  }) {
    return GtfsStopEntity(
      stopId: stopId ?? this.stopId,
      stopCode: stopCode ?? this.stopCode,
      stopName: stopName ?? this.stopName,
      stopDesc: stopDesc ?? this.stopDesc,
      position: position ?? this.position,
      zoneId: zoneId ?? this.zoneId,
      stopUrl: stopUrl ?? this.stopUrl,
      locationType: locationType ?? this.locationType,
      parentStation: parentStation ?? this.parentStation,
      stopTimezone: stopTimezone ?? this.stopTimezone,
      wheelchairBoarding: wheelchairBoarding ?? this.wheelchairBoarding,
      levelId: levelId ?? this.levelId,
      platformCode: platformCode ?? this.platformCode,
    );
  }

  @override
  List<Object?> get props => [
        stopId,
        stopCode,
        stopName,
        stopDesc,
        position,
        zoneId,
        stopUrl,
        locationType,
        parentStation,
        stopTimezone,
        wheelchairBoarding,
        levelId,
        platformCode,
      ];
}
