import 'package:journey_radar_mobile/entity/entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gtfs_calendar_dto.g.dart';

@JsonSerializable()
class GtfsCalendarDto {
  @JsonKey(name: 'service_id')
  final String serviceId;

  @JsonKey(name: 'monday')
  final int monday;

  @JsonKey(name: 'tuesday')
  final int tuesday;

  @JsonKey(name: 'wednesday')
  final int wednesday;

  @JsonKey(name: 'thursday')
  final int thursday;

  @JsonKey(name: 'friday')
  final int friday;

  @JsonKey(name: 'saturday')
  final int saturday;

  @JsonKey(name: 'sunday')
  final int sunday;

  @JsonKey(name: 'start_date')
  final DateTime startDate;

  @JsonKey(name: 'end_date')
  final DateTime endDate;

  const GtfsCalendarDto({
    required this.serviceId,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
    required this.startDate,
    required this.endDate,
  });

  factory GtfsCalendarDto.fromJson(Map<String, dynamic> json) =>
      _$GtfsCalendarDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GtfsCalendarDtoToJson(this);

  GtfsCalendarEntity toEntity() {
    return GtfsCalendarEntity(
      serviceId: serviceId,
      monday: monday,
      tuesday: tuesday,
      wednesday: wednesday,
      thursday: thursday,
      friday: friday,
      saturday: saturday,
      sunday: sunday,
      startDate: startDate,
      endDate: endDate,
    );
  }

  factory GtfsCalendarDto.fromEntity(GtfsCalendarEntity entity) {
    return GtfsCalendarDto(
      serviceId: entity.serviceId,
      monday: entity.monday,
      tuesday: entity.tuesday,
      wednesday: entity.wednesday,
      thursday: entity.thursday,
      friday: entity.friday,
      saturday: entity.saturday,
      sunday: entity.sunday,
      startDate: entity.startDate,
      endDate: entity.endDate,
    );
  }
}
