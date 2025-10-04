import 'package:flutter/material.dart';
import 'package:journey_radar_mobile/config/service_locator.dart';
import 'package:journey_radar_mobile/storage/user_storage.dart';

class LanguageProvider with ChangeNotifier {
  Locale _currentLocale;

  LanguageProvider({required String initialLanguage})
      : _currentLocale = Locale(initialLanguage);

  Locale get currentLocale => _currentLocale;

  Future<void> changeLanguage(String languageCode) async {
    _currentLocale = Locale(languageCode);
    await getIt<UserStorage>().saveUserLanguage(languageCode);
    notifyListeners();
  }
}
