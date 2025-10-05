# Przewodnik implementacji funkcjonalności GTFS

## ✅ **Co masz dostępne do rysowania tras i przystanków:**

### 1. **Dane do rysowania tras na mapie:**
```dart
// Z GtfsRouteEntity masz:
- routeId: String
- routeShortName: String? (np. "15")
- routeLongName: String? (np. "Centrum - Dworzec")
- routeColor: String? (hex color)
- routeType: int (0=tramwaj, 1=metro, 3=autobus)

// Z GtfsShapeEntity masz punkty trasy:
- shapeId: String
- position: LatLng (współrzędne punktu trasy)
- sequence: int (kolejność na trasie)
- distanceTraveled: double? (dystans od początku)
```

### 2. **Dane do rysowania przystanków:**
```dart
// Z GtfsStopEntity masz:
- stopId: String
- stopName: String
- position: LatLng (współrzędne przystanku)
- stopCode: String? (kod przystanku)
- wheelchairBoarding: int? (dostępność)
- platformCode: String? (kod peronu)
```

### 3. **Dane do rozkładu jazdy z opóźnieniami:**
```dart
// Z GtfsScheduleWithDelaysEntity masz:
- stopId, stopName: String
- routeId, routeShortName, routeLongName, routeColor: String
- tripId, tripHeadsign: String
- scheduledArrivalTime, scheduledDepartureTime: String?
- realTimeArrivalTime, realTimeDepartureTime: String?
- delaySeconds: int? (opóźnienie w sekundach)
- delayType: String? ("arrival" lub "departure")
- delayReason: String? (powód opóźnienia)
- isRealTime: bool (czy dane w czasie rzeczywistym)
```

## 🎯 **Implementacja funkcjonalności:**

### 1. **Rysowanie tras na mapie:**
```dart
// W MapPage dodaj:
PolylineLayer(
  polylines: [
    Polyline(
      points: routeShapes.map((shape) => shape.position).toList(),
      color: _parseColor(route.routeColor ?? '#000000'),
      strokeWidth: 4.0,
    ),
  ],
)
```

### 2. **Rysowanie przystanków:**
```dart
// W MapPage dodaj:
MarkerLayer(
  markers: stops.map((stop) => Marker(
    point: stop.position,
    child: GestureDetector(
      onTap: () => _showStopSchedule(stop),
      child: Icon(
        Icons.directions_bus,
        color: Colors.blue,
        size: 20,
      ),
    ),
  )).toList(),
)
```

### 3. **Pokazywanie opóźnień na trasie:**
```dart
// Dodaj kolorowanie segmentów trasy na podstawie opóźnień:
Polyline(
  points: segmentPoints,
  color: _getDelayColor(delaySeconds),
  strokeWidth: _getDelayStrokeWidth(delaySeconds),
)

Color _getDelayColor(int? delaySeconds) {
  if (delaySeconds == null) return Colors.green;
  if (delaySeconds <= 0) return Colors.green;
  if (delaySeconds <= 300) return Colors.orange; // 5 min
  return Colors.red; // > 5 min
}
```

### 4. **Rozkład jazdy na przystanku:**
```dart
// Stwórz nową stronę SchedulePage:
class SchedulePage extends StatelessWidget {
  final GtfsStopEntity stop;
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: state.schedules.length,
          itemBuilder: (context, index) {
            final schedule = state.schedules[index];
            return ScheduleTile(
              schedule: schedule,
              onTap: () => _showTripDetails(schedule),
            );
          },
        );
      },
    );
  }
}
```

### 5. **Tile rozkładu jazdy:**
```dart
class ScheduleTile extends StatelessWidget {
  final GtfsScheduleWithDelaysEntity schedule;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _parseColor(schedule.routeColor ?? '#000000'),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              schedule.routeShortName ?? '',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(schedule.routeLongName ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kierunek: ${schedule.tripHeadsign ?? ''}'),
            if (schedule.delaySeconds != null && schedule.delaySeconds! > 0)
              Text(
                'Opóźnienie: ${_formatDelay(schedule.delaySeconds!)}',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              schedule.realTimeArrivalTime ?? schedule.scheduledArrivalTime ?? '',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            if (schedule.isRealTime)
              Icon(Icons.access_time, color: Colors.green, size: 16),
          ],
        ),
      ),
    );
  }
}
```

## 🔧 **Rozszerzenia MapCubit:**

```dart
// Dodaj do MapCubit:
Future<void> getRouteShapes(String routeId) async {
  // Pobierz punkty trasy dla danej linii
}

Future<void> getStopsForRoute(String routeId) async {
  // Pobierz przystanki dla danej linii
}

Future<void> getScheduleForStop(String stopId) async {
  // Pobierz rozkład jazdy dla przystanku
}

Future<void> getDelaysForRoute(String routeId) async {
  // Pobierz opóźnienia dla linii
}
```

## 🎨 **Wizualizacja opóźnień:**

### 1. **Kolorowanie tras:**
- 🟢 Zielony: Brak opóźnień
- 🟠 Pomarańczowy: Opóźnienie 1-5 min
- 🔴 Czerwony: Opóźnienie > 5 min

### 2. **Ikony przystanków:**
- 🚌 Zwykły przystanek
- ♿ Dostępny dla wózków
- 🚫 Zamknięty
- ⚠️ Opóźnienia

### 3. **Informacje o opóźnieniach:**
- Czas rzeczywisty vs planowany
- Powód opóźnienia
- Przewidywany czas przyjazdu
- Status pojazdu

## 📱 **Przepływ użytkownika:**

1. **Mapa** → Wyświetla wszystkie linie i przystanki
2. **Kliknięcie na linię** → Podświetla trasę, pokazuje opóźnienia
3. **Kliknięcie na przystanek** → Przejście do rozkładu jazdy
4. **Rozkład jazdy** → Lista najbliższych odjazdów z opóźnieniami
5. **Kliknięcie na kurs** → Szczegóły trasy, wszystkie przystanki

## 🚀 **Następne kroki:**

1. **Wygeneruj pliki .g.dart:** `flutter packages pub run build_runner build`
2. **Rozszerz MapCubit** o nowe metody
3. **Stwórz SchedulePage** dla rozkładu jazdy
4. **Dodaj wizualizację opóźnień** na mapie
5. **Zaimplementuj nawigację** między ekranami
6. **Dodaj odświeżanie danych** w czasie rzeczywistym
