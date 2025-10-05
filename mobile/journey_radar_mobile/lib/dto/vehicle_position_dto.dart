import 'package:journey_radar_mobile/entity/entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'vehicle_position_dto.g.dart';

@JsonSerializable()
class VehiclePositionDto {
  @JsonKey(name: 'vehicleId')
  final String? vehicleId;

  @JsonKey(name: 'tripId')
  final String? tripId;

  @JsonKey(name: 'latitude')
  final double? latitude;

  @JsonKey(name: 'longitude')
  final double? longitude;

  const VehiclePositionDto({
    this.vehicleId,
    this.tripId,
    this.latitude,
    this.longitude,
  });

  factory VehiclePositionDto.fromJson(Map<String, dynamic> json) =>
      _$VehiclePositionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VehiclePositionDtoToJson(this);

  VehiclePositionEntity toEntity() {
    return VehiclePositionEntity(
      vehicleId: vehicleId,
      tripId: tripId,
      position: latitude != null && longitude != null
          ? LatLng(latitude!, longitude!)
          : null,
    );
  }

  factory VehiclePositionDto.fromEntity(VehiclePositionEntity entity) {
    return VehiclePositionDto(
      vehicleId: entity.vehicleId,
      tripId: entity.tripId,
      latitude: entity.position?.latitude,
      longitude: entity.position?.longitude,
    );
  }
}
