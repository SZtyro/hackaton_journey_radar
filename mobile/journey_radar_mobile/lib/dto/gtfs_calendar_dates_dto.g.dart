// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gtfs_calendar_dates_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GtfsCalendarDatesDto _$GtfsCalendarDatesDtoFromJson(
        Map<String, dynamic> json) =>
    GtfsCalendarDatesDto(
      id: (json['id'] as num).toInt(),
      serviceId: json['service_id'] as String,
      date: json['date'] as String,
      exceptionType: (json['exception_type'] as num).toInt(),
    );

Map<String, dynamic> _$GtfsCalendarDatesDtoToJson(
        GtfsCalendarDatesDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'service_id': instance.serviceId,
      'date': instance.date,
      'exception_type': instance.exceptionType,
    };
