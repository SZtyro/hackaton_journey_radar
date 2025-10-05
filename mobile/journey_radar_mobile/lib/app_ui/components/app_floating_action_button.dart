import 'package:flutter/material.dart';
import 'package:journey_radar_mobile/app_ui/app_spacing.dart';

/// Generic floating action button component with multiple variants
class AppFloatingActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final AppFABVariant variant;
  final AppFABSize size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? tooltip;
  final bool isExtended;
  final String? label;

  const AppFloatingActionButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.variant = AppFABVariant.primary,
    this.size = AppFABSize.medium,
    this.backgroundColor,
    this.foregroundColor,
    this.tooltip,
    this.isExtended = false,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final fabColor = _getFABColor(context);
    final foregroundColor =
        this.foregroundColor ?? _getForegroundColor(context);

    Widget fab;

    if (isExtended && label != null) {
      fab = FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: fabColor,
        foregroundColor: foregroundColor,
        icon: Icon(icon, size: _getIconSize()),
        label: Text(
          label!,
          style: TextStyle(
            fontSize: _getTextSize(),
            fontWeight: FontWeight.w500,
          ),
        ),
        tooltip: tooltip,
      );
    } else {
      fab = FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: fabColor,
        foregroundColor: foregroundColor,
        child: Icon(icon, size: _getIconSize()),
        tooltip: tooltip,
      );
    }

    return fab;
  }

  Color _getFABColor(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (backgroundColor != null) return backgroundColor!;

    switch (variant) {
      case AppFABVariant.primary:
        return colorScheme.primary;
      case AppFABVariant.secondary:
        return colorScheme.secondary;
      case AppFABVariant.tertiary:
        return colorScheme.tertiary;
      case AppFABVariant.surface:
        return colorScheme.surface;
      case AppFABVariant.error:
        return colorScheme.error;
      case AppFABVariant.success:
        return Colors.green;
      case AppFABVariant.warning:
        return Colors.orange;
    }
  }

  Color _getForegroundColor(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (foregroundColor != null) return foregroundColor!;

    switch (variant) {
      case AppFABVariant.primary:
        return colorScheme.onPrimary;
      case AppFABVariant.secondary:
        return colorScheme.onSecondary;
      case AppFABVariant.tertiary:
        return colorScheme.onTertiary;
      case AppFABVariant.surface:
        return colorScheme.onSurface;
      case AppFABVariant.error:
        return colorScheme.onError;
      case AppFABVariant.success:
        return Colors.white;
      case AppFABVariant.warning:
        return Colors.white;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppFABSize.small:
        return AppSpacing.m;
      case AppFABSize.medium:
        return AppSpacing.l;
      case AppFABSize.large:
        return AppSpacing.xl;
    }
  }

  double _getTextSize() {
    switch (size) {
      case AppFABSize.small:
        return AppSpacing.s;
      case AppFABSize.medium:
        return AppSpacing.m;
      case AppFABSize.large:
        return AppSpacing.l;
    }
  }
}

/// Mini floating action button for compact spaces
class AppMiniFloatingActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final AppFABVariant variant;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? tooltip;

  const AppMiniFloatingActionButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.variant = AppFABVariant.primary,
    this.backgroundColor,
    this.foregroundColor,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final fabColor = _getFABColor(context);
    final foregroundColor =
        this.foregroundColor ?? _getForegroundColor(context);

    return FloatingActionButton.small(
      onPressed: onPressed,
      backgroundColor: fabColor,
      foregroundColor: foregroundColor,
      child: Icon(icon, size: AppSpacing.m),
      tooltip: tooltip,
    );
  }

  Color _getFABColor(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (backgroundColor != null) return backgroundColor!;

    switch (variant) {
      case AppFABVariant.primary:
        return colorScheme.primary;
      case AppFABVariant.secondary:
        return colorScheme.secondary;
      case AppFABVariant.tertiary:
        return colorScheme.tertiary;
      case AppFABVariant.surface:
        return colorScheme.surface;
      case AppFABVariant.error:
        return colorScheme.error;
      case AppFABVariant.success:
        return Colors.green;
      case AppFABVariant.warning:
        return Colors.orange;
    }
  }

  Color _getForegroundColor(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (foregroundColor != null) return foregroundColor!;

    switch (variant) {
      case AppFABVariant.primary:
        return colorScheme.onPrimary;
      case AppFABVariant.secondary:
        return colorScheme.onSecondary;
      case AppFABVariant.tertiary:
        return colorScheme.onTertiary;
      case AppFABVariant.surface:
        return colorScheme.onSurface;
      case AppFABVariant.error:
        return colorScheme.onError;
      case AppFABVariant.success:
        return Colors.white;
      case AppFABVariant.warning:
        return Colors.white;
    }
  }
}

enum AppFABVariant {
  primary,
  secondary,
  tertiary,
  surface,
  error,
  success,
  warning,
}

enum AppFABSize {
  small,
  medium,
  large,
}
