import 'package:equatable/equatable.dart';

class GtfsRouteEntity extends Equatable {
  final String routeId;
  final String? agencyId;
  final String? routeShortName;
  final String? routeLongName;
  final String? routeDesc;
  final int routeType;
  final String? routeUrl;
  final String? routeColor;
  final String? routeTextColor;
  final int? routeSortOrder;
  final int? continuousPickup;
  final int? continuousDropOff;
  final String? networkId;

  const GtfsRouteEntity({
    required this.routeId,
    this.agencyId,
    this.routeShortName,
    this.routeLongName,
    this.routeDesc,
    required this.routeType,
    this.routeUrl,
    this.routeColor,
    this.routeTextColor,
    this.routeSortOrder,
    this.continuousPickup,
    this.continuousDropOff,
    this.networkId,
  });

  GtfsRouteEntity copyWith({
    String? routeId,
    String? agencyId,
    String? routeShortName,
    String? routeLongName,
    String? routeDesc,
    int? routeType,
    String? routeUrl,
    String? routeColor,
    String? routeTextColor,
    int? routeSortOrder,
    int? continuousPickup,
    int? continuousDropOff,
    String? networkId,
  }) {
    return GtfsRouteEntity(
      routeId: routeId ?? this.routeId,
      agencyId: agencyId ?? this.agencyId,
      routeShortName: routeShortName ?? this.routeShortName,
      routeLongName: routeLongName ?? this.routeLongName,
      routeDesc: routeDesc ?? this.routeDesc,
      routeType: routeType ?? this.routeType,
      routeUrl: routeUrl ?? this.routeUrl,
      routeColor: routeColor ?? this.routeColor,
      routeTextColor: routeTextColor ?? this.routeTextColor,
      routeSortOrder: routeSortOrder ?? this.routeSortOrder,
      continuousPickup: continuousPickup ?? this.continuousPickup,
      continuousDropOff: continuousDropOff ?? this.continuousDropOff,
      networkId: networkId ?? this.networkId,
    );
  }

  @override
  List<Object?> get props => [
        routeId,
        agencyId,
        routeShortName,
        routeLongName,
        routeDesc,
        routeType,
        routeUrl,
        routeColor,
        routeTextColor,
        routeSortOrder,
        continuousPickup,
        continuousDropOff,
        networkId,
      ];
}
