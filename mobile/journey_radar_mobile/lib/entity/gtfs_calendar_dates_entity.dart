import 'package:equatable/equatable.dart';

class GtfsCalendarDatesEntity extends Equatable {
  final int id;
  final String serviceId;
  final String date;
  final int exceptionType;

  const GtfsCalendarDatesEntity({
    required this.id,
    required this.serviceId,
    required this.date,
    required this.exceptionType,
  });

  GtfsCalendarDatesEntity copyWith({
    int? id,
    String? serviceId,
    String? date,
    int? exceptionType,
  }) {
    return GtfsCalendarDatesEntity(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      date: date ?? this.date,
      exceptionType: exceptionType ?? this.exceptionType,
    );
  }

  @override
  List<Object?> get props => [
        id,
        serviceId,
        date,
        exceptionType,
      ];
}
