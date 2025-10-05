import 'package:journey_radar_mobile/entity/entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gtfs_route_dto.g.dart';

@JsonSerializable()
class GtfsRouteDto {
  @JsonKey(name: 'route_id')
  final String? routeId;

  @JsonKey(name: 'agency_id')
  final String? agencyId;

  @JsonKey(name: 'route_short_name')
  final String? routeShortName;

  @JsonKey(name: 'route_long_name')
  final String? routeLongName;

  @JsonKey(name: 'route_desc')
  final String? routeDesc;

  @JsonKey(name: 'route_type')
  final int? routeType;

  @JsonKey(name: 'route_url')
  final String? routeUrl;

  @JsonKey(name: 'route_color')
  final String? routeColor;

  @JsonKey(name: 'route_text_color')
  final String? routeTextColor;

  @JsonKey(name: 'route_sort_order')
  final int? routeSortOrder;

  @JsonKey(name: 'continuous_pickup')
  final int? continuousPickup;

  @JsonKey(name: 'continuous_drop_off')
  final int? continuousDropOff;

  @JsonKey(name: 'network_id')
  final String? networkId;

  const GtfsRouteDto({
    this.routeId,
    this.agencyId,
    this.routeShortName,
    this.routeLongName,
    this.routeDesc,
    this.routeType,
    this.routeUrl,
    this.routeColor,
    this.routeTextColor,
    this.routeSortOrder,
    this.continuousPickup,
    this.continuousDropOff,
    this.networkId,
  });

  factory GtfsRouteDto.fromJson(Map<String, dynamic> json) =>
      _$GtfsRouteDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GtfsRouteDtoToJson(this);

  GtfsRouteEntity toEntity() {
    return GtfsRouteEntity(
      routeId: routeId,
      agencyId: agencyId,
      routeShortName: routeShortName,
      routeLongName: routeLongName,
      routeDesc: routeDesc,
      routeType: routeType,
      routeUrl: routeUrl,
      routeColor: routeColor,
      routeTextColor: routeTextColor,
      routeSortOrder: routeSortOrder,
      continuousPickup: continuousPickup,
      continuousDropOff: continuousDropOff,
      networkId: networkId,
    );
  }

  factory GtfsRouteDto.fromEntity(GtfsRouteEntity entity) {
    return GtfsRouteDto(
      routeId: entity.routeId,
      agencyId: entity.agencyId,
      routeShortName: entity.routeShortName,
      routeLongName: entity.routeLongName,
      routeDesc: entity.routeDesc,
      routeType: entity.routeType,
      routeUrl: entity.routeUrl,
      routeColor: entity.routeColor,
      routeTextColor: entity.routeTextColor,
      routeSortOrder: entity.routeSortOrder,
      continuousPickup: entity.continuousPickup,
      continuousDropOff: entity.continuousDropOff,
      networkId: entity.networkId,
    );
  }
}
