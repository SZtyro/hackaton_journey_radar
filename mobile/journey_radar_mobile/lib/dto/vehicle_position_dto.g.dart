// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_position_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehiclePositionDto _$VehiclePositionDtoFromJson(Map<String, dynamic> json) =>
    VehiclePositionDto(
      vehicleId: json['vehicleId'] as String?,
      tripId: json['tripId'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$VehiclePositionDtoToJson(VehiclePositionDto instance) =>
    <String, dynamic>{
      'vehicleId': instance.vehicleId,
      'tripId': instance.tripId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
