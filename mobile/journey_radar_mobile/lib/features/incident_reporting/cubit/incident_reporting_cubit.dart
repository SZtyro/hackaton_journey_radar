import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journey_radar_mobile/entity/entity.dart';
import 'package:journey_radar_mobile/repository/repository.dart';
import 'package:journey_radar_mobile/shared/state_status.dart';

part 'incident_reporting_state.dart';

class IncidentReportingCubit extends Cubit<IncidentReportingState> {
  final Repository repository;

  IncidentReportingCubit({
    required this.repository,
  }) : super(const IncidentReportingState());

  Future<void> initialCubitLoad() async {
    await getGtfsRoutes();
  }

  Future<void> getGtfsRoutes({
    int? limit,
    int? offset,
    String? routeType,
  }) async {
    if (state.getGtfsRoutesStatus == StateStatus.loading) return;

    emit(state.copyWith(
      getGtfsRoutesStatus: StateStatus.loading,
    ));

    try {
      final result = await repository.getGtfsRoutes(
        limit: limit,
        offset: offset,
        routeType: routeType,
      );

      switch (result) {
        case Success():
          {
            emit(state.copyWith(
              getGtfsRoutesStatus: StateStatus.success,
              gtfsRoutes: result.data,
            ));
          }
        case Failure(error: final exception):
          {
            emit(state.copyWith(
              getGtfsRoutesStatus: StateStatus.failure,
              exception: exception,
            ));
          }
      }
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      final submissionStatus = switch (error) {
        final TimeoutException _ => StateStatus.failure,
        _ => StateStatus.failure,
      };
      emit(state.copyWith(
        getGtfsRoutesStatus: submissionStatus,
        exception: error is Exception ? error : Exception(error.toString()),
      ));
    }
  }
}
