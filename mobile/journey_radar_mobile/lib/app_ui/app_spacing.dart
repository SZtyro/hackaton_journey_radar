import 'package:sizer/sizer.dart';

/// A utility class that provides standardized spacing values
/// based on the device's screen height using the `sizer` package.
abstract class AppSpacing {
  /// The default unit of spacing.
  static const double spaceUnit = 16;

  /// Base unit derived from 1% of the screen height.
  static double unit = 1.h;

  /// Base unit derived from 1% of the screen height.
  static double bottomButtonPadding = xl + ms * 2 + xl;

  /// Extra-extra-extra-extra-extra-extra-large spacing (10 * unit).
  /// On a device with 800px height: 80.0 pixels.
  static double xxxxxxl = 10 * unit;

  /// Extra-extra-extra-extra-extra-large spacing (9 * unit).
  /// On a device with 800px height: 72.0 pixels.
  static double xxxxxl = 9 * unit;

  /// Extra-extra-extra-extra-large spacing (8 * unit).
  /// On a device with 800px height: 64.0 pixels.
  static double xxxxl = 8 * unit;

  /// Extra-extra-extra-large spacing (7 * unit).
  /// On a device with 800px height: 56.0 pixels.
  static double xxxl = 7 * unit;

  /// Extra-extra-large spacing (6 * unit).
  /// On a device with 800px height: 48.0 pixels.
  static double xxl = 6 * unit;

  /// Extra-large spacing (5 * unit).
  /// On a device with 800px height: 40.0 pixels.
  static double xl = 5 * unit;

  /// Large spacing (4 * unit).
  /// On a device with 800px height: 32.0 pixels.
  static double l = 4 * unit;

  /// Medium-large spacing (3 * unit).
  /// On a device with 800px height: 24.0 pixels.
  static double ml = 3 * unit;

  /// Medium spacing (2 * unit).
  /// On a device with 800px height: 16.0 pixels.
  static double m = 2 * unit;

  /// Medium-small spacing (1.5 * unit).
  /// On a device with 800px height: 12.0 pixels.
  static double ms = 1.5 * unit;

  /// Small spacing (1 * unit).
  /// On a device with 800px height: 8.0 pixels.
  static double s = 1 * unit;

  /// Extra-small spacing (0.5 * unit).
  /// On a device with 800px height: 4.0 pixels.
  static double xs = 0.5 * unit;

  /// Extra-extra-small spacing (0.25 * unit).
  /// On a device with 800px height: 2.0 pixels.
  static double xxs = 0.25 * unit;
}
