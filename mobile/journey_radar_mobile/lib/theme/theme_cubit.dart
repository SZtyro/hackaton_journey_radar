import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journey_radar_mobile/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit()
      : super(const ThemeState(
          mode: ThemeMode.system,
          useDynamic: true,
          seed: AppConstants.defaultSeed,
        )) {
    load();
  }

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load theme mode
      final modeIndex = prefs.getInt(StorageKeys.themeModeKey);
      final mode =
          modeIndex != null ? ThemeMode.values[modeIndex] : ThemeMode.system;

      // Load dynamic colors setting
      final useDynamic = prefs.getBool(StorageKeys.useDynamicKey) ?? true;

      // Load seed color
      final seedString = prefs.getString(StorageKeys.seedKey);
      Color seed = AppConstants.defaultSeed;
      if (seedString != null) {
        try {
          final colorValue = int.parse(seedString);
          seed = Color(colorValue);
        } catch (e) {
          seed = AppConstants.defaultSeed;
        }
      }

      emit(ThemeState(
        mode: mode,
        useDynamic: useDynamic,
        seed: seed,
      ));
    } catch (e) {
      // If loading fails, use default values
      emit(const ThemeState(
        mode: ThemeMode.system,
        useDynamic: true,
        seed: AppConstants.defaultSeed,
      ));
    }
  }

  Future<void> setMode(ThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(StorageKeys.themeModeKey, mode.index);

      emit(state.copyWith(mode: mode));
    } catch (e) {
      // Handle error silently or log it
    }
  }

  Future<void> setUseDynamic(bool useDynamic) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(StorageKeys.useDynamicKey, useDynamic);

      emit(state.copyWith(useDynamic: useDynamic));
    } catch (e) {
      // Handle error silently or log
    }
  }

  Future<void> setSeed(Color seed) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(StorageKeys.seedKey, seed.value.toString());

      // When setting a custom seed, automatically disable dynamic colors
      emit(state.copyWith(
        seed: seed,
        useDynamic: false,
      ));

      // Also save the useDynamic change
      await prefs.setBool(StorageKeys.useDynamicKey, false);
    } catch (e) {
      // Handle error silently or log it
    }
  }
}
