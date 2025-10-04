import 'package:flutter/material.dart';
import 'package:journey_radar_mobile/app_ui/app_spacing.dart';

/// Generic button component with multiple variants
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle(context);
    final buttonSize = _getButtonSize();

    Widget buttonChild = _buildButtonChild();

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: _buildButton(buttonStyle, buttonSize, buttonChild),
      );
    }

    return _buildButton(buttonStyle, buttonSize, buttonChild);
  }

  Widget _buildButton(ButtonStyle buttonStyle, Size buttonSize, Widget child) {
    switch (variant) {
      case AppButtonVariant.primary:
        return FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: child,
        );
      case AppButtonVariant.secondary:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: child,
        );
      case AppButtonVariant.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: child,
        );
      case AppButtonVariant.icon:
        return IconButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          icon: child,
        );
    }
  }

  Widget _buildButtonChild() {
    if (isLoading) {
      return SizedBox(
        width: AppSpacing.m,
        height: AppSpacing.m,
        child: const CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (icon != null && variant != AppButtonVariant.icon) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: _getIconSize()),
          SizedBox(width: AppSpacing.xs),
          Text(text),
        ],
      );
    }

    return Text(text);
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (variant) {
      case AppButtonVariant.primary:
        return FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: _getPadding(),
          textStyle: theme.textTheme.labelLarge,
        );
      case AppButtonVariant.secondary:
        return OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: _getPadding(),
          textStyle: theme.textTheme.labelLarge,
        );
      case AppButtonVariant.text:
        return TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: _getPadding(),
          textStyle: theme.textTheme.labelLarge,
        );
      case AppButtonVariant.icon:
        return IconButton.styleFrom(
          foregroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
    }
  }

  Size _getButtonSize() {
    switch (size) {
      case AppButtonSize.small:
        return const Size(80, 32);
      case AppButtonSize.medium:
        return const Size(120, 40);
      case AppButtonSize.large:
        return const Size(160, 48);
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case AppButtonSize.small:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.s,
          vertical: AppSpacing.xs,
        );
      case AppButtonSize.medium:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.s,
        );
      case AppButtonSize.large:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.l,
          vertical: AppSpacing.m,
        );
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return AppSpacing.s;
      case AppButtonSize.medium:
        return AppSpacing.m;
      case AppButtonSize.large:
        return AppSpacing.l;
    }
  }
}

enum AppButtonVariant {
  primary,
  secondary,
  text,
  icon,
}

enum AppButtonSize {
  small,
  medium,
  large,
}
