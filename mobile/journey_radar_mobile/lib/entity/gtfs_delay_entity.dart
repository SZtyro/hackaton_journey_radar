import 'package:equatable/equatable.dart';

class GtfsDelayEntity extends Equatable {
  final String? tripId;
  final String? stopId;
  final int? delaySeconds;
  final String? delayType; // 'arrival' or 'departure'
  final String? reason;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const GtfsDelayEntity({
    this.tripId,
    this.stopId,
    this.delaySeconds,
    this.delayType,
    this.reason,
    this.createdAt,
    this.updatedAt,
  });

  GtfsDelayEntity copyWith({
    String? tripId,
    String? stopId,
    int? delaySeconds,
    String? delayType,
    String? reason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GtfsDelayEntity(
      tripId: tripId ?? this.tripId,
      stopId: stopId ?? this.stopId,
      delaySeconds: delaySeconds ?? this.delaySeconds,
      delayType: delayType ?? this.delayType,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        tripId,
        stopId,
        delaySeconds,
        delayType,
        reason,
        createdAt,
        updatedAt,
      ];
}
