import 'package:equatable/equatable.dart';

class GtfsStopTimeEntity extends Equatable {
  final String tripId;
  final String? arrivalTime;
  final String? departureTime;
  final String stopId;
  final int stopSequence;
  final String? stopHeadsign;
  final int? pickupType;
  final int? dropOffType;
  final int? continuousPickup;
  final int? continuousDropOff;
  final double? shapeDistTraveled;
  final int? timepoint;

  const GtfsStopTimeEntity({
    required this.tripId,
    this.arrivalTime,
    this.departureTime,
    required this.stopId,
    required this.stopSequence,
    this.stopHeadsign,
    this.pickupType,
    this.dropOffType,
    this.continuousPickup,
    this.continuousDropOff,
    this.shapeDistTraveled,
    this.timepoint,
  });

  GtfsStopTimeEntity copyWith({
    String? tripId,
    String? arrivalTime,
    String? departureTime,
    String? stopId,
    int? stopSequence,
    String? stopHeadsign,
    int? pickupType,
    int? dropOffType,
    int? continuousPickup,
    int? continuousDropOff,
    double? shapeDistTraveled,
    int? timepoint,
  }) {
    return GtfsStopTimeEntity(
      tripId: tripId ?? this.tripId,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      departureTime: departureTime ?? this.departureTime,
      stopId: stopId ?? this.stopId,
      stopSequence: stopSequence ?? this.stopSequence,
      stopHeadsign: stopHeadsign ?? this.stopHeadsign,
      pickupType: pickupType ?? this.pickupType,
      dropOffType: dropOffType ?? this.dropOffType,
      continuousPickup: continuousPickup ?? this.continuousPickup,
      continuousDropOff: continuousDropOff ?? this.continuousDropOff,
      shapeDistTraveled: shapeDistTraveled ?? this.shapeDistTraveled,
      timepoint: timepoint ?? this.timepoint,
    );
  }

  @override
  List<Object?> get props => [
        tripId,
        arrivalTime,
        departureTime,
        stopId,
        stopSequence,
        stopHeadsign,
        pickupType,
        dropOffType,
        continuousPickup,
        continuousDropOff,
        shapeDistTraveled,
        timepoint,
      ];
}
