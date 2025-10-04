// ignore_for_file: cascade_invocations

import 'dart:io';

import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get_it/get_it.dart';
import 'package:journey_radar_mobile/api/api.dart';
import 'package:journey_radar_mobile/config/constants.dart';
import 'package:journey_radar_mobile/config/error_interceptor.dart';
import 'package:journey_radar_mobile/config/language_provider.dart';
import 'package:journey_radar_mobile/repository/repository.dart';
import 'package:journey_radar_mobile/repository/repository_impl.dart';
import 'package:journey_radar_mobile/storage/persistent_storage.dart';
import 'package:journey_radar_mobile/storage/storage.dart';
import 'package:journey_radar_mobile/storage/user_storage.dart';
import 'package:journey_radar_mobile/theme/theme_cubit.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

/// Flag to determine whether to use mock API or real API
/// Set to true for development, false for production
const bool useMockApi = true; // Change to false when ready for real API

Future<void> setUpServiceLocator() async {
  /// Configure FlutterSecureStorage with Android-specific options to prevent data loss on updates
  const flutterSecureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      // This prevents KeyStore from being reset on app updates
      resetOnError: true,
    ),
  );
  final storage = PersistentStorage(
    secureStorage: flutterSecureStorage,
  );

  getIt.registerSingleton<Storage>(
    storage,
  );

  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(
    sharedPreferences,
  );

  final UserStorage userStorage = UserStorage(
    storage: storage,
    sharedPreferences: sharedPreferences,
  );

  await userStorage.clearSecureStorageOnFirstLaunch();

  getIt.registerSingleton<UserStorage>(
    userStorage,
  );

  final initialLanguage = await getIt<UserStorage>().getUserLanguage() ??
      Platform.localeName.substring(0, 2);

  getIt.registerSingleton<LanguageProvider>(
    LanguageProvider(
      initialLanguage: initialLanguage,
    ),
  );
  final userDio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: DioNetworkConstants.connectTimeout,
      receiveTimeout: DioNetworkConstants.receiveTimeout,
      sendTimeout: DioNetworkConstants.sendTimeout,
    ),
  );
  (userDio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
    final client = HttpClient();
    client.badCertificateCallback = (cert, host, port) => true;
    return client;
  };
  /* userDio.interceptors.add(
    UserInterceptor(
      getIt<UserStorage>(),
      userDio,
      AppConstants.baseUrl,
    ),
  ); */
  userDio.interceptors.add(
    CurlLoggerDioInterceptor(
      printOnSuccess: true,
    ),
  );
  userDio.interceptors.add(
    ErrorInterceptor(),
  );
  userDio.interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
    ),
  );

  // Register ThemeCubit
  final themeCubit = ThemeCubit();
  getIt.registerSingleton<ThemeCubit>(themeCubit);
  final flutterTts = FlutterTts();
  await flutterTts.setIosAudioCategory(IosTextToSpeechAudioCategory.playback, [
    IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
  ]);
  await flutterTts.setVolume(1);
  await flutterTts.awaitSpeakCompletion(true);
  getIt.registerSingleton<FlutterTts>(flutterTts);
  // getIt.registerLazySingleton<FirebasePushNotificationService>(
  //   FirebasePushNotificationService.new,
  // );

  getIt.registerLazySingleton<Api>(
    () => Api(
      dio: getIt<Dio>(),
      baseUrl:
          'https://api.journey-radar.com', // Replace with your API base URL
    ),
  );

  // Register Repository with mock/real API flag
  getIt.registerLazySingleton<Repository>(
    () => RepositoryImpl(
      useMockApi: useMockApi,
      dio: userDio,
      baseUrl: AppConstants.baseUrl,
    ),
  );
}
