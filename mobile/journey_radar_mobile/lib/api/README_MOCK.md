# Mock API Documentation

## Overview
Prosty mock API service, który symuluje połączenie z backendem dla rozwoju i testowania.

## Funkcjonalności

### 🎯 **Symulacja Backendu**
- **Realistyczne opóźnienia sieciowe** (300ms - 1.5s)
- **Symulacja błędów** (3% szansy na błąd)
- **Pełne CRUD operations** dla punktów i tras
- **Wyszukiwanie i filtrowanie**
- **Lokalizacja w pobliżu**

### 📊 **Mock Dane**
- **5 Map Points**: Rynek Główny, Przystanek autobusowy, Restauracja, Galeria Krakowska, Wawel
- **3 Bus Routes**: Linie 1, 2, 3 z różnymi kolorami i koordynatami
- **Realistyczne współrzędne** w Krakowie
- **Rich metadata**: Opisy, akcje przycisków, timestamps

## Użycie

### Podstawowa konfiguracja
```dart
import 'package:journey_radar_mobile/config/mock_service_locator.dart';
import 'package:get_it/get_it.dart';

// Konfiguracja mock services
MockServiceLocator.configure(GetIt.instance);

// Pobierz repository
final repository = GetIt.instance<Repository>();
```

### Przykładowe operacje
```dart
// Pobierz punkty z mapy
final result = await repository.getMapPoints();
if (result is Success<List<MapPointEntity>, Exception>) {
  final points = result.data;
  // Użyj punktów
}

// Wyszukaj punkty
final searchResult = await repository.searchMapPoints(
  query: 'Rynek',
  limit: 10,
);

// Pobierz punkty w pobliżu
final nearbyResult = await repository.getNearbyMapPoints(
  location: LatLng(50.0647, 19.9450),
  radius: 1.0, // 1km
);
```

### Obsługa błędów
```dart
final result = await repository.getMapPoints();
if (result is Success<List<MapPointEntity>, Exception>) {
  // Obsługa sukcesu
  final points = result.data;
} else if (result is Failure<List<MapPointEntity>, Exception>) {
  // Obsługa błędu
  final error = result.error;
  print('Błąd: $error');
}
```

## Przełączanie na prawdziwy API

Gdy będziesz gotowy na prawdziwy backend:
1. Zastąp `MockServiceLocator` prawdziwym service locator
2. Zaimplementuj prawdziwy API service
3. **Kod UI pozostaje bez zmian!**

## Pliki

- `lib/api/mock_map_api.dart` - Mock API service
- `lib/repositories/mock_repository_impl.dart` - Mock repository implementation
- `lib/config/mock_service_locator.dart` - Service locator configuration
- `lib/features/map_page_with_api.dart` - Przykład użycia

## Mock Dane

### Punkty na mapie:
1. **Rynek Główny** - Landmark, zielony
2. **Przystanek autobusowy** - Bus stop, pomarańczowy
3. **Restauracja Pod Aniołami** - Restaurant, różowy
4. **Galeria Krakowska** - Shopping, fioletowy
5. **Zamek Królewski na Wawelu** - Landmark, czerwony

### Trasy autobusowe:
1. **Linia 1** - Czerwona, główna linia komunikacyjna
2. **Linia 2** - Niebieska, linia okrężna
3. **Linia 3** - Zielona, północ-południe

## Zalety

- ✅ **Szybki rozwój** bez backendu
- ✅ **Realistyczne opóźnienia** sieciowe
- ✅ **Symulacja błędów** dla testowania
- ✅ **Łatwe przełączanie** na prawdziwy API
- ✅ **Brak zmian** w kodzie UI
