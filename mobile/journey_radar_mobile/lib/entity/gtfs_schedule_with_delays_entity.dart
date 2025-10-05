import 'package:equatable/equatable.dart';

class GtfsScheduleWithDelaysEntity extends Equatable {
  final String stopId;
  final String stopName;
  final String routeId;
  final String? routeShortName;
  final String? routeLongName;
  final String? routeColor;
  final String tripId;
  final String? tripHeadsign;
  final String? scheduledArrivalTime;
  final String? scheduledDepartureTime;
  final String? realTimeArrivalTime;
  final String? realTimeDepartureTime;
  final int? delaySeconds;
  final String? delayType;
  final String? delayReason;
  final int stopSequence;
  final int? directionId;
  final int? wheelchairAccessible;
  final int? bikesAllowed;
  final String serviceId;
  final bool isRealTime;

  const GtfsScheduleWithDelaysEntity({
    required this.stopId,
    required this.stopName,
    required this.routeId,
    this.routeShortName,
    this.routeLongName,
    this.routeColor,
    required this.tripId,
    this.tripHeadsign,
    this.scheduledArrivalTime,
    this.scheduledDepartureTime,
    this.realTimeArrivalTime,
    this.realTimeDepartureTime,
    this.delaySeconds,
    this.delayType,
    this.delayReason,
    required this.stopSequence,
    this.directionId,
    this.wheelchairAccessible,
    this.bikesAllowed,
    required this.serviceId,
    required this.isRealTime,
  });

  GtfsScheduleWithDelaysEntity copyWith({
    String? stopId,
    String? stopName,
    String? routeId,
    String? routeShortName,
    String? routeLongName,
    String? routeColor,
    String? tripId,
    String? tripHeadsign,
    String? scheduledArrivalTime,
    String? scheduledDepartureTime,
    String? realTimeArrivalTime,
    String? realTimeDepartureTime,
    int? delaySeconds,
    String? delayType,
    String? delayReason,
    int? stopSequence,
    int? directionId,
    int? wheelchairAccessible,
    int? bikesAllowed,
    String? serviceId,
    bool? isRealTime,
  }) {
    return GtfsScheduleWithDelaysEntity(
      stopId: stopId ?? this.stopId,
      stopName: stopName ?? this.stopName,
      routeId: routeId ?? this.routeId,
      routeShortName: routeShortName ?? this.routeShortName,
      routeLongName: routeLongName ?? this.routeLongName,
      routeColor: routeColor ?? this.routeColor,
      tripId: tripId ?? this.tripId,
      tripHeadsign: tripHeadsign ?? this.tripHeadsign,
      scheduledArrivalTime: scheduledArrivalTime ?? this.scheduledArrivalTime,
      scheduledDepartureTime:
          scheduledDepartureTime ?? this.scheduledDepartureTime,
      realTimeArrivalTime: realTimeArrivalTime ?? this.realTimeArrivalTime,
      realTimeDepartureTime:
          realTimeDepartureTime ?? this.realTimeDepartureTime,
      delaySeconds: delaySeconds ?? this.delaySeconds,
      delayType: delayType ?? this.delayType,
      delayReason: delayReason ?? this.delayReason,
      stopSequence: stopSequence ?? this.stopSequence,
      directionId: directionId ?? this.directionId,
      wheelchairAccessible: wheelchairAccessible ?? this.wheelchairAccessible,
      bikesAllowed: bikesAllowed ?? this.bikesAllowed,
      serviceId: serviceId ?? this.serviceId,
      isRealTime: isRealTime ?? this.isRealTime,
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
        scheduledArrivalTime,
        scheduledDepartureTime,
        realTimeArrivalTime,
        realTimeDepartureTime,
        delaySeconds,
        delayType,
        delayReason,
        stopSequence,
        directionId,
        wheelchairAccessible,
        bikesAllowed,
        serviceId,
        isRealTime,
      ];
}
