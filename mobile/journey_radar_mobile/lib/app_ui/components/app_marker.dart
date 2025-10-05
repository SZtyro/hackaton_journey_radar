import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:journey_radar_mobile/app_ui/app_ui.dart';
import 'package:journey_radar_mobile/config/constants.dart';
import 'package:latlong2/latlong.dart';

class AppMarker extends StatelessWidget {
  const AppMarker({
    super.key,
    required this.point,
    required this.onTap,
    this.icon,
    this.iconData,
    this.color,
    this.backgroundColor,
    this.borderColor,
    this.size = MarkerSize.extraSmall,
    this.isSelected = false,
    this.isAnimated = true,
    this.elevation = MarkerConstants.defaultElevation,
    this.borderWidth = MarkerConstants.defaultBorderWidth,
    this.shadowBlur = MarkerConstants.defaultShadowBlur,
    this.shadowSpread = MarkerConstants.defaultShadowSpread,
    this.animationDuration = MarkerConstants.defaultAnimationDuration,
  });

  final LatLng point;
  final VoidCallback onTap;
  final Widget? icon;
  final IconData? iconData;
  final Color? color;
  final Color? backgroundColor;
  final Color? borderColor;
  final MarkerSize size;
  final bool isSelected;
  final bool isAnimated;
  final double elevation;
  final double borderWidth;
  final double shadowBlur;
  final double shadowSpread;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Kolory domyślne zgodne z Material Design 3
    final defaultColor = color ?? colorScheme.primary;
    final defaultBackgroundColor = backgroundColor ?? defaultColor;
    final defaultBorderColor = borderColor ?? colorScheme.surface;

    // Rozmiary markerów zgodne z Material Design 3 expressive
    final markerSize = _getMarkerSize(size);
    final iconSize = _getIconSize(size);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: isAnimated ? animationDuration : Duration.zero,
        width: markerSize,
        height: markerSize,
        decoration: BoxDecoration(
          color: defaultBackgroundColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: defaultBorderColor,
            width: borderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: defaultBackgroundColor
                  .withOpacity(MarkerConstants.shadowOpacity),
              blurRadius: shadowBlur,
              spreadRadius: shadowSpread,
              offset: Offset(0, elevation / 2),
            ),
          ],
        ),
        child: _buildIcon(iconSize, defaultColor),
      ),
    );
  }

  Widget _buildIcon(double iconSize, Color iconColor) {
    if (icon != null) {
      return SizedBox(
        width: iconSize,
        height: iconSize,
        child: icon,
      );
    }

    if (iconData != null) {
      return Icon(
        iconData,
        color: iconColor,
        size: iconSize,
      );
    }

    // Domyślna ikona
    return Icon(
      Icons.place,
      color: iconColor,
      size: iconSize,
    );
  }

  double _getMarkerSize(MarkerSize size) {
    switch (size) {
      case MarkerSize.extraSmall:
        return AppSpacing.l; // 32px
      case MarkerSize.small:
        return AppSpacing.xl; // 40px
      case MarkerSize.medium:
        return AppSpacing.xxl; // 48px
      case MarkerSize.large:
        return AppSpacing.xxxl; // 56px
      case MarkerSize.extraLarge:
        return AppSpacing.xxxxl; // 64px
    }
  }

  double _getIconSize(MarkerSize size) {
    switch (size) {
      case MarkerSize.extraSmall:
        return AppSpacing.s; // 8px
      case MarkerSize.small:
        return AppSpacing.ms; // 12px
      case MarkerSize.medium:
        return AppSpacing.m; // 16px
      case MarkerSize.large:
        return AppSpacing.ml; // 24px
      case MarkerSize.extraLarge:
        return AppSpacing.l; // 32px
    }
  }
}

/// Rozmiary markerów zgodne z Material Design 3
enum MarkerSize {
  extraSmall,
  small,
  medium,
  large,
  extraLarge,
}

/// Helper do tworzenia Marker z ExpressiveMarker
class ExpressiveMarkerHelper {
  static Marker createMarker({
    required LatLng point,
    required VoidCallback onTap,
    Widget? icon,
    IconData? iconData,
    Color? color,
    Color? backgroundColor,
    Color? borderColor,
    MarkerSize size = MarkerSize.medium,
    bool isSelected = false,
    bool isAnimated = true,
    double elevation = MarkerConstants.defaultElevation,
    double borderWidth = MarkerConstants.defaultBorderWidth,
    double shadowBlur = MarkerConstants.defaultShadowBlur,
    double shadowSpread = MarkerConstants.defaultShadowSpread,
    Duration animationDuration = MarkerConstants.defaultAnimationDuration,
  }) {
    final markerSize = _getMarkerSize(size);

    return Marker(
      point: point,
      width: markerSize,
      height: markerSize,
      child: AppMarker(
        point: point,
        onTap: onTap,
        icon: icon,
        iconData: iconData,
        color: color,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        size: size,
        isSelected: isSelected,
        isAnimated: isAnimated,
        elevation: elevation,
        borderWidth: borderWidth,
        shadowBlur: shadowBlur,
        shadowSpread: shadowSpread,
        animationDuration: animationDuration,
      ),
    );
  }

  static double _getMarkerSize(MarkerSize size) {
    switch (size) {
      case MarkerSize.extraSmall:
        return AppSpacing.l; // 32px
      case MarkerSize.small:
        return AppSpacing.xl; // 40px
      case MarkerSize.medium:
        return AppSpacing.xxl; // 48px
      case MarkerSize.large:
        return AppSpacing.xxxl; // 56px
      case MarkerSize.extraLarge:
        return AppSpacing.xxxxl; // 64px
    }
  }
}

/// Extension dla klasy Marker z predefiniowanymi stylami
class AppMarkerHelper {
  static Marker userLocation({
    required LatLng point,
    required VoidCallback onTap,
    Color? color,
    MarkerSize size = MarkerSize.medium,
  }) {
    final markerSize = ExpressiveMarkerHelper._getMarkerSize(size);

    return Marker(
      point: point,
      width: markerSize,
      height: markerSize,
      child: AppMarker(
        point: point,
        onTap: onTap,
        iconData: Icons.person,
        color: MarkerConstants.defaultIconColor,
        backgroundColor: color ?? MarkerConstants.defaultUserLocationColor,
        borderColor: MarkerConstants.defaultBorderColor,
        size: size,
        elevation: MarkerConstants.userLocationElevation,
        shadowBlur: MarkerConstants.userLocationShadowBlur,
        shadowSpread: MarkerConstants.userLocationShadowSpread,
      ),
    );
  }

  static Marker mapPoint({
    required LatLng point,
    required VoidCallback onTap,
    required IconData iconData,
    Color? color,
    Color? backgroundColor,
    MarkerSize size = MarkerSize.medium,
    bool isSelected = false,
  }) {
    final markerSize = ExpressiveMarkerHelper._getMarkerSize(size);

    return Marker(
      point: point,
      width: markerSize,
      height: markerSize,
      child: AppMarker(
        point: point,
        onTap: onTap,
        iconData: iconData,
        color: MarkerConstants.defaultIconColor,
        backgroundColor:
            backgroundColor ?? color ?? MarkerConstants.defaultMapPointColor,
        borderColor: MarkerConstants.defaultBorderColor,
        size: size,
        isSelected: isSelected,
        elevation: isSelected
            ? MarkerConstants.selectedElevation
            : MarkerConstants.defaultElevation,
        shadowBlur: isSelected
            ? MarkerConstants.selectedShadowBlur
            : MarkerConstants.defaultShadowBlur,
        shadowSpread: isSelected
            ? MarkerConstants.selectedShadowSpread
            : MarkerConstants.defaultShadowSpread,
      ),
    );
  }

  static Marker busStop({
    required LatLng point,
    required VoidCallback onTap,
    MarkerSize size = MarkerSize.medium,
    bool isSelected = false,
  }) {
    final markerSize = ExpressiveMarkerHelper._getMarkerSize(size);

    return Marker(
      point: point,
      width: markerSize,
      height: markerSize,
      child: AppMarker(
        point: point,
        onTap: onTap,
        iconData: Icons.directions_bus,
        color: MarkerConstants.defaultIconColor,
        backgroundColor: MarkerConstants.defaultBusStopColor,
        borderColor: MarkerConstants.defaultBorderColor,
        size: size,
        isSelected: isSelected,
        elevation: isSelected
            ? MarkerConstants.selectedElevation
            : MarkerConstants.defaultElevation,
      ),
    );
  }

  static Marker landmark({
    required LatLng point,
    required VoidCallback onTap,
    MarkerSize size = MarkerSize.medium,
    bool isSelected = false,
  }) {
    final markerSize = ExpressiveMarkerHelper._getMarkerSize(size);

    return Marker(
      point: point,
      width: markerSize,
      height: markerSize,
      child: AppMarker(
        point: point,
        onTap: onTap,
        iconData: Icons.landscape,
        color: MarkerConstants.defaultIconColor,
        backgroundColor: MarkerConstants.defaultLandmarkColor,
        borderColor: MarkerConstants.defaultBorderColor,
        size: size,
        isSelected: isSelected,
        elevation: isSelected
            ? MarkerConstants.selectedElevation
            : MarkerConstants.defaultElevation,
      ),
    );
  }
}

/// Predefiniowane style markerów (deprecated - użyj MarkerExtensions)
@Deprecated('Użyj Marker.userLocation() zamiast MarkerStyles.userLocation()')
class MarkerStyles {
  static Marker userLocation({
    required LatLng point,
    required VoidCallback onTap,
    Color? color,
    MarkerSize size = MarkerSize.medium,
  }) {
    final markerSize = ExpressiveMarkerHelper._getMarkerSize(size);

    return Marker(
      point: point,
      width: markerSize,
      height: markerSize,
      child: AppMarker(
        point: point,
        onTap: onTap,
        iconData: Icons.person,
        color: MarkerConstants.defaultIconColor,
        backgroundColor: color ?? MarkerConstants.defaultUserLocationColor,
        borderColor: MarkerConstants.defaultBorderColor,
        size: size,
        elevation: MarkerConstants.userLocationElevation,
        shadowBlur: MarkerConstants.userLocationShadowBlur,
        shadowSpread: MarkerConstants.userLocationShadowSpread,
      ),
    );
  }

  static Marker mapPoint({
    required LatLng point,
    required VoidCallback onTap,
    required IconData iconData,
    Color? color,
    Color? backgroundColor,
    MarkerSize size = MarkerSize.medium,
    bool isSelected = false,
  }) {
    final markerSize = ExpressiveMarkerHelper._getMarkerSize(size);

    return Marker(
      point: point,
      width: markerSize,
      height: markerSize,
      child: AppMarker(
        point: point,
        onTap: onTap,
        iconData: iconData,
        color: MarkerConstants.defaultIconColor,
        backgroundColor:
            backgroundColor ?? color ?? MarkerConstants.defaultMapPointColor,
        borderColor: MarkerConstants.defaultBorderColor,
        size: size,
        isSelected: isSelected,
        elevation: isSelected
            ? MarkerConstants.selectedElevation
            : MarkerConstants.defaultElevation,
        shadowBlur: isSelected
            ? MarkerConstants.selectedShadowBlur
            : MarkerConstants.defaultShadowBlur,
        shadowSpread: isSelected
            ? MarkerConstants.selectedShadowSpread
            : MarkerConstants.defaultShadowSpread,
      ),
    );
  }

  static Marker busStop({
    required LatLng point,
    required VoidCallback onTap,
    MarkerSize size = MarkerSize.medium,
    bool isSelected = false,
  }) {
    final markerSize = ExpressiveMarkerHelper._getMarkerSize(size);

    return Marker(
      point: point,
      width: markerSize,
      height: markerSize,
      child: AppMarker(
        point: point,
        onTap: onTap,
        iconData: Icons.directions_bus,
        color: MarkerConstants.defaultIconColor,
        backgroundColor: MarkerConstants.defaultBusStopColor,
        borderColor: MarkerConstants.defaultBorderColor,
        size: size,
        isSelected: isSelected,
        elevation: isSelected
            ? MarkerConstants.selectedElevation
            : MarkerConstants.defaultElevation,
      ),
    );
  }

  static Marker landmark({
    required LatLng point,
    required VoidCallback onTap,
    MarkerSize size = MarkerSize.medium,
    bool isSelected = false,
  }) {
    final markerSize = ExpressiveMarkerHelper._getMarkerSize(size);

    return Marker(
      point: point,
      width: markerSize,
      height: markerSize,
      child: AppMarker(
        point: point,
        onTap: onTap,
        iconData: Icons.landscape,
        color: MarkerConstants.defaultIconColor,
        backgroundColor: MarkerConstants.defaultLandmarkColor,
        borderColor: MarkerConstants.defaultBorderColor,
        size: size,
        isSelected: isSelected,
        elevation: isSelected
            ? MarkerConstants.selectedElevation
            : MarkerConstants.defaultElevation,
      ),
    );
  }
}
