# ExpressiveMarker

Generyczny marker zgodny z Material Design 3 expressive, z skalowalnością opartą na `AppSpacing`.

## Funkcje

- ✅ **Material Design 3 expressive** - nowoczesny wygląd zgodny z wytycznymi
- ✅ **Skalowalność** - używa `AppSpacing` do responsywnych rozmiarów
- ✅ **Animacje** - płynne przejścia i efekty hover
- ✅ **Generyczność** - obsługuje różne typy markerów
- ✅ **Predefiniowane style** - gotowe style dla różnych typów punktów
- ✅ **Customizacja** - pełna kontrola nad wyglądem

## Użycie

### Podstawowe użycie

```dart
import 'package:journey_radar_mobile/features/map/widgets/widgets.dart';

// Marker lokalizacji użytkownika
final userMarker = MarkerStyles.userLocation(
  point: LatLng(50.0647, 19.9450),
  onTap: () => print('User location tapped'),
);

// Marker punktu mapy
final mapPointMarker = MarkerStyles.mapPoint(
  point: LatLng(50.0647, 19.9450),
  onTap: () => print('Map point tapped'),
  iconData: Icons.restaurant,
  backgroundColor: Colors.orange,
);

// Marker przystanku autobusowego
final busStopMarker = MarkerStyles.busStop(
  point: LatLng(50.0647, 19.9450),
  onTap: () => print('Bus stop tapped'),
);

// Marker zabytku
final landmarkMarker = MarkerStyles.landmark(
  point: LatLng(50.0647, 19.9450),
  onTap: () => print('Landmark tapped'),
);
```

### Zaawansowane użycie

```dart
// Custom marker z pełną kontrolą
final customMarker = ExpressiveMarkerHelper.createMarker(
  point: LatLng(50.0647, 19.9450),
  onTap: () => print('Custom marker tapped'),
  iconData: Icons.star,
  backgroundColor: Colors.purple,
  borderColor: Colors.white,
  size: MarkerSize.large,
  isSelected: true,
  elevation: 8.0,
  shadowBlur: 12.0,
  shadowSpread: 3.0,
);
```

### Rozmiary markerów

```dart
enum MarkerSize {
  extraSmall,  // 32px - AppSpacing.l
  small,        // 40px - AppSpacing.xl
  medium,       // 48px - AppSpacing.xxl (domyślny)
  large,        // 56px - AppSpacing.xxxl
  extraLarge,   // 64px - AppSpacing.xxxxl
}
```

### Integracja z flutter_map

```dart
FlutterMap(
  options: MapOptions(
    initialCenter: LatLng(50.0647, 19.9450),
    initialZoom: 13.0,
  ),
  children: [
    TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    ),
    MarkerLayer(
      markers: [
        MarkerStyles.userLocation(
          point: userLocation,
          onTap: () => _showUserInfo(),
        ),
        ...mapPoints.map((point) => MarkerStyles.mapPoint(
          point: point.position,
          onTap: () => _showPointInfo(point),
          iconData: _getIconForType(point.iconType),
          backgroundColor: _parseColor(point.color),
        )),
      ],
    ),
  ],
)
```

## Material Design 3 Expressive

Markery są zaprojektowane zgodnie z wytycznymi Material Design 3 expressive:

- **Kolory** - używają `ColorScheme` z motywu aplikacji
- **Cienie** - realistyczne cienie z `elevation`
- **Animacje** - płynne przejścia między stanami
- **Skalowalność** - responsywne rozmiary oparte na `AppSpacing`
- **Dostępność** - odpowiednie kontrasty i rozmiary dotykowe

## Customizacja

### Kolory
```dart
final marker = ExpressiveMarkerHelper.createMarker(
  point: point,
  onTap: onTap,
  backgroundColor: Colors.red,      // Kolor tła
  borderColor: Colors.white,        // Kolor obramowania
  color: Colors.white,             // Kolor ikony
);
```

### Rozmiary i cienie
```dart
final marker = ExpressiveMarkerHelper.createMarker(
  point: point,
  onTap: onTap,
  size: MarkerSize.large,          // Rozmiar markera
  elevation: 8.0,                 // Wysokość cienia
  shadowBlur: 12.0,               // Rozmycie cienia
  shadowSpread: 3.0,              // Rozprzestrzenienie cienia
);
```

### Animacje
```dart
final marker = ExpressiveMarkerHelper.createMarker(
  point: point,
  onTap: onTap,
  isAnimated: true,               // Włącz animacje
  animationDuration: Duration(milliseconds: 300), // Czas animacji
);
```
