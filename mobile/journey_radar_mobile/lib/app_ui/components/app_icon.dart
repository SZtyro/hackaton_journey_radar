import 'package:flutter/material.dart';
import 'package:journey_radar_mobile/app_ui/app_spacing.dart';

/// Generic icon component with multiple variants
class AppIcon extends StatelessWidget {
  final IconData icon;
  final AppIconVariant variant;
  final AppIconSize size;
  final Color? color;
  final VoidCallback? onPressed;
  final bool isSelected;
  final String? tooltip;

  const AppIcon({
    super.key,
    required this.icon,
    this.variant = AppIconVariant.default_,
    this.size = AppIconSize.medium,
    this.color,
    this.onPressed,
    this.isSelected = false,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final iconSize = _getIconSize();
    final iconColor = _getIconColor(context);

    Widget iconWidget = Icon(
      icon,
      size: iconSize,
      color: iconColor,
    );

    if (tooltip != null) {
      iconWidget = Tooltip(
        message: tooltip!,
        child: iconWidget,
      );
    }

    if (onPressed != null) {
      return IconButton(
        onPressed: onPressed,
        icon: iconWidget,
        style: _getIconButtonStyle(context),
      );
    }

    return iconWidget;
  }

  double _getIconSize() {
    switch (size) {
      case AppIconSize.small:
        return AppSpacing.s;
      case AppIconSize.medium:
        return AppSpacing.m;
      case AppIconSize.large:
        return AppSpacing.l;
      case AppIconSize.extraLarge:
        return AppSpacing.xl;
    }
  }

  Color _getIconColor(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (color != null) return color!;

    switch (variant) {
      case AppIconVariant.default_:
        return colorScheme.onSurface;
      case AppIconVariant.primary:
        return colorScheme.primary;
      case AppIconVariant.secondary:
        return colorScheme.secondary;
      case AppIconVariant.error:
        return colorScheme.error;
      case AppIconVariant.success:
        return colorScheme.primary;
      case AppIconVariant.warning:
        return colorScheme.tertiary;
      case AppIconVariant.info:
        return colorScheme.secondary;
      case AppIconVariant.muted:
        return colorScheme.onSurfaceVariant;
    }
  }

  ButtonStyle? _getIconButtonStyle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (variant) {
      case AppIconVariant.default_:
        return IconButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          backgroundColor: isSelected ? colorScheme.primaryContainer : null,
        );
      case AppIconVariant.primary:
        return IconButton.styleFrom(
          foregroundColor: colorScheme.onPrimary,
          backgroundColor: colorScheme.primary,
        );
      case AppIconVariant.secondary:
        return IconButton.styleFrom(
          foregroundColor: colorScheme.onSecondary,
          backgroundColor: colorScheme.secondary,
        );
      case AppIconVariant.error:
        return IconButton.styleFrom(
          foregroundColor: colorScheme.onError,
          backgroundColor: colorScheme.error,
        );
      case AppIconVariant.success:
        return IconButton.styleFrom(
          foregroundColor: colorScheme.onPrimary,
          backgroundColor: colorScheme.primary,
        );
      case AppIconVariant.warning:
        return IconButton.styleFrom(
          foregroundColor: colorScheme.onTertiary,
          backgroundColor: colorScheme.tertiary,
        );
      case AppIconVariant.info:
        return IconButton.styleFrom(
          foregroundColor: colorScheme.onSecondary,
          backgroundColor: colorScheme.secondary,
        );
      case AppIconVariant.muted:
        return IconButton.styleFrom(
          foregroundColor: colorScheme.onSurfaceVariant,
          backgroundColor: colorScheme.surfaceContainerHighest,
        );
    }
  }
}

/// Generic avatar component
class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final IconData? icon;
  final AppAvatarSize size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback? onTap;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.icon,
    this.size = AppAvatarSize.medium,
    this.backgroundColor,
    this.foregroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final avatarSize = _getAvatarSize();
    final bgColor = backgroundColor ?? colorScheme.primary;
    final fgColor = foregroundColor ?? colorScheme.onPrimary;

    Widget avatar;

    if (imageUrl != null) {
      avatar = CircleAvatar(
        radius: avatarSize,
        backgroundImage: NetworkImage(imageUrl!),
        backgroundColor: bgColor,
        child: imageUrl!.isEmpty ? _getFallbackChild(fgColor) : null,
      );
    } else if (initials != null) {
      avatar = CircleAvatar(
        radius: avatarSize,
        backgroundColor: bgColor,
        child: Text(
          initials!,
          style: TextStyle(
            color: fgColor,
            fontSize: _getTextSize(),
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else if (icon != null) {
      avatar = CircleAvatar(
        radius: avatarSize,
        backgroundColor: bgColor,
        child: Icon(
          icon!,
          color: fgColor,
          size: _getIconSize(),
        ),
      );
    } else {
      avatar = CircleAvatar(
        radius: avatarSize,
        backgroundColor: bgColor,
        child: Icon(
          Icons.person,
          color: fgColor,
          size: _getIconSize(),
        ),
      );
    }

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(avatarSize),
        child: avatar,
      );
    }

    return avatar;
  }

  double _getAvatarSize() {
    switch (size) {
      case AppAvatarSize.small:
        return AppSpacing.m;
      case AppAvatarSize.medium:
        return AppSpacing.l;
      case AppAvatarSize.large:
        return AppSpacing.xl;
      case AppAvatarSize.extraLarge:
        return AppSpacing.xxl;
    }
  }

  double _getTextSize() {
    switch (size) {
      case AppAvatarSize.small:
        return AppSpacing.s;
      case AppAvatarSize.medium:
        return AppSpacing.m;
      case AppAvatarSize.large:
        return AppSpacing.l;
      case AppAvatarSize.extraLarge:
        return AppSpacing.xl;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppAvatarSize.small:
        return AppSpacing.s;
      case AppAvatarSize.medium:
        return AppSpacing.m;
      case AppAvatarSize.large:
        return AppSpacing.l;
      case AppAvatarSize.extraLarge:
        return AppSpacing.xl;
    }
  }

  Widget _getFallbackChild(Color color) {
    return Icon(
      Icons.person,
      color: color,
      size: _getIconSize(),
    );
  }
}

enum AppIconVariant {
  default_,
  primary,
  secondary,
  error,
  success,
  warning,
  info,
  muted,
}

enum AppIconSize {
  small,
  medium,
  large,
  extraLarge,
}

enum AppAvatarSize {
  small,
  medium,
  large,
  extraLarge,
}
