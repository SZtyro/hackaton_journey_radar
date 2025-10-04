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
    await getMapPoints();
    await getBusRoutes();
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

  Future<void> getMapPoints({
    int? limit,
    int? offset,
    String? iconType,
  }) async {
    if (state.getMapPointsStatus == StateStatus.loading) return;

    emit(state.copyWith(
      getMapPointsStatus: StateStatus.loading,
    ));

    try {
      final result = await mapRepository.getMapPoints(
        limit: limit,
        offset: offset,
        iconType: iconType,
      );

      switch (result) {
        case Success():
          {
            emit(state.copyWith(
              getMapPointsStatus: StateStatus.success,
              mapPoints: result.data,
            ));
          }
        case Failure(error: final exception):
          {
            emit(state.copyWith(
              getMapPointsStatus: StateStatus.failure,
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
        getMapPointsStatus: submissionStatus,
        exception: error is Exception ? error : Exception(error.toString()),
      ));
    }
  }

  Future<void> getBusRoutes({
    int? limit,
    int? offset,
  }) async {
    if (state.getBusRoutesStatus == StateStatus.loading) return;

    emit(state.copyWith(
      getBusRoutesStatus: StateStatus.loading,
    ));

    try {
      final result = await mapRepository.getBusRoutes(
        limit: limit,
        offset: offset,
      );

      switch (result) {
        case Success():
          {
            emit(state.copyWith(
              getBusRoutesStatus: StateStatus.success,
              busRoutes: result.data,
            ));
          }
        case Failure(error: final exception):
          {
            emit(state.copyWith(
              getBusRoutesStatus: StateStatus.failure,
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
        getBusRoutesStatus: submissionStatus,
        exception: error is Exception ? error : Exception(error.toString()),
      ));
    }
  }

  Future<void> searchMapPoints({
    required String query,
    int? limit,
    int? offset,
  }) async {
    if (state.searchMapPointsStatus == StateStatus.loading) return;

    emit(state.copyWith(
      searchMapPointsStatus: StateStatus.loading,
    ));

    try {
      final result = await mapRepository.searchMapPoints(
        query: query,
        limit: limit,
        offset: offset,
      );

      switch (result) {
        case Success():
          {
            emit(state.copyWith(
              searchMapPointsStatus: StateStatus.success,
              searchResults: result.data,
            ));
          }
        case Failure(error: final exception):
          {
            emit(state.copyWith(
              searchMapPointsStatus: StateStatus.failure,
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
        searchMapPointsStatus: submissionStatus,
        exception: error is Exception ? error : Exception(error.toString()),
      ));
    }
  }

  Future<void> getNearbyMapPoints({
    required LatLng position,
    required double radiusKm,
    int? limit,
    int? offset,
  }) async {
    if (state.getNearbyMapPointsStatus == StateStatus.loading) return;

    emit(state.copyWith(
      getNearbyMapPointsStatus: StateStatus.loading,
    ));

    try {
      final result = await mapRepository.getNearbyMapPoints(
        location: position,
        radius: radiusKm,
        limit: limit,
      );

      switch (result) {
        case Success():
          {
            emit(state.copyWith(
              getNearbyMapPointsStatus: StateStatus.success,
              nearbyMapPoints: result.data,
            ));
          }
        case Failure(error: final exception):
          {
            emit(state.copyWith(
              getNearbyMapPointsStatus: StateStatus.failure,
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
        getNearbyMapPointsStatus: submissionStatus,
        exception: error is Exception ? error : Exception(error.toString()),
      ));
    }
  }

  void clearSearchResults() {
    emit(state.copyWith(
      searchResults: [],
      searchMapPointsStatus: StateStatus.initial,
    ));
  }

  void clearNearbyResults() {
    emit(state.copyWith(
      nearbyMapPoints: [],
      getNearbyMapPointsStatus: StateStatus.initial,
    ));
  }

  void setSelectedMapPoint(MapPointEntity? mapPoint) {
    emit(state.copyWith(selectedMapPoint: mapPoint));
  }

  void setSelectedBusRoute(BusRouteEntity? busRoute) {
    emit(state.copyWith(selectedBusRoute: busRoute));
  }
}
