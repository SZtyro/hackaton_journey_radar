import 'package:equatable/equatable.dart';

class GtfsScheduleEntity extends Equatable {
  final String stopId;
  final String stopName;
  final String routeId;
  final String? routeShortName;
  final String? routeLongName;
  final String? routeColor;
  final String tripId;
  final String? tripHeadsign;
  final String? arrivalTime;
  final String? departureTime;
  final int stopSequence;
  final int? directionId;
  final int? wheelchairAccessible;
  final int? bikesAllowed;
  final String serviceId;

  const GtfsScheduleEntity({
    required this.stopId,
    required this.stopName,
    required this.routeId,
    this.routeShortName,
    this.routeLongName,
    this.routeColor,
    required this.tripId,
    this.tripHeadsign,
    this.arrivalTime,
    this.departureTime,
    required this.stopSequence,
    this.directionId,
    this.wheelchairAccessible,
    this.bikesAllowed,
    required this.serviceId,
  });

  GtfsScheduleEntity copyWith({
    String? stopId,
    String? stopName,
    String? routeId,
    String? routeShortName,
    String? routeLongName,
    String? routeColor,
    String? tripId,
    String? tripHeadsign,
    String? arrivalTime,
    String? departureTime,
    int? stopSequence,
    int? directionId,
    int? wheelchairAccessible,
    int? bikesAllowed,
    String? serviceId,
  }) {
    return GtfsScheduleEntity(
      stopId: stopId ?? this.stopId,
      stopName: stopName ?? this.stopName,
      routeId: routeId ?? this.routeId,
      routeShortName: routeShortName ?? this.routeShortName,
      routeLongName: routeLongName ?? this.routeLongName,
      routeColor: routeColor ?? this.routeColor,
      tripId: tripId ?? this.tripId,
      tripHeadsign: tripHeadsign ?? this.tripHeadsign,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      departureTime: departureTime ?? this.departureTime,
      stopSequence: stopSequence ?? this.stopSequence,
      directionId: directionId ?? this.directionId,
      wheelchairAccessible: wheelchairAccessible ?? this.wheelchairAccessible,
      bikesAllowed: bikesAllowed ?? this.bikesAllowed,
      serviceId: serviceId ?? this.serviceId,
    );
  }

  @override
  List<Object?> get props => [
        stopId,
        stopName,
        routeId,
        routeShortName,
        routeLongName,
        routeColor,
        tripId,
        tripHeadsign,
        arrivalTime,
        departureTime,
        stopSequence,
        directionId,
        wheelchairAccessible,
        bikesAllowed,
        serviceId,
      ];
}
