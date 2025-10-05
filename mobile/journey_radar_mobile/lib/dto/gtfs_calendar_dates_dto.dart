import 'package:journey_radar_mobile/entity/entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gtfs_calendar_dates_dto.g.dart';

@JsonSerializable()
class GtfsCalendarDatesDto {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'service_id')
  final String serviceId;

  @JsonKey(name: 'date')
  final String date;

  @JsonKey(name: 'exception_type')
  final int exceptionType;

  const GtfsCalendarDatesDto({
    required this.id,
    required this.serviceId,
    required this.date,
    required this.exceptionType,
  });

  factory GtfsCalendarDatesDto.fromJson(Map<String, dynamic> json) =>
      _$GtfsCalendarDatesDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GtfsCalendarDatesDtoToJson(this);

  GtfsCalendarDatesEntity toEntity() {
    return GtfsCalendarDatesEntity(
      id: id,
      serviceId: serviceId,
      date: date,
      exceptionType: exceptionType,
    );
  }

  factory GtfsCalendarDatesDto.fromEntity(GtfsCalendarDatesEntity entity) {
    return GtfsCalendarDatesDto(
      id: entity.id,
      serviceId: entity.serviceId,
      date: entity.date,
      exceptionType: entity.exceptionType,
    );
  }
}
