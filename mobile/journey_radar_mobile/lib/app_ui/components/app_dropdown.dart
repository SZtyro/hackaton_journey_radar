import 'package:flutter/material.dart';
import 'package:journey_radar_mobile/app_ui/app_spacing.dart';

/// Generic dropdown component with multiple variants
class AppDropdown<T> extends StatelessWidget {
  final T? value;
  final List<AppDropdownItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final bool enabled;
  final AppDropdownVariant variant;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isExpanded;
  final bool isDense;
  final int? maxLines;

  const AppDropdown({
    super.key,
    this.value,
    required this.items,
    this.onChanged,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.variant = AppDropdownVariant.outlined,
    this.prefixIcon,
    this.suffixIcon,
    this.isExpanded = true,
    this.isDense = false,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final decoration = _getInputDecoration(context);

    return DropdownButtonFormField<T>(
      value: value,
      items: _buildDropdownItems(context),
      onChanged: enabled ? onChanged : null,
      decoration: decoration,
      isExpanded: isExpanded,
      isDense: isDense,
      menuMaxHeight: 300,
      dropdownColor: colorScheme.surface,
      style: TextStyle(
        color: colorScheme.onSurface,
        fontSize: AppSpacing.m,
      ),
      icon: Icon(
        Icons.arrow_drop_down,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  List<DropdownMenuItem<T>> _buildDropdownItems(BuildContext context) {
    return items.map((item) {
      return DropdownMenuItem<T>(
        value: item.value,
        enabled: item.enabled,
        child: Row(
          children: [
            if (item.icon != null) ...[
              Icon(
                item.icon,
                size: AppSpacing.m,
                color: item.iconColor,
              ),
              SizedBox(width: AppSpacing.s),
            ],
            Expanded(
              child: Text(
                item.text,
                style: TextStyle(
                  color: item.enabled
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            if (item.trailing != null) ...[
              SizedBox(width: AppSpacing.s),
              item.trailing!,
            ],
          ],
        ),
      );
    }).toList();
  }

  InputDecoration _getInputDecoration(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final baseDecoration = InputDecoration(
      labelText: label,
      hintText: hint,
      helperText: helperText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.s,
      ),
    );

    switch (variant) {
      case AppDropdownVariant.outlined:
        return baseDecoration.copyWith(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: colorScheme.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: colorScheme.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: colorScheme.error, width: 2),
          ),
        );
      case AppDropdownVariant.filled:
        return baseDecoration.copyWith(
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: colorScheme.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: colorScheme.error, width: 2),
          ),
        );
      case AppDropdownVariant.underlined:
        return baseDecoration.copyWith(
          border: const UnderlineInputBorder(),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorScheme.outline),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorScheme.error),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorScheme.error, width: 2),
          ),
        );
    }
  }
}

/// Dropdown item model
class AppDropdownItem<T> {
  final T value;
  final String text;
  final IconData? icon;
  final Color? iconColor;
  final Widget? trailing;
  final bool enabled;

  const AppDropdownItem({
    required this.value,
    required this.text,
    this.icon,
    this.iconColor,
    this.trailing,
    this.enabled = true,
  });
}

enum AppDropdownVariant {
  outlined,
  filled,
  underlined,
}
