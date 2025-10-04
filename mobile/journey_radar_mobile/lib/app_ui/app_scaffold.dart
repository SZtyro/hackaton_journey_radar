// ignore_for_file: public_member_api_docs, avoid_positional_boolean_parameters

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:journey_radar_mobile/app_ui/app_theme.dart';
import 'package:journey_radar_mobile/app_ui/build_context_extension.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.body,
    super.key,
    this.onPopInvokedWithResult,
    this.canPop,
    this.safeArea = true,
    this.top = true,
    this.bottom = true,
    this.left = true,
    this.right = true,
    this.releaseFocus = false,
    this.resizeToAvoidBottomInset = false,
    this.extendBody = false,
    this.backgroundColor,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.appBar,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.bottomSheet,
    this.extendBodyBehindAppBar = true,
  });

  final bool safeArea;

  final bool top;

  final bool bottom;

  final bool right;

  final bool left;

  /// If true, will release the focus when the user taps outside of the
  /// text field.
  final bool releaseFocus;

  /// If true, will resize the body when the keyboard is shown.
  final bool resizeToAvoidBottomInset;

  final Widget body;

  final Color? backgroundColor;

  final Widget? floatingActionButton;

  final FloatingActionButtonLocation? floatingActionButtonLocation;

  final Widget? bottomNavigationBar;

  /// The app bar of the scaffold.
  final PreferredSizeWidget? appBar;

  final Widget? drawer;

  final Widget? endDrawer;

  final Widget? bottomSheet;

  /// Will pop callback. If null, will pop the navigator.
  final void Function(bool, dynamic)? onPopInvokedWithResult;

  /// If true, will pop the navigator.
  final bool? canPop;

  /// Whether to extend the body behind the bottom navigation bar.
  final bool extendBody;

  /// Whether to extend the body behind the app bar.
  final bool extendBodyBehindAppBar;

  @override
  Widget build(BuildContext context) {
    if (releaseFocus) {
      return GestureDetector(
        onTap: () => _releaseFocus(context),
        child: _MaterialScaffold(
          top: top,
          bottom: bottom,
          right: right,
          left: left,
          body: body,
          withSafeArea: safeArea,
          backgroundColor: backgroundColor,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
          bottomNavigationBar: bottomNavigationBar,
          appBar: appBar,
          drawer: drawer,
          endDrawer: endDrawer,
          bottomSheet: bottomSheet,
          onPopInvokedWithResult: onPopInvokedWithResult,
          canPop: canPop,
          extendBody: extendBody,
          extendBodyBehindAppBar: extendBodyBehindAppBar,
        ),
      );
    }
    return _MaterialScaffold(
      top: top,
      bottom: bottom,
      right: right,
      left: left,
      body: body,
      withSafeArea: safeArea,
      backgroundColor: backgroundColor,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      appBar: appBar,
      drawer: drawer,
      endDrawer: endDrawer,
      bottomSheet: bottomSheet,
      onPopInvokedWithResult: onPopInvokedWithResult,
      canPop: canPop,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
    );
  }

  void _releaseFocus(BuildContext context) => FocusScope.of(context).unfocus();
}

class _MaterialScaffold extends StatelessWidget {
  const _MaterialScaffold({
    required this.top,
    required this.bottom,
    required this.right,
    required this.left,
    required this.body,
    required this.withSafeArea,
    required this.extendBody,
    required this.extendBodyBehindAppBar,
    this.canPop,
    this.backgroundColor,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.appBar,
    this.drawer,
    this.endDrawer,
    this.bottomSheet,
    this.onPopInvokedWithResult,
  });

  final bool top;
  final bool bottom;
  final bool right;
  final bool left;
  final Widget body;
  final bool withSafeArea;
  final Color? backgroundColor;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? bottomSheet;
  final void Function(bool, dynamic)? onPopInvokedWithResult;
  final bool? canPop;
  final bool extendBody;
  final bool extendBodyBehindAppBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      body: withSafeArea
          ? SafeArea(
              top: top,
              bottom: bottom,
              right: right,
              left: left,
              child: body,
            )
          : body,
      backgroundColor: backgroundColor,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      appBar: appBar,
      drawer: drawer,
      endDrawer: endDrawer,
      bottomSheet: bottomSheet,
    )
        .withPopScope(onPopInvokedWithResult, canPop: canPop)
        .withAdaptiveSystemTheme(context);
  }
}

/// Pop scope extension that wraps widget with [PopScope].
extension PopScopeX on Widget {
  /// Wraps widget with [PopScope].
  Widget withPopScope(
    void Function(bool, dynamic)? onPopInvokedWithResult, {
    bool? canPop,
  }) =>
      onPopInvokedWithResult == null && canPop == null
          ? this
          : PopScope(
              onPopInvokedWithResult: onPopInvokedWithResult,
              canPop: canPop ?? true,
              child: this,
            );
}

/// Extension used to respectively change the `systemNavigationBar` theme.
extension SystemNavigationBarTheme on Widget {
  /// Overrides default [SystemUiOverlayStyle] with adaptive values.
  Widget withAdaptiveSystemTheme(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: defaultTargetPlatform == TargetPlatform.android
          ? context.isLight
              ? SystemUiOverlayTheme.androidLightSystemBarTheme
              : SystemUiOverlayTheme.androidDarkSystemBarTheme
          : context.isLight
              ? SystemUiOverlayTheme.iOSDarkSystemBarTheme
              : SystemUiOverlayTheme.iOSLightSystemBarTheme,
      child: this,
    );
  }
}
