import 'package:journey_radar_mobile/entity/entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gtfs_agency_dto.g.dart';

@JsonSerializable()
class GtfsAgencyDto {
  @JsonKey(name: 'agency_id')
  final String agencyId;

  @JsonKey(name: 'agency_name')
  final String agencyName;

  @JsonKey(name: 'agency_url')
  final String agencyUrl;

  @JsonKey(name: 'agency_timezone')
  final String agencyTimezone;

  @JsonKey(name: 'agency_lang')
  final String? agencyLang;

  @JsonKey(name: 'agency_phone')
  final String? agencyPhone;

  @JsonKey(name: 'agency_fare_url')
  final String? agencyFareUrl;

  const GtfsAgencyDto({
    required this.agencyId,
    required this.agencyName,
    required this.agencyUrl,
    required this.agencyTimezone,
    this.agencyLang,
    this.agencyPhone,
    this.agencyFareUrl,
  });

  factory GtfsAgencyDto.fromJson(Map<String, dynamic> json) =>
      _$GtfsAgencyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GtfsAgencyDtoToJson(this);

  GtfsAgencyEntity toEntity() {
    return GtfsAgencyEntity(
      agencyId: agencyId,
      agencyName: agencyName,
      agencyUrl: agencyUrl,
      agencyTimezone: agencyTimezone,
      agencyLang: agencyLang,
      agencyPhone: agencyPhone,
      agencyFareUrl: agencyFareUrl,
    );
  }

  factory GtfsAgencyDto.fromEntity(GtfsAgencyEntity entity) {
    return GtfsAgencyDto(
      agencyId: entity.agencyId,
      agencyName: entity.agencyName,
      agencyUrl: entity.agencyUrl,
      agencyTimezone: entity.agencyTimezone,
      agencyLang: entity.agencyLang,
      agencyPhone: entity.agencyPhone,
      agencyFareUrl: entity.agencyFareUrl,
    );
  }
}
