part of 'incident_reporting_cubit.dart';

class IncidentReportingState extends Equatable {
  final StateStatus getGtfsRoutesStatus;
  final StateStatus submitIncidentStatus;

  final List<GtfsRouteEntity>? gtfsRoutes;
  final Exception? exception;

  const IncidentReportingState({
    this.getGtfsRoutesStatus = StateStatus.initial,
    this.submitIncidentStatus = StateStatus.initial,
    this.gtfsRoutes,
    this.exception,
  });

  IncidentReportingState copyWith({
    StateStatus? getGtfsRoutesStatus,
    StateStatus? submitIncidentStatus,
    List<GtfsRouteEntity>? gtfsRoutes,
    Exception? exception,
  }) {
    return IncidentReportingState(
      getGtfsRoutesStatus: getGtfsRoutesStatus ?? this.getGtfsRoutesStatus,
      submitIncidentStatus: submitIncidentStatus ?? this.submitIncidentStatus,
      gtfsRoutes: gtfsRoutes ?? this.gtfsRoutes,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [
        getGtfsRoutesStatus,
        submitIncidentStatus,
        gtfsRoutes,
        exception,
      ];
}
