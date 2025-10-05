import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

class VehiclePositionEntity extends Equatable {
  final String? vehicleId;
  final String? tripId;
  final LatLng? position;

  const VehiclePositionEntity({
    this.vehicleId,
    this.tripId,
    this.position,
  });

  VehiclePositionEntity copyWith({
    String? vehicleId,
    String? tripId,
    LatLng? position,
  }) {
    return VehiclePositionEntity(
      vehicleId: vehicleId ?? this.vehicleId,
      tripId: tripId ?? this.tripId,
      position: position ?? this.position,
    );
  }

  @override
  List<Object?> get props => [
        vehicleId,
        tripId,
        position,
      ];
}
