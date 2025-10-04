// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:journey_radar_mobile/config/constants.dart';
import 'package:journey_radar_mobile/storage/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  UserStorage({
    required this.storage,
    required this.sharedPreferences,
  });

  final Storage storage;
  final SharedPreferences sharedPreferences;

  Future<void> deleteUserName() async {
    await storage.delete(
      key: StorageKeys.userName,
    );
  }

  Future<String?> getUserLanguage() async {
    return storage.read(key: StorageKeys.userLanguage);
  }

  Future<void> saveUserLanguage(String languageCode) async {
    await storage.write(key: StorageKeys.userLanguage, value: languageCode);
  }

  Future<void> deleteUserLanguage() async {
    await storage.delete(
      key: StorageKeys.userLanguage,
    );
  }

  Future<bool> getHasAskedPush() async {
    final hasAskedPush = await storage.read(key: StorageKeys.hasAskedPush);
    if (hasAskedPush != null && hasAskedPush.contains('true')) {
      return true;
    }
    return false;
  }

  Future<void> saveHasAskedPush({
    required bool hasAskedPush,
  }) async {
    final value = hasAskedPush ? 'true' : 'false';
    await storage.write(key: StorageKeys.hasAskedPush, value: value);
  }

  Future<void> deleteHasAskedPush() async {
    await storage.delete(
      key: StorageKeys.hasAskedPush,
    );
  }

  Future<bool> getIsFirstLaunch() async {
    final isFirstLaunch = sharedPreferences.getBool(
          StorageKeys.firstLaunchKey,
        ) ??
        true;
    return isFirstLaunch;
  }

  Future<void> setIsFirstLaunch() async {
    await sharedPreferences.setBool(
      StorageKeys.firstLaunchKey,
      false,
    );
  }

  Future<void> clearSecureStorageOnFirstLaunch() async {
    final isFirstLaunch = await getIsFirstLaunch();

    if (isFirstLaunch) {
      await storage.clear();
      await setIsFirstLaunch();
    }
  }
}
