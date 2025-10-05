import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Generic text field component with multiple variants
class AppTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final AppTextFieldVariant variant;
  final AppTextFieldMode mode;
  final int? maxLines;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.keyboardType,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.variant = AppTextFieldVariant.outlined,
    this.mode = AppTextFieldMode.text,
    this.maxLines = 1,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final decoration = _getInputDecoration(context);

    Widget textField;

    final effectiveKeyboardType = _getEffectiveKeyboardType();
    final effectiveInputFormatters = _getEffectiveInputFormatters();

    if (maxLines == 1) {
      textField = TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        onTap: onTap,
        obscureText: obscureText,
        enabled: enabled,
        readOnly: readOnly,
        keyboardType: effectiveKeyboardType,
        inputFormatters: effectiveInputFormatters,
        textCapitalization: textCapitalization,
        textInputAction: textInputAction,
        focusNode: focusNode,
        maxLength: maxLength,
        decoration: decoration,
      );
    } else {
      textField = TextField(
        controller: controller,
        onChanged: onChanged,
        onTap: onTap,
        obscureText: obscureText,
        enabled: enabled,
        readOnly: readOnly,
        keyboardType: effectiveKeyboardType,
        inputFormatters: effectiveInputFormatters,
        textCapitalization: textCapitalization,
        textInputAction: textInputAction,
        focusNode: focusNode,
        maxLines: maxLines,
        maxLength: maxLength,
        decoration: decoration,
      );
    }

    return textField;
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
      counterText: maxLength != null ? null : '',
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16, // Material 3 standard
        vertical: 12, // Material 3 standard
      ),
    );

    switch (variant) {
      case AppTextFieldVariant.outlined:
        return baseDecoration.copyWith(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Material 3 standard
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Material 3 standard
            borderSide: BorderSide(color: colorScheme.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Material 3 standard
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Material 3 standard
            borderSide: BorderSide(color: colorScheme.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Material 3 standard
            borderSide: BorderSide(color: colorScheme.error, width: 2),
          ),
        );
      case AppTextFieldVariant.filled:
        return baseDecoration.copyWith(
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Material 3 standard
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Material 3 standard
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Material 3 standard
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Material 3 standard
            borderSide: BorderSide(color: colorScheme.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // Material 3 standard
            borderSide: BorderSide(color: colorScheme.error, width: 2),
          ),
        );
      case AppTextFieldVariant.underlined:
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

  TextInputType? _getEffectiveKeyboardType() {
    if (keyboardType != null) return keyboardType;

    switch (mode) {
      case AppTextFieldMode.text:
        return TextInputType.text;
      case AppTextFieldMode.integer:
        return TextInputType.number;
      case AppTextFieldMode.decimal:
        return const TextInputType.numberWithOptions(decimal: true);
    }
  }

  List<TextInputFormatter>? _getEffectiveInputFormatters() {
    if (inputFormatters != null) return inputFormatters;

    switch (mode) {
      case AppTextFieldMode.text:
        return null;
      case AppTextFieldMode.integer:
        return [FilteringTextInputFormatter.digitsOnly];
      case AppTextFieldMode.decimal:
        return [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))];
    }
  }
}

enum AppTextFieldVariant {
  outlined,
  filled,
  underlined,
}

enum AppTextFieldMode {
  text,
  integer,
  decimal,
}
