// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gtfs_stop_time_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GtfsStopTimeDto _$GtfsStopTimeDtoFromJson(Map<String, dynamic> json) =>
    GtfsStopTimeDto(
      tripId: json['trip_id'] as String,
      arrivalTime: json['arrival_time'] as String?,
      departureTime: json['departure_time'] as String?,
      stopId: json['stop_id'] as String,
      stopSequence: (json['stop_sequence'] as num).toInt(),
      stopHeadsign: json['stop_headsign'] as String?,
      pickupType: (json['pickup_type'] as num?)?.toInt(),
      dropOffType: (json['drop_off_type'] as num?)?.toInt(),
      continuousPickup: (json['continuous_pickup'] as num?)?.toInt(),
      continuousDropOff: (json['continuous_drop_off'] as num?)?.toInt(),
      shapeDistTraveled: (json['shape_dist_traveled'] as num?)?.toDouble(),
      timepoint: (json['timepoint'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GtfsStopTimeDtoToJson(GtfsStopTimeDto instance) =>
    <String, dynamic>{
      'trip_id': instance.tripId,
      'arrival_time': instance.arrivalTime,
      'departure_time': instance.departureTime,
      'stop_id': instance.stopId,
      'stop_sequence': instance.stopSequence,
      'stop_headsign': instance.stopHeadsign,
      'pickup_type': instance.pickupType,
      'drop_off_type': instance.dropOffType,
      'continuous_pickup': instance.continuousPickup,
      'continuous_drop_off': instance.continuousDropOff,
      'shape_dist_traveled': instance.shapeDistTraveled,
      'timepoint': instance.timepoint,
    };
