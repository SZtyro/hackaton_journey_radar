// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gtfs_route_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GtfsRouteDto _$GtfsRouteDtoFromJson(Map<String, dynamic> json) => GtfsRouteDto(
      routeId: json['route_id'] as String?,
      agencyId: json['agency_id'] as String?,
      routeShortName: json['route_short_name'] as String?,
      routeLongName: json['route_long_name'] as String?,
      routeDesc: json['route_desc'] as String?,
      routeType: (json['route_type'] as num?)?.toInt(),
      routeUrl: json['route_url'] as String?,
      routeColor: json['route_color'] as String?,
      routeTextColor: json['route_text_color'] as String?,
      routeSortOrder: (json['route_sort_order'] as num?)?.toInt(),
      continuousPickup: (json['continuous_pickup'] as num?)?.toInt(),
      continuousDropOff: (json['continuous_drop_off'] as num?)?.toInt(),
      networkId: json['network_id'] as String?,
    );

Map<String, dynamic> _$GtfsRouteDtoToJson(GtfsRouteDto instance) =>
    <String, dynamic>{
      'route_id': instance.routeId,
      'agency_id': instance.agencyId,
      'route_short_name': instance.routeShortName,
      'route_long_name': instance.routeLongName,
      'route_desc': instance.routeDesc,
      'route_type': instance.routeType,
      'route_url': instance.routeUrl,
      'route_color': instance.routeColor,
      'route_text_color': instance.routeTextColor,
      'route_sort_order': instance.routeSortOrder,
      'continuous_pickup': instance.continuousPickup,
      'continuous_drop_off': instance.continuousDropOff,
      'network_id': instance.networkId,
    };
