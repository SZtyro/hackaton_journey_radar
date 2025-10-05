import 'package:flutter/material.dart';
import 'package:journey_radar_mobile/app_ui/app_spacing.dart';
import 'package:journey_radar_mobile/app_ui/components/app_text.dart';

/// Generic loading component with multiple variants
class AppLoading extends StatelessWidget {
  final AppLoadingVariant variant;
  final AppLoadingSize size;
  final Color? color;
  final String? message;
  final bool isCentered;

  const AppLoading({
    super.key,
    this.variant = AppLoadingVariant.circular,
    this.size = AppLoadingSize.medium,
    this.color,
    this.message,
    this.isCentered = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final loadingColor = color ?? colorScheme.primary;

    Widget loadingWidget = _buildLoadingWidget(loadingColor);

    if (message != null) {
      loadingWidget = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          loadingWidget,
          SizedBox(height: AppSpacing.s),
          AppText(
            message!,
            variant: AppTextVariant.body,
            color: colorScheme.onSurface,
          ),
        ],
      );
    }

    if (isCentered) {
      return Center(child: loadingWidget);
    }

    return loadingWidget;
  }

  Widget _buildLoadingWidget(Color loadingColor) {
    switch (variant) {
      case AppLoadingVariant.circular:
        return SizedBox(
          width: _getSize(),
          height: _getSize(),
          child: CircularProgressIndicator(
            strokeWidth: _getStrokeWidth(),
            valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
          ),
        );
      case AppLoadingVariant.linear:
        return SizedBox(
          width: _getSize(),
          child: LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
          ),
        );
      case AppLoadingVariant.dots:
        return _buildDotsLoader(loadingColor);
    }
  }

  Widget _buildDotsLoader(Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: SizedBox(
            width: _getDotSize(),
            height: _getDotSize(),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        );
      }),
    );
  }

  double _getSize() {
    switch (size) {
      case AppLoadingSize.small:
        return AppSpacing.m;
      case AppLoadingSize.medium:
        return AppSpacing.l;
      case AppLoadingSize.large:
        return AppSpacing.xl;
    }
  }

  double _getStrokeWidth() {
    switch (size) {
      case AppLoadingSize.small:
        return 2.0;
      case AppLoadingSize.medium:
        return 3.0;
      case AppLoadingSize.large:
        return 4.0;
    }
  }

  double _getDotSize() {
    switch (size) {
      case AppLoadingSize.small:
        return AppSpacing.xs;
      case AppLoadingSize.medium:
        return AppSpacing.s;
      case AppLoadingSize.large:
        return AppSpacing.m;
    }
  }
}

enum AppLoadingVariant {
  circular,
  linear,
  dots,
}

enum AppLoadingSize {
  small,
  medium,
  large,
}
