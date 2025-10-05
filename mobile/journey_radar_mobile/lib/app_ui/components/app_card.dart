import 'package:flutter/material.dart';
import 'package:journey_radar_mobile/app_ui/app_spacing.dart';

/// Generic card component with multiple variants
class AppCard extends StatelessWidget {
  final Widget child;
  final AppCardVariant variant;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final bool isElevated;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.default_,
    this.padding,
    this.margin,
    this.onTap,
    this.isElevated = true,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final cardStyle = _getCardStyle(context);

    Widget card = Container(
      decoration: cardStyle,
      child: Padding(
        padding: padding ?? _getDefaultPadding(),
        child: child,
      ),
    );

    if (margin != null) {
      card = Padding(
        padding: margin!,
        child: card,
      );
    }

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? _getDefaultBorderRadius(),
        child: card,
      );
    }

    return card;
  }

  BoxDecoration _getCardStyle(BuildContext context) {
    final theme = Theme.of(context);

    return BoxDecoration(
      color: backgroundColor ?? _getBackgroundColor(context),
      borderRadius: borderRadius ?? _getDefaultBorderRadius(),
      border: _getBorder(context),
      boxShadow: isElevated ? _getBoxShadow(context) : null,
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (variant) {
      case AppCardVariant.default_:
        return colorScheme.surface;
      case AppCardVariant.outlined:
        return colorScheme.surface;
      case AppCardVariant.filled:
        return colorScheme.surfaceContainerHighest;
      case AppCardVariant.elevated:
        return colorScheme.surface;
      case AppCardVariant.primary:
        return colorScheme.primaryContainer;
      case AppCardVariant.secondary:
        return colorScheme.secondaryContainer;
    }
  }

  Border? _getBorder(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (variant) {
      case AppCardVariant.default_:
        return null;
      case AppCardVariant.outlined:
        return Border.all(
          color: colorScheme.outline,
          width: 1,
        );
      case AppCardVariant.filled:
        return null;
      case AppCardVariant.elevated:
        return null;
      case AppCardVariant.primary:
        return Border.all(
          color: colorScheme.primary,
          width: 1,
        );
      case AppCardVariant.secondary:
        return Border.all(
          color: colorScheme.secondary,
          width: 1,
        );
    }
  }

  List<BoxShadow> _getBoxShadow(BuildContext context) {
    switch (variant) {
      case AppCardVariant.default_:
        return [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: AppSpacing.xs,
            offset: const Offset(0, 1),
          ),
        ];
      case AppCardVariant.outlined:
        return [];
      case AppCardVariant.filled:
        return [];
      case AppCardVariant.elevated:
        return [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: AppSpacing.s,
            offset: const Offset(0, 2),
          ),
        ];
      case AppCardVariant.primary:
        return [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            blurRadius: AppSpacing.s,
            offset: const Offset(0, 2),
          ),
        ];
      case AppCardVariant.secondary:
        return [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
            blurRadius: AppSpacing.s,
            offset: const Offset(0, 2),
          ),
        ];
    }
  }

  EdgeInsets _getDefaultPadding() {
    return EdgeInsets.all(AppSpacing.m);
  }

  BorderRadius _getDefaultBorderRadius() {
    return BorderRadius.circular(AppSpacing.s);
  }
}

enum AppCardVariant {
  default_,
  outlined,
  filled,
  elevated,
  primary,
  secondary,
}
