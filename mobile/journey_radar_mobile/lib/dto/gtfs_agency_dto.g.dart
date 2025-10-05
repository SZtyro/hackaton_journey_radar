// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gtfs_agency_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GtfsAgencyDto _$GtfsAgencyDtoFromJson(Map<String, dynamic> json) =>
    GtfsAgencyDto(
      agencyId: json['agency_id'] as String,
      agencyName: json['agency_name'] as String,
      agencyUrl: json['agency_url'] as String,
      agencyTimezone: json['agency_timezone'] as String,
      agencyLang: json['agency_lang'] as String?,
      agencyPhone: json['agency_phone'] as String?,
      agencyFareUrl: json['agency_fare_url'] as String?,
    );

Map<String, dynamic> _$GtfsAgencyDtoToJson(GtfsAgencyDto instance) =>
    <String, dynamic>{
      'agency_id': instance.agencyId,
      'agency_name': instance.agencyName,
      'agency_url': instance.agencyUrl,
      'agency_timezone': instance.agencyTimezone,
      'agency_lang': instance.agencyLang,
      'agency_phone': instance.agencyPhone,
      'agency_fare_url': instance.agencyFareUrl,
    };
