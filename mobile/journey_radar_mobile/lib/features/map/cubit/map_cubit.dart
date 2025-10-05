import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:journey_radar_mobile/entity/entity.dart';
import 'package:journey_radar_mobile/repository/repository.dart';
import 'package:journey_radar_mobile/services/location_service.dart';
import 'package:journey_radar_mobile/shared/state_status.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  final Repository mapRepository;
  final LocationService locationService;

  MapCubit({
    required this.mapRepository,
    required this.locationService,
  }) : super(const MapState());

  Future<void> initialCubitLoad() async {
    await getCurrentLocation();
    await getGtfsRoutes();
    await getGtfsStops();
    await _loadGtfsShapesForAllRoutes();
  }

  Future<void> _loadGtfsShapesForAllRoutes() async {
    if (state.gtfsRoutes == null) return;

    for (final route in state.gtfsRoutes!) {
      if (route.routeId != null) {
        await getGtfsShapes(routeId: route.routeId!);
      }
    }
  }

  Future<void> getCurrentLocation() async {
    emit(state.copyWith(
      getLocationStatus: StateStatus.loading,
    ));

    try {
      final position = await locationService.getCurrentLocation();
      if (position != null) {
        emit(state.copyWith(
          getLocationStatus: StateStatus.success,
          currentLocation: LatLng(position.latitude, position.longitude),
        ));
      } else {
        emit(state.copyWith(
          getLocationStatus: StateStatus.failure,
          exception: Exception('Nie udało się pobrać lokalizacji'),
        ));
      }
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      final submissionStatus = switch (error) {
        final TimeoutException _ => StateStatus.failure,
        _ => StateStatus.failure,
      };
      emit(state.copyWith(
        getLocationStatus: submissionStatus,
        exception: error is Exception ? error : Exception(error.toString()),
      ));
    }
  }

  // GTFS operations
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
      final result = await mapRepository.getGtfsRoutes(
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

  Future<void> getGtfsStops({
    int? limit,
    int? offset,
    String? stopId,
  }) async {
    if (state.getGtfsStopsStatus == StateStatus.loading) return;

    emit(state.copyWith(
      getGtfsStopsStatus: StateStatus.loading,
    ));

    try {
      final result = await mapRepository.getGtfsStops(
        limit: limit,
        offset: offset,
        stopId: stopId,
      );

      switch (result) {
        case Success():
          {
            emit(state.copyWith(
              getGtfsStopsStatus: StateStatus.success,
              gtfsStops: result.data,
            ));
          }
        case Failure(error: final exception):
          {
            emit(state.copyWith(
              getGtfsStopsStatus: StateStatus.failure,
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
        getGtfsStopsStatus: submissionStatus,
        exception: error is Exception ? error : Exception(error.toString()),
      ));
    }
  }

  Future<void> getGtfsShapes({
    required String routeId,
  }) async {
    if (state.getGtfsShapesStatus == StateStatus.loading) return;

    emit(state.copyWith(
      getGtfsShapesStatus: StateStatus.loading,
    ));

    try {
      final result = await mapRepository.getGtfsShapes(routeId: routeId);

      switch (result) {
        case Success():
          {
            emit(state.copyWith(
              getGtfsShapesStatus: StateStatus.success,
              gtfsShapes: result.data,
            ));
          }
        case Failure(error: final exception):
          {
            emit(state.copyWith(
              getGtfsShapesStatus: StateStatus.failure,
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
        getGtfsShapesStatus: submissionStatus,
        exception: error is Exception ? error : Exception(error.toString()),
      ));
    }
  }

  Future<void> getGtfsStopsForRoute({
    required String routeId,
  }) async {
    if (state.getGtfsStopsStatus == StateStatus.loading) return;

    emit(state.copyWith(
      getGtfsStopsStatus: StateStatus.loading,
    ));

    try {
      final result = await mapRepository.getGtfsStopsForRoute(routeId: routeId);

      switch (result) {
        case Success():
          {
            emit(state.copyWith(
              getGtfsStopsStatus: StateStatus.success,
              gtfsStops: result.data,
            ));
          }
        case Failure(error: final exception):
          {
            emit(state.copyWith(
              getGtfsStopsStatus: StateStatus.failure,
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
        getGtfsStopsStatus: submissionStatus,
        exception: error is Exception ? error : Exception(error.toString()),
      ));
    }
  }

  Future<void> getGtfsScheduleForStop({
    required String stopId,
    int? limit,
  }) async {
    if (state.getGtfsScheduleStatus == StateStatus.loading) return;

    emit(state.copyWith(
      getGtfsScheduleStatus: StateStatus.loading,
    ));

    try {
      final result = await mapRepository.getGtfsScheduleForStop(
        stopId: stopId,
        limit: limit,
      );

      switch (result) {
        case Success():
          {
            emit(state.copyWith(
              getGtfsScheduleStatus: StateStatus.success,
              gtfsSchedule: result.data,
            ));
          }
        case Failure(error: final exception):
          {
            emit(state.copyWith(
              getGtfsScheduleStatus: StateStatus.failure,
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
        getGtfsScheduleStatus: submissionStatus,
        exception: error is Exception ? error : Exception(error.toString()),
      ));
    }
  }

  Future<void> getGtfsDelaysForRoute({
    required String routeId,
  }) async {
    if (state.getGtfsDelaysStatus == StateStatus.loading) return;

    emit(state.copyWith(
      getGtfsDelaysStatus: StateStatus.loading,
    ));

    try {
      final result =
          await mapRepository.getGtfsDelaysForRoute(routeId: routeId);

      switch (result) {
        case Success():
          {
            emit(state.copyWith(
              getGtfsDelaysStatus: StateStatus.success,
              gtfsDelays: result.data,
            ));
          }
        case Failure(error: final exception):
          {
            emit(state.copyWith(
              getGtfsDelaysStatus: StateStatus.failure,
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
        getGtfsDelaysStatus: submissionStatus,
        exception: error is Exception ? error : Exception(error.toString()),
      ));
    }
  }

  Future<void> getNearbyGtfsStops({
    required LatLng location,
    double? radius,
    int? limit,
  }) async {
    if (state.getGtfsStopsStatus == StateStatus.loading) return;

    emit(state.copyWith(
      getGtfsStopsStatus: StateStatus.loading,
    ));

    try {
      final result = await mapRepository.getNearbyGtfsStops(
        location: location,
        radius: radius,
        limit: limit,
      );

      switch (result) {
        case Success():
          {
            emit(state.copyWith(
              getGtfsStopsStatus: StateStatus.success,
              gtfsStops: result.data,
            ));
          }
        case Failure(error: final exception):
          {
            emit(state.copyWith(
              getGtfsStopsStatus: StateStatus.failure,
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
        getGtfsStopsStatus: submissionStatus,
        exception: error is Exception ? error : Exception(error.toString()),
      ));
    }
  }

  void setSelectedGtfsStop(GtfsStopEntity? stop) {
    emit(state.copyWith(selectedGtfsStop: stop));
  }

  void setSelectedGtfsRoute(GtfsRouteEntity? route) {
    emit(state.copyWith(selectedGtfsRoute: route));
  }
}
