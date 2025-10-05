# Dokumentacja danych GTFS dla rozkładu jazdy

## Podstawowe modele GTFS

### 1. GtfsStopDto/Entity - Przystanki
**Dostępne dane:**
- `stopId` - Unikalny identyfikator przystanku
- `stopCode` - Kod przystanku (opcjonalny)
- `stopName` - Nazwa przystanku
- `stopDesc` - Opis przystanku (opcjonalny)
- `position` (LatLng) - Współrzędne geograficzne
- `zoneId` - Strefa taryfowa (opcjonalny)
- `stopUrl` - URL do strony przystanku (opcjonalny)
- `locationType` - Typ lokalizacji (0=przystanek, 1=stacja, 2=wejście/wyjście)
- `parentStation` - Stacja nadrzędna (opcjonalny)
- `stopTimezone` - Strefa czasowa (opcjonalny)
- `wheelchairBoarding` - Dostępność dla wózków (0=nieznane, 1=dostępne, 2=niedostępne)
- `levelId` - Poziom w budynku (opcjonalny)
- `platformCode` - Kod peronu (opcjonalny)

### 2. GtfsRouteDto/Entity - Linie
**Dostępne dane:**
- `routeId` - Unikalny identyfikator linii
- `agencyId` - ID przewoźnika (opcjonalny)
- `routeShortName` - Krótka nazwa linii (np. "15")
- `routeLongName` - Długa nazwa linii (np. "Centrum - Dworzec")
- `routeDesc` - Opis linii (opcjonalny)
- `routeType` - Typ transportu (0=tramwaj, 1=metro, 3=autobus, 7=funicular, 11=trolleybus, 12=monorail)
- `routeUrl` - URL do strony linii (opcjonalny)
- `routeColor` - Kolor linii w formacie hex (opcjonalny)
- `routeTextColor` - Kolor tekstu w formacie hex (opcjonalny)
- `routeSortOrder` - Kolejność sortowania (opcjonalny)
- `continuousPickup` - Ciągły odbiór pasażerów (opcjonalny)
- `continuousDropOff` - Ciągłe wysadzanie pasażerów (opcjonalny)
- `networkId` - ID sieci transportowej (opcjonalny)

### 3. GtfsTripDto/Entity - Przejazdy
**Dostępne dane:**
- `routeId` - ID linii
- `serviceId` - ID rozkładu (dni tygodnia)
- `tripId` - Unikalny identyfikator przejazdu
- `tripHeadsign` - Kierunek przejazdu (opcjonalny)
- `tripShortName` - Krótka nazwa przejazdu (opcjonalny)
- `directionId` - Kierunek (0=w jedną stronę, 1=w drugą stronę)
- `blockId` - ID bloku pojazdu (opcjonalny)
- `shapeId` - ID kształtu trasy (opcjonalny)
- `wheelchairAccessible` - Dostępność dla wózków (0=nieznane, 1=dostępne, 2=niedostępne)
- `bikesAllowed` - Czy rowery dozwolone (0=nieznane, 1=dozwolone, 2=zabronione)
- `tripRouteType` - Typ trasy przejazdu (opcjonalny)
- `tripPatternId` - ID wzorca przejazdu (opcjonalny)

### 4. GtfsStopTimeDto/Entity - Czasy na przystankach
**Dostępne dane:**
- `tripId` - ID przejazdu
- `arrivalTime` - Czas przyjazdu (format HH:MM:SS)
- `departureTime` - Czas odjazdu (format HH:MM:SS)
- `stopId` - ID przystanku
- `stopSequence` - Kolejność na trasie
- `stopHeadsign` - Kierunek na przystanku (opcjonalny)
- `pickupType` - Typ odbioru (0=regularny, 1=brak, 2=telefon, 3=przewoźnik)
- `dropOffType` - Typ wysadzenia (0=regularny, 1=brak, 2=telefon, 3=przewoźnik)
- `continuousPickup` - Ciągły odbiór (opcjonalny)
- `continuousDropOff` - Ciągłe wysadzanie (opcjonalny)
- `shapeDistTraveled` - Dystans od początku trasy (opcjonalny)
- `timepoint` - Czy punkt czasowy (0=przybliżony, 1=dokładny)

### 5. GtfsScheduleDto/Entity - Rozkład jazdy na przystanku
**Dostępne dane (połączone z powyższych tabel):**
- `stopId` + `stopName` - Informacje o przystanku
- `routeId` + `routeShortName` + `routeLongName` + `routeColor` - Informacje o linii
- `tripId` + `tripHeadsign` - Informacje o przejazdzie
- `arrivalTime` + `departureTime` - Czasy
- `stopSequence` - Kolejność na trasie
- `directionId` - Kierunek
- `wheelchairAccessible` + `bikesAllowed` - Dostępność
- `serviceId` - ID rozkładu (dni tygodnia)

## Dodatkowe dane GTFS, które można dodać:

### 1. Agency (Przewoźnicy)
- `agencyId` - ID przewoźnika
- `agencyName` - Nazwa przewoźnika
- `agencyUrl` - Strona internetowa
- `agencyTimezone` - Strefa czasowa
- `agencyLang` - Język
- `agencyPhone` - Telefon
- `agencyFareUrl` - URL do taryf

### 2. Calendar (Kalendarz)
- `serviceId` - ID rozkładu
- `monday` - Poniedziałek (0/1)
- `tuesday` - Wtorek (0/1)
- `wednesday` - Środa (0/1)
- `thursday` - Czwartek (0/1)
- `friday` - Piątek (0/1)
- `saturday` - Sobota (0/1)
- `sunday` - Niedziela (0/1)
- `startDate` - Data rozpoczęcia
- `endDate` - Data zakończenia

### 3. Calendar Dates (Wyjątki w kalendarzu)
- `serviceId` - ID rozkładu
- `date` - Data
- `exceptionType` - Typ wyjątku (1=dodany, 2=usunięty)

### 4. Fare Attributes (Taryfy)
- `fareId` - ID taryfy
- `price` - Cena
- `currencyType` - Waluta
- `paymentMethod` - Metoda płatności
- `transfers` - Liczba przesiadek
- `transferDuration` - Czas na przesiadkę

### 5. Fare Rules (Zasady taryf)
- `fareId` - ID taryfy
- `routeId` - ID linii
- `originId` - ID strefy początkowej
- `destinationId` - ID strefy docelowej
- `containsId` - ID strefy zawierającej

### 6. Shapes (Kształty tras)
- `shapeId` - ID kształtu
- `shapePtLat` - Szerokość geograficzna punktu
- `shapePtLon` - Długość geograficzna punktu
- `shapePtSequence` - Kolejność punktu
- `shapeDistTraveled` - Dystans od początku

### 7. Frequencies (Częstotliwość)
- `tripId` - ID przejazdu
- `startTime` - Czas rozpoczęcia
- `endTime` - Czas zakończenia
- `headwaySecs` - Interwał w sekundach
- `exactTimes` - Czy dokładne czasy (0/1)

### 8. Transfers (Przesiadki)
- `fromStopId` - ID przystanku początkowego
- `toStopId` - ID przystanku docelowego
- `transferType` - Typ przesiadki (0=rekomendowana, 1=możliwa, 2=brak, 3=minimalny czas)
- `minTransferTime` - Minimalny czas przesiadki

## Możliwości rozszerzenia rozkładu jazdy:

### 1. Informacje o dostępności
- Dostępność dla wózków inwalidzkich
- Dostępność dla rowerów
- Dostępność dla osób z niepełnosprawnościami wzroku/słuchu

### 2. Informacje o taryfach
- Ceny biletów
- Strefy taryfowe
- Możliwości przesiadek
- Czas ważności biletów

### 3. Informacje o przewoźniku
- Nazwa przewoźnika
- Strona internetowa
- Numer telefonu
- Strefa czasowa

### 4. Informacje o trasie
- Wizualizacja trasy na mapie
- Długość trasy
- Przewidywany czas podróży
- Punkty przesiadkowe

### 5. Informacje o pojazdach
- Typ pojazdu
- Liczba miejsc
- Klimatyzacja
- WiFi
- USB

### 6. Informacje o opóźnieniach
- Status w czasie rzeczywistym
- Przewidywane opóźnienia
- Przyczyny opóźnień
- Alternatywne trasy

### 7. Informacje o wydarzeniach
- Zmiany w rozkładzie
- Zamknięcia przystanków
- Remonty
- Wydarzenia specjalne
