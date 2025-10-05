// ignore_for_file: public_member_api_docs, avoid_redundant_argument_values, lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:journey_radar_mobile/app_ui/app_colors.dart';
import 'package:journey_radar_mobile/app_ui/app_spacing.dart';

ThemeData appTheme({bool isDarkTheme = true}) => ThemeData.from(
      colorScheme: isDarkTheme ? darkColorScheme : lightColorScheme,
    ).copyWith(
      popupMenuTheme: PopupMenuThemeData(
        elevation: AppSpacing.xs * 2.5,
        menuPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppSpacing.s,
          ),
          side: BorderSide(
            color: isDarkTheme
                ? AppColors.darkTextFieldBorder
                : AppColors.lightTextFieldBorder,
          ),
        ),
        shadowColor: AppColors.shadowColor,
      ),
    );

class AppColorScheme extends ColorScheme {
  const AppColorScheme({
    required super.brightness,
    required super.primary,
    required super.onPrimary,
    required super.onPrimaryFixed,
    required super.primaryContainer,
    required super.onPrimaryContainer,
    required super.secondary,
    required super.onSecondary,
    required super.secondaryContainer,
    required super.onSecondaryContainer,
    required super.error,
    required super.onError,
    required super.tertiary,
    required super.onTertiary,
    required super.onTertiaryFixed,
    required super.onTertiaryFixedVariant,
    required super.surface,
    required super.onSurface,
    required super.onSurfaceVariant,
    required super.onInverseSurface,
    required super.outline,
    required super.shadow,
  });
}

const darkColorScheme = AppColorScheme(
  brightness: Brightness.dark,
  //main colors, main button
  primary: AppColors.darkMainButtonFirst,
  onPrimary: AppColors.darkOnMainButton,
  onPrimaryFixed: AppColors.darkBackground,
  primaryContainer: AppColors.darkPrimaryContainer,
  onPrimaryContainer: AppColors.darkOnPrimaryContainer,
  //secondary colors, secondary button
  secondary: AppColors.darkSecondaryButtonFirst,
  onSecondary: AppColors.darkOnSecondaryButton,
  secondaryContainer: AppColors.darkSecondaryButtonSecond,
  onSecondaryContainer: AppColors.darkOnSecondaryButtonSecond,
  //snackBar colors
  error: AppColors.darkSnackBar,
  onError: AppColors.darkOnSnackBar,
  //textField colors
  tertiary: AppColors.darkTextFieldBackground,
  onTertiary: AppColors.darkOnTextField,
  onTertiaryFixed: AppColors.darkTextFieldIcon,
  onTertiaryFixedVariant: AppColors.darkTextFieldBorder,
  //background colors
  surface: AppColors.darkBackground,
  onSurface: AppColors.darkOnBackground,
  onSurfaceVariant: AppColors.darkOnBackgroundSecond,
  onInverseSurface: AppColors.darkSecondaryTextFieldBorder,
  outline: AppColors.darkTextFieldBorder,
  shadow: AppColors.shadowColor,
);

const lightColorScheme = AppColorScheme(
  brightness: Brightness.light,
  //main colors, main button
  primary: AppColors.lightMainButtonFirst,
  onPrimary: AppColors.lightOnMainButton,
  onPrimaryFixed: AppColors.lightBackground,
  primaryContainer: AppColors.lightPrimaryContainer,
  onPrimaryContainer: AppColors.lightOnPrimaryContainer,
  //secondary colors, secondary button
  secondary: AppColors.lightSecondaryButtonFirst,
  onSecondary: AppColors.lightOnSecondaryButton,
  secondaryContainer: AppColors.lightSecondaryButtonSecond,
  onSecondaryContainer: AppColors.lightOnSecondaryButtonSecond,
  //snackBar colors
  error: AppColors.lightSnackBar,
  onError: AppColors.lightOnSnackBar,
  //textField colors
  tertiary: AppColors.lightTextFieldBackground,
  onTertiary: AppColors.lightOnTextField,
  onTertiaryFixed: AppColors.lightTextFieldIcon,
  onTertiaryFixedVariant: AppColors.lightTextFieldBorder,
  //background colors
  surface: AppColors.lightBackground,
  onSurface: AppColors.lightOnBackground,
  onSurfaceVariant: AppColors.lightOnBackgroundSecond,
  onInverseSurface: AppColors.lightSecondaryTextFieldBorder,
  outline: Colors.blueGrey,
  shadow: AppColors.shadowColor,
);

/// System UI overlay themes adapted from the previous project's style.
class SystemUiOverlayTheme {
  const SystemUiOverlayTheme();

  static const SystemUiOverlayStyle iOSLightSystemBarTheme =
      SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
    statusBarColor: AppColors.lightBackground,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static const SystemUiOverlayStyle iOSDarkSystemBarTheme =
      SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarColor: AppColors.darkBackground,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
  );

  static const SystemUiOverlayStyle androidLightSystemBarTheme =
      SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarDividerColor: Colors.transparent,
  );

  static const SystemUiOverlayStyle androidDarkSystemBarTheme =
      SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarDividerColor: Colors.transparent,
  );

  /// Locks the device to portrait orientation.
  static void setPortraitOrientation() {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
      ],
    );
  }

  static BoxDecoration getDevBoxDecoration() => BoxDecoration(
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(AppSpacing.xs),
        ),
      );
}
