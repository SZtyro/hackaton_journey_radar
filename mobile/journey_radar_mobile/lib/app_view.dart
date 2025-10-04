// ignore_for_file: lines_longer_than_80_chars, cascade_invocations

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journey_radar_mobile/app_ui/app_spacing.dart';
import 'package:journey_radar_mobile/config/service_locator.dart';
import 'package:journey_radar_mobile/theme/theme_cubit.dart';
import 'package:sizer/sizer.dart';

import 'routes/app_router.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter().router();

    return BlocProvider.value(
      value: getIt<ThemeCubit>(),
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              // Build light theme
              final lightColorScheme = _buildColorScheme(
                brightness: Brightness.light,
                themeState: themeState,
              );

              // Build dark theme
              final darkColorScheme = _buildColorScheme(
                brightness: Brightness.dark,
                themeState: themeState,
              );

              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                themeMode: themeState.mode,
                theme: ThemeData(
                  useMaterial3: true,
                  colorScheme: lightColorScheme,
                  appBarTheme: AppBarTheme(
                    centerTitle: true,
                    elevation: 0,
                    scrolledUnderElevation: 1,
                  ),
                  filledButtonTheme: FilledButtonThemeData(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.xs),
                      ),
                    ),
                  ),
                ),
                darkTheme: ThemeData(
                  useMaterial3: true,
                  colorScheme: darkColorScheme,
                  appBarTheme: AppBarTheme(
                    centerTitle: true,
                    elevation: 0,
                    scrolledUnderElevation: 1,
                  ),
                  filledButtonTheme: FilledButtonThemeData(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.xs),
                      ),
                    ),
                  ),
                ),
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                routerConfig: router,
              );
            },
          );
        },
      ),
    );
  }

  ColorScheme _buildColorScheme({
    required Brightness brightness,
    required ThemeState themeState,
  }) {
    // Use seed-based color scheme
    return ColorScheme.fromSeed(
      brightness: brightness,
      seedColor: themeState.seed,
    );
  }
}
