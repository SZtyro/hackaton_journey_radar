import 'package:equatable/equatable.dart';

class GtfsTripEntity extends Equatable {
  final String routeId;
  final String serviceId;
  final String tripId;
  final String? tripHeadsign;
  final String? tripShortName;
  final int? directionId;
  final String? blockId;
  final String? shapeId;
  final int? wheelchairAccessible;
  final int? bikesAllowed;
  final int? tripRouteType;
  final String? tripPatternId;

  const GtfsTripEntity({
    required this.routeId,
    required this.serviceId,
    required this.tripId,
    this.tripHeadsign,
    this.tripShortName,
    this.directionId,
    this.blockId,
    this.shapeId,
    this.wheelchairAccessible,
    this.bikesAllowed,
    this.tripRouteType,
    this.tripPatternId,
  });

  GtfsTripEntity copyWith({
    String? routeId,
    String? serviceId,
    String? tripId,
    String? tripHeadsign,
    String? tripShortName,
    int? directionId,
    String? blockId,
    String? shapeId,
    int? wheelchairAccessible,
    int? bikesAllowed,
    int? tripRouteType,
    String? tripPatternId,
  }) {
    return GtfsTripEntity(
      routeId: routeId ?? this.routeId,
      serviceId: serviceId ?? this.serviceId,
      tripId: tripId ?? this.tripId,
      tripHeadsign: tripHeadsign ?? this.tripHeadsign,
      tripShortName: tripShortName ?? this.tripShortName,
      directionId: directionId ?? this.directionId,
      blockId: blockId ?? this.blockId,
      shapeId: shapeId ?? this.shapeId,
      wheelchairAccessible: wheelchairAccessible ?? this.wheelchairAccessible,
      bikesAllowed: bikesAllowed ?? this.bikesAllowed,
      tripRouteType: tripRouteType ?? this.tripRouteType,
      tripPatternId: tripPatternId ?? this.tripPatternId,
    );
  }

  @override
  List<Object?> get props => [
        routeId,
        serviceId,
        tripId,
        tripHeadsign,
        tripShortName,
        directionId,
        blockId,
        shapeId,
        wheelchairAccessible,
        bikesAllowed,
        tripRouteType,
        tripPatternId,
      ];
}
