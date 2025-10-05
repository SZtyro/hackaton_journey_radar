import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

class GtfsShapeEntity extends Equatable {
  final String? shapeId;
  final LatLng? position;
  final int? sequence;
  final double? distanceTraveled;

  const GtfsShapeEntity({
    this.shapeId,
    this.position,
    this.sequence,
    this.distanceTraveled,
  });

  GtfsShapeEntity copyWith({
    String? shapeId,
    LatLng? position,
    int? sequence,
    double? distanceTraveled,
  }) {
    return GtfsShapeEntity(
      shapeId: shapeId ?? this.shapeId,
      position: position ?? this.position,
      sequence: sequence ?? this.sequence,
      distanceTraveled: distanceTraveled ?? this.distanceTraveled,
    );
  }

  @override
  List<Object?> get props => [
        shapeId,
        position,
        sequence,
        distanceTraveled,
      ];
}
