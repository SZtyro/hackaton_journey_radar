import 'package:equatable/equatable.dart';

class GtfsAgencyEntity extends Equatable {
  final String agencyId;
  final String agencyName;
  final String agencyUrl;
  final String agencyTimezone;
  final String? agencyLang;
  final String? agencyPhone;
  final String? agencyFareUrl;

  const GtfsAgencyEntity({
    required this.agencyId,
    required this.agencyName,
    required this.agencyUrl,
    required this.agencyTimezone,
    this.agencyLang,
    this.agencyPhone,
    this.agencyFareUrl,
  });

  GtfsAgencyEntity copyWith({
    String? agencyId,
    String? agencyName,
    String? agencyUrl,
    String? agencyTimezone,
    String? agencyLang,
    String? agencyPhone,
    String? agencyFareUrl,
  }) {
    return GtfsAgencyEntity(
      agencyId: agencyId ?? this.agencyId,
      agencyName: agencyName ?? this.agencyName,
      agencyUrl: agencyUrl ?? this.agencyUrl,
      agencyTimezone: agencyTimezone ?? this.agencyTimezone,
      agencyLang: agencyLang ?? this.agencyLang,
      agencyPhone: agencyPhone ?? this.agencyPhone,
      agencyFareUrl: agencyFareUrl ?? this.agencyFareUrl,
    );
  }

  @override
  List<Object?> get props => [
        agencyId,
        agencyName,
        agencyUrl,
        agencyTimezone,
        agencyLang,
        agencyPhone,
        agencyFareUrl,
      ];
}
