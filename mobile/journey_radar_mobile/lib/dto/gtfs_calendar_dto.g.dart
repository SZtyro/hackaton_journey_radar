// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gtfs_calendar_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GtfsCalendarDto _$GtfsCalendarDtoFromJson(Map<String, dynamic> json) =>
    GtfsCalendarDto(
      serviceId: json['service_id'] as String,
      monday: (json['monday'] as num).toInt(),
      tuesday: (json['tuesday'] as num).toInt(),
      wednesday: (json['wednesday'] as num).toInt(),
      thursday: (json['thursday'] as num).toInt(),
      friday: (json['friday'] as num).toInt(),
      saturday: (json['saturday'] as num).toInt(),
      sunday: (json['sunday'] as num).toInt(),
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
    );

Map<String, dynamic> _$GtfsCalendarDtoToJson(GtfsCalendarDto instance) =>
    <String, dynamic>{
      'service_id': instance.serviceId,
      'monday': instance.monday,
      'tuesday': instance.tuesday,
      'wednesday': instance.wednesday,
      'thursday': instance.thursday,
      'friday': instance.friday,
      'saturday': instance.saturday,
      'sunday': instance.sunday,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
    };
