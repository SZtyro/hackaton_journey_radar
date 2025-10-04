// ignore_for_file: lines_longer_than_80_chars, cascade_invocations

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journey_radar_mobile/app_ui/app_theme.dart';
import 'package:sizer/sizer.dart';

import 'routes/app_router.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    // final notificationPermissionCubit = NotificationPermissionCubit();
    // notificationPermissionCubit.checkNotificationPermission();

    // final loginCubit = LoginCubit(
    //   authRepository: getIt<AuthRepository>(),
    //   userManagementRepository: getIt<UserManagementRepository>(),
    // );

    final router = AppRouter(
    ).router();
    return MultiBlocProvider(
      providers: [
      ],
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp.router(
            // debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.dark,
            theme: appTheme(isDarkTheme: false),
            darkTheme: appTheme(),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
