# Service Locator Configuration

## Overview
Główny service locator aplikacji z flagą do przełączania między mock API a prawdziwym API.

## Konfiguracja

### Flaga Mock/Real API
```dart
/// Flag to determine whether to use mock API or real API
/// Set to true for development, false for production
const bool useMockApi = true; // Change to false when ready for real API
```

### Przełączanie między API

#### Mock API (Development)
```dart
const bool useMockApi = true;
```

#### Real API (Production)
```dart
const bool useMockApi = false;
```

## Użycie

### W kodzie
```dart
import 'package:journey_radar_mobile/config/service_locator.dart';

// Pobierz repository z głównego service locator
final repository = getIt<Repository>();
```

### W main.dart
```dart
import 'package:journey_radar_mobile/config/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpServiceLocator();
  runApp(MyApp());
}
```

## Funkcjonalności

### Mock API (useMockApi = true)
- ✅ Używa `MockMapApi` z symulowanymi danymi
- ✅ Realistyczne opóźnienia sieciowe (300ms - 1.5s)
- ✅ Symulacja błędów (3% szansy)
- ✅ 5 punktów na mapie + 3 trasy autobusowe

### Real API (useMockApi = false)
- ✅ Używa prawdziwego API
- ✅ Wymaga skonfigurowanego Dio i baseUrl
- ✅ Połączenie z prawdziwym backendem

## Implementacja Real API

Gdy będziesz gotowy na prawdziwy API:

1. **Zmień flagę:**
```dart
const bool useMockApi = false;
```

2. **Zaimplementuj metody `_*FromRealApi` w `RepositoryImpl`**

3. **Skonfiguruj prawdziwy API endpoint w `AppConstants.baseUrl`**

## Zalety

- ✅ **Jeden service locator** dla całej aplikacji
- ✅ **Łatwe przełączanie** przez jedną flagę
- ✅ **Brak duplikacji kodu**
- ✅ **Prosta konfiguracja**
- ✅ **Gotowe do implementacji** prawdziwego API

## Pliki

- `lib/config/service_locator.dart` - Główny service locator
- `lib/repositories/repository_impl.dart` - Repository implementation
- `lib/api/mock_map_api.dart` - Mock API service
- `lib/features/map_page_with_api.dart` - Przykład użycia
