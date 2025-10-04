import 'package:flutter/material.dart';
import 'package:journey_radar_mobile/app_ui/app_spacing.dart';

/// Generic text component with predefined styles
class AppText extends StatelessWidget {
  final String text;
  final AppTextVariant variant;
  final AppTextSize size;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontWeight? fontWeight;
  final double? letterSpacing;
  final double? lineHeight;

  const AppText(
    this.text, {
    super.key,
    this.variant = AppTextVariant.body,
    this.size = AppTextSize.medium,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight,
    this.letterSpacing,
    this.lineHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = _getTextStyle(context);

    return Text(
      text,
      style: textStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  TextStyle _getTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final baseStyle = _getBaseStyle(context);
    final variantStyle = _getVariantStyle(context);

    return baseStyle.merge(variantStyle).copyWith(
          color: color ?? baseStyle.color,
          fontWeight: fontWeight ?? baseStyle.fontWeight,
          letterSpacing: letterSpacing ?? baseStyle.letterSpacing,
          height: lineHeight ?? baseStyle.height,
        );
  }

  TextStyle _getBaseStyle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (size) {
      case AppTextSize.small:
        return TextStyle(
          fontSize: AppSpacing.s,
          color: colorScheme.onSurface,
        );
      case AppTextSize.medium:
        return TextStyle(
          fontSize: AppSpacing.m,
          color: colorScheme.onSurface,
        );
      case AppTextSize.large:
        return TextStyle(
          fontSize: AppSpacing.l,
          color: colorScheme.onSurface,
        );
      case AppTextSize.extraLarge:
        return TextStyle(
          fontSize: AppSpacing.xl,
          color: colorScheme.onSurface,
        );
    }
  }

  TextStyle _getVariantStyle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (variant) {
      case AppTextVariant.headline:
        return TextStyle(
          fontSize: AppSpacing.xl,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        );
      case AppTextVariant.title:
        return TextStyle(
          fontSize: AppSpacing.l,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        );
      case AppTextVariant.subtitle:
        return TextStyle(
          fontSize: AppSpacing.m,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurfaceVariant,
        );
      case AppTextVariant.body:
        return TextStyle(
          fontSize: AppSpacing.m,
          fontWeight: FontWeight.normal,
          color: colorScheme.onSurface,
        );
      case AppTextVariant.caption:
        return TextStyle(
          fontSize: AppSpacing.s,
          fontWeight: FontWeight.normal,
          color: colorScheme.onSurfaceVariant,
        );
      case AppTextVariant.label:
        return TextStyle(
          fontSize: AppSpacing.s,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        );
      case AppTextVariant.error:
        return TextStyle(
          fontSize: AppSpacing.m,
          fontWeight: FontWeight.normal,
          color: colorScheme.error,
        );
      case AppTextVariant.success:
        return TextStyle(
          fontSize: AppSpacing.m,
          fontWeight: FontWeight.normal,
          color: Colors.green,
        );
      case AppTextVariant.warning:
        return TextStyle(
          fontSize: AppSpacing.m,
          fontWeight: FontWeight.normal,
          color: Colors.orange,
        );
    }
  }
}

/// Predefined text styles for common use cases
class AppTextStyles {
  static TextStyle headline(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return TextStyle(
      fontSize: AppSpacing.xl,
      fontWeight: FontWeight.bold,
      color: colorScheme.onSurface,
    );
  }

  static TextStyle title(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return TextStyle(
      fontSize: AppSpacing.l,
      fontWeight: FontWeight.w600,
      color: colorScheme.onSurface,
    );
  }

  static TextStyle subtitle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return TextStyle(
      fontSize: AppSpacing.m,
      fontWeight: FontWeight.w500,
      color: colorScheme.onSurfaceVariant,
    );
  }

  static TextStyle body(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return TextStyle(
      fontSize: AppSpacing.m,
      fontWeight: FontWeight.normal,
      color: colorScheme.onSurface,
    );
  }

  static TextStyle caption(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return TextStyle(
      fontSize: AppSpacing.s,
      fontWeight: FontWeight.normal,
      color: colorScheme.onSurfaceVariant,
    );
  }

  static TextStyle label(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return TextStyle(
      fontSize: AppSpacing.s,
      fontWeight: FontWeight.w500,
      color: colorScheme.onSurface,
    );
  }

  static TextStyle error(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return TextStyle(
      fontSize: AppSpacing.m,
      fontWeight: FontWeight.normal,
      color: colorScheme.error,
    );
  }

  static TextStyle success(BuildContext context) {
    return TextStyle(
      fontSize: AppSpacing.m,
      fontWeight: FontWeight.normal,
      color: Colors.green,
    );
  }

  static TextStyle warning(BuildContext context) {
    return TextStyle(
      fontSize: AppSpacing.m,
      fontWeight: FontWeight.normal,
      color: Colors.orange,
    );
  }
}

enum AppTextVariant {
  headline,
  title,
  subtitle,
  body,
  caption,
  label,
  error,
  success,
  warning,
}

enum AppTextSize {
  small,
  medium,
  large,
  extraLarge,
}
