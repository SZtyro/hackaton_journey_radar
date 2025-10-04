import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:journey_radar_mobile/config/constants.dart';
import 'package:journey_radar_mobile/config/logger.dart';
import 'package:journey_radar_mobile/config/service_locator.dart';

typedef AppBuilder = FutureOr<Widget> Function();

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (!bloc.runtimeType.toString().contains('VoiceRecordingCubit')) {
      logD('onChange(${bloc.runtimeType}, $change)');
    }
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    logE('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(
  AppBuilder builder,
) async {
  FlutterError.onError = (details) {
    logE(details.exceptionAsString(), stackTrace: details.stack);
  };

  await runZonedGuarded(() async {
    final binding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: binding);
    await EasyLocalization.ensureInitialized();
    Bloc.observer = const AppBlocObserver();

    // Add cross-flavor configuration here
    // await Firebase.initializeApp(options: options);

    await setUpServiceLocator();
    runApp(
      EasyLocalization(
        supportedLocales: const [
          Locale(LanguageConstants.en),
          Locale(LanguageConstants.pl),
        ],
        useOnlyLangCode: true,
        path: 'assets/translations',
        child: await builder(),
      ),
    );
  }, (error, stack) {
    logE(error.toString(), stackTrace: stack);
  });
}
