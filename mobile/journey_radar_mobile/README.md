# Journey Radar Mobile

Aplikacja mobilna Flutter dla systemu Android. Ta aplikacja została zbudowana przy użyciu Flutter - technologii cross-platform, która w przyszłości może być łatwo rozszerzona o wsparcie dla iOS.

## 🛠️ Wymagania

Przed zainstalowaniem tej aplikacji musisz skonfigurować następujące narzędzia na swoim komputerze:

### Wymagane Oprogramowanie

1. **Flutter SDK** (Wersja 3.24.5 lub kompatybilna)
2. **Android Studio** (Zalecana najnowsza wersja)
3. **Android SDK** (Zawarty w Android Studio)
4. **Java Development Kit (JDK)** (Wersja 11 lub wyższa)

## 📋 Przewodnik Instalacji

### Krok 1: Instalacja Flutter SDK

1. **Pobierz Flutter:**
   - Przejdź na stronę [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
   - Pobierz Flutter SDK dla swojego systemu operacyjnego
   - Wypakuj pobrany plik do lokalizacji takiej jak `C:\flutter` (Windows) lub `/Users/twojanazwa/flutter` (macOS/Linux)

2. **Dodaj Flutter do zmiennej PATH:**
   - **Windows:** Dodaj `C:\flutter\bin` do zmiennej środowiskowej PATH
   - **macOS/Linux:** Dodaj `/Users/twojanazwa/flutter/bin` do PATH w pliku profilu powłoki (`.bashrc`, `.zshrc`, itp.)

3. **Sprawdź Instalację:**
   - Otwórz terminal/wiersz poleceń
   - Uruchom: `flutter --version`
   - Powinieneś zobaczyć Flutter 3.24.5 lub kompatybilną wersję

### Krok 2: Instalacja Android Studio

1. **Pobierz Android Studio:**
   - Przejdź na stronę [https://developer.android.com/studio](https://developer.android.com/studio)
   - Pobierz i zainstaluj Android Studio

2. **Skonfiguruj Android SDK:**
   - Otwórz Android Studio
   - Przejdź do **Tools** → **SDK Manager**
   - Zainstaluj najnowszą platformę Android SDK
   - Zainstaluj Android SDK Build-Tools
   - Zainstaluj Android SDK Platform-Tools

3. **Skonfiguruj Emulator Android (Opcjonalnie):**
   - W Android Studio przejdź do **Tools** → **AVD Manager**
   - Kliknij **Create Virtual Device**
   - Wybierz urządzenie (np. Pixel 4) i wersję Android (API 30+)
   - Kliknij **Finish** aby utworzyć emulator

### Krok 3: Instalacja Java Development Kit (JDK)

1. **Pobierz JDK:**
   - Przejdź na stronę [https://www.oracle.com/java/technologies/downloads/](https://www.oracle.com/java/technologies/downloads/)
   - Pobierz JDK 11 lub wyższą dla swojego systemu operacyjnego
   - Zainstaluj JDK

2. **Ustaw JAVA_HOME:**
   - **Windows:** Ustaw zmienną środowiskową JAVA_HOME na ścieżkę instalacji JDK
   - **macOS/Linux:** Dodaj `export JAVA_HOME=/ścieżka/do/jdk` do pliku profilu powłoki

### Krok 4: Instalacja Aplikacji Journey Radar Mobile

1. **Pobierz Projekt:**
   - Pobierz lub sklonuj ten projekt na swój komputer
   - Przejdź do folderu projektu w terminalu/wierszu poleceń

2. **Zainstaluj Zależności:**
   ```bash
   flutter pub get
   ```

3. **Wygeneruj Tłumaczenia (jeśli potrzebne):**
   ```bash
   dart run easy_localization:generate -S "assets/translations" -O "lib/generated" -f keys -o locale_keys.g.dart
   ```

4. **Uruchom Aplikację:**
   
   **Opcja A: Na Emulatorze Android**
   - Uruchom emulator Android z Android Studio
   - Uruchom: `flutter run`
   
   **Opcja B: Na Fizycznym Urządzeniu Android**
   - Włącz **Opcje Deweloperskie** na swoim telefonie Android:
     - Przejdź do **Ustawienia** → **O telefonie**
     - Dotknij **Numer kompilacji** 7 razy
   - Włącz **Debugowanie USB** w Opcjach Deweloperskich
   - Podłącz telefon do komputera przez USB
   - Uruchom: `flutter run`

## 🚀 Uruchamianie Aplikacji

1. **Uruchom Android Studio** i otwórz folder projektu
2. **Podłącz urządzenie Android** lub uruchom emulator
3. **Kliknij przycisk Run** (zielona ikona odtwarzania) w Android Studio, lub użyj `flutter run` w terminalu
4. Aplikacja zostanie zainstalowana i uruchomiona na Twoim urządzeniu/emulatorze

## 🔧 Rozwiązywanie Problemów

### Częste Problemy:

1. **"flutter: command not found"**
   - Upewnij się, że Flutter jest dodany do zmiennej środowiskowej PATH
   - Uruchom ponownie terminal/wiersz poleceń

2. **"No connected devices"**
   - Upewnij się, że debugowanie USB jest włączone na urządzeniu Android
   - Spróbuj uruchomić `flutter devices` aby zobaczyć podłączone urządzenia

3. **Błędy kompilacji**
   - Uruchom `flutter clean` a następnie `flutter pub get`
   - Upewnij się, że masz zainstalowaną odpowiednią wersję Android SDK

4. **Problemy z Gradle**
   - W Android Studio przejdź do **File** → **Sync Project with Gradle Files**

## 📱 Wymagania Urządzenia

- **Wersja Android:** Android 5.0 (poziom API 21) lub wyższa
- **RAM:** Minimum 2GB, zalecane 4GB
- **Pamięć:** 100MB wolnego miejsca
- **Uprawnienia:** Lokalizacja, Kamera, Pamięć (w zależności od potrzeb aplikacji)

## 🔮 Przyszłe Wsparcie dla iOS

Ta aplikacja została zbudowana przy użyciu Flutter - technologii cross-platform. Oznacza to, że przy minimalnej dodatkowej pracy deweloperskiej aplikacja może być rozszerzona o wsparcie dla urządzeń iOS. Podstawowa logika biznesowa, komponenty UI i większość funkcji będą działać bezproblemowo na iOS z tylko drobnymi dostosowaniami specyficznymi dla platformy.

## 📞 Wsparcie

Jeśli napotkasz problemy podczas instalacji lub masz pytania dotyczące aplikacji, skonsultuj się z:
- [Dokumentacja Flutter](https://flutter.dev/docs)
- [Dokumentacja Android Studio](https://developer.android.com/studio/intro)

---

**Uwaga:** Ten przewodnik instalacji jest przeznaczony dla użytkowników nietechnicznych. Jeśli jesteś deweloperem, możesz używać standardowego przepływu pracy Flutter z preferowanym IDE.