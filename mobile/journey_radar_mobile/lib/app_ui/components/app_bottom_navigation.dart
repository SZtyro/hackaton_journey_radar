import 'package:flutter/material.dart';

/// Generic bottom navigation bar component
class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final List<AppBottomNavigationItem> items;
  final AppBottomNavigationVariant variant;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double? elevation;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.items,
    this.onTap,
    this.variant = AppBottomNavigationVariant.default_,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveBackgroundColor = backgroundColor ?? colorScheme.surface;
    final effectiveSelectedColor = selectedItemColor ?? colorScheme.primary;
    final effectiveUnselectedColor =
        unselectedItemColor ?? colorScheme.onSurfaceVariant;

    switch (variant) {
      case AppBottomNavigationVariant.default_:
        return BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: effectiveBackgroundColor,
          selectedItemColor: effectiveSelectedColor,
          unselectedItemColor: effectiveUnselectedColor,
          elevation: elevation ?? 0,
          selectedLabelStyle: theme.textTheme.labelSmall,
          unselectedLabelStyle: theme.textTheme.labelSmall,
          items: _buildNavigationItems(context),
        );
      case AppBottomNavigationVariant.shifting:
        return BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.shifting,
          backgroundColor: effectiveBackgroundColor,
          selectedItemColor: effectiveSelectedColor,
          unselectedItemColor: effectiveUnselectedColor,
          elevation: elevation ?? 0,
          selectedLabelStyle: theme.textTheme.labelSmall,
          unselectedLabelStyle: theme.textTheme.labelSmall,
          items: _buildNavigationItems(context),
        );
    }
  }

  List<BottomNavigationBarItem> _buildNavigationItems(BuildContext context) {
    return items.map((item) {
      return BottomNavigationBarItem(
        icon: item.icon,
        activeIcon: item.activeIcon ?? item.icon,
        label: item.label,
        tooltip: item.tooltip,
      );
    }).toList();
  }
}

/// Bottom navigation item model
class AppBottomNavigationItem {
  final Widget icon;
  final Widget? activeIcon;
  final String label;
  final String? tooltip;

  const AppBottomNavigationItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    this.tooltip,
  });
}

enum AppBottomNavigationVariant {
  default_,
  shifting,
}
