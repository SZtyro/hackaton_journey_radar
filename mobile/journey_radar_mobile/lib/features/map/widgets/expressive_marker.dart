import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:journey_radar_mobile/app_ui/app_spacing.dart';

/// Generyczny marker zgodny z Material Design 3 expressive
/// Obsługuje różne typy markerów z animacjami i skalowalnością
class ExpressiveMarker extends StatelessWidget {
  const ExpressiveMarker({
    super.key,
    required this.point,
    required this.onTap,
    this.icon,
    this.iconData,
    this.color,
    this.backgroundColor,
    this.borderColor,
    this.size = MarkerSize.medium,
    this.isSelected = false,
    this.isAnimated = true,
    this.elevation = 4.0,
    this.borderWidth = 2.0,
    this.shadowBlur = 8.0,
    this.shadowSpread = 2.0,
    this.animationDuration = const Duration(milliseconds: 200),
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
              color: defaultBackgroundColor.withOpacity(0.3),
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
    double elevation = 4.0,
    double borderWidth = 2.0,
    double shadowBlur = 8.0,
    double shadowSpread = 2.0,
    Duration animationDuration = const Duration(milliseconds: 200),
  }) {
    final markerSize = _getMarkerSize(size);

    return Marker(
      point: point,
      width: markerSize,
      height: markerSize,
      child: ExpressiveMarker(
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

/// Predefiniowane style markerów
class MarkerStyles {
  static Marker userLocation({
    required LatLng point,
    required VoidCallback onTap,
    Color? color,
    MarkerSize size = MarkerSize.medium,
  }) {
    return ExpressiveMarkerHelper.createMarker(
      point: point,
      onTap: onTap,
      iconData: Icons.person,
      color: Colors.white,
      backgroundColor: color ?? Colors.blue,
      borderColor: Colors.white,
      size: size,
      elevation: 6.0,
      shadowBlur: 12.0,
      shadowSpread: 3.0,
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
    return ExpressiveMarkerHelper.createMarker(
      point: point,
      onTap: onTap,
      iconData: iconData,
      color: Colors.white,
      backgroundColor: backgroundColor ?? color ?? Colors.orange,
      borderColor: Colors.white,
      size: size,
      isSelected: isSelected,
      elevation: isSelected ? 8.0 : 4.0,
      shadowBlur: isSelected ? 12.0 : 8.0,
      shadowSpread: isSelected ? 3.0 : 2.0,
    );
  }

  static Marker busStop({
    required LatLng point,
    required VoidCallback onTap,
    MarkerSize size = MarkerSize.medium,
    bool isSelected = false,
  }) {
    return ExpressiveMarkerHelper.createMarker(
      point: point,
      onTap: onTap,
      iconData: Icons.directions_bus,
      color: Colors.white,
      backgroundColor: Colors.green,
      borderColor: Colors.white,
      size: size,
      isSelected: isSelected,
      elevation: isSelected ? 8.0 : 4.0,
    );
  }

  static Marker landmark({
    required LatLng point,
    required VoidCallback onTap,
    MarkerSize size = MarkerSize.medium,
    bool isSelected = false,
  }) {
    return ExpressiveMarkerHelper.createMarker(
      point: point,
      onTap: onTap,
      iconData: Icons.landscape,
      color: Colors.white,
      backgroundColor: Colors.purple,
      borderColor: Colors.white,
      size: size,
      isSelected: isSelected,
      elevation: isSelected ? 8.0 : 4.0,
    );
  }
}
