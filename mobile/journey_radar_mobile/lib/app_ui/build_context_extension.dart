import 'package:flutter/material.dart';
import 'package:journey_radar_mobile/app_ui/app_spacing.dart';
import 'package:journey_radar_mobile/app_ui/font_constants.dart';
import 'package:journey_radar_mobile/app_ui/text_style_extension.dart';

/// Provides values of current device screen and other properties by provided
/// context.
extension BuildContextX on BuildContext {
  /// Defines current theme [Brightness].
  Brightness get brightness => theme.brightness;

  /// Whether current theme [Brightness] is light.
  bool get isLight => brightness == Brightness.light;

  /// Whether current theme [Brightness] is dark.
  bool get isDark => !isLight;

  /// Defines current theme [ColorScheme].
  ColorScheme get colorScheme => theme.colorScheme;

  /// Defines an adaptive [Color], depending on current theme brightness.
  Color get adaptiveColor =>
      isDark ? colorScheme.onSurface : colorScheme.onSurface;

  /// Defines a reversed adaptive [Color], depending on current theme
  /// brightness.
  Color get reversedAdaptiveColor =>
      isDark ? colorScheme.surface : colorScheme.surface;

  /// Defines a customizable adaptive [Color]. If [light] or [dark] is not
  /// provided default colors are used.
  Color customAdaptiveColor({Color? light, Color? dark}) => isDark
      ? (light ?? colorScheme.onSurface)
      : (dark ?? colorScheme.onSurface);

  /// Defines a customizable reversed adaptive [Color]. If [light] or [dark]
  /// is not provided default reversed colors are used.
  Color customReversedAdaptiveColor({Color? light, Color? dark}) =>
      isDark ? (dark ?? colorScheme.surface) : (light ?? colorScheme.surface);

  /// Defines [MediaQueryData] based on provided context.
  Size get size => MediaQuery.sizeOf(this);

  /// Defines view insets from [MediaQuery] with current [BuildContext].
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  /// Defines view padding of from [MediaQuery] with current [BuildContext].
  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);

  /// Defines value of device current width based on [size].
  double get screenWidth => size.width;

  /// Defines value of device current height based on [size].
  double get screenHeight => size.height;

  /// Defines value of current device pixel ratio.
  double get devicePixelRatio => MediaQuery.devicePixelRatioOf(this);

  /// Whether the current device is an `Android`.
  bool get isAndroid => theme.platform == TargetPlatform.android;

  /// Whether the current device is an `iOS`.
  bool get isIOS => !isAndroid;

  /// Whether the current device is a `mobile`.
  bool get isMobile => isAndroid || isIOS;

  /// Show a SnackBar
  void showSnackBar(
    String text, {
    bool dismissible = true,
    Color? color,
    Duration duration = const Duration(seconds: 4),
    SnackBarBehavior? behavior,
    SnackBarAction? snackBarAction,
    String? solution,
    DismissDirection dismissDirection = DismissDirection.down,
  }) =>
      ScaffoldMessenger.of(this)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(
              text,
              style: TextStyle(
                fontSize: FontConstants.fontSizeS,
                color: color != null
                    ? (color.computeLuminance() > 0.5
                        ? Colors.black
                        : Colors.white)
                    : null,
              ),
            ),
            action: snackBarAction,
            behavior: behavior,
            backgroundColor: color ?? colorScheme.surface,
            dismissDirection: dismissDirection,
            duration: duration,
            elevation: AppSpacing.xxxxxl * 1.25,
          ),
        );

  /// Close all current SnackBars
  void closeSnackBars() {
    ScaffoldMessenger.of(this).clearSnackBars();
  }
}
