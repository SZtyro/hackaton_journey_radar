// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters, constant_identifier_names

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> _pl = {
  "hello": "Cześć",
  "noInternet": "Brak połączenia z internetem",
  "unexpectedError": "Nieoczekiwany błąd",
  "failedConnectionWithServer": "Nie udało się połączyć z serwerem",
  "serverError": "Błąd serwera",
  "myLocation": "Moja lokalizacja",
  "refresh": "Odśwież",
  "loading": "Ładowanie",
  "alignNorth": "Wyrównaj na północ",
  "zoomIn": "Przybliż",
  "zoomOut": "Oddal",
  "coordinates": "Współrzędne",
  "createdAt": "Utworzono",
  "close": "Zamknij",
  "error": "Błąd",
  "schedule": "Rozkład jazdy"
};
static const Map<String,dynamic> _en = {
  "hello": "Hello",
  "noInternet": "No internet connection",
  "unexpectedError": "Unexpected error",
  "failedConnectionWithServer": "Failed to connect with server",
  "serverError": "Server error",
  "myLocation": "My Location",
  "refresh": "Refresh",
  "loading": "Loading",
  "alignNorth": "Align to north",
  "zoomIn": "Zoom in",
  "zoomOut": "Zoom out",
  "coordinates": "Coordinates",
  "createdAt": "Latitude",
  "close": "Close",
  "error": "Error",
  "schedule": "Schedule"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"pl": _pl, "en": _en};
}
