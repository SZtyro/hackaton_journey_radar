import 'dart:async';
import 'dart:math';
import 'package:latlong2/latlong.dart';
import 'package:journey_radar_mobile/entity/entity.dart';

/// Mock API service that simulates backend responses for development.
class MockMapApi {
  static final Random _random = Random();

  /// Simulate network delay (300ms - 1.5s)
  static Future<void> _simulateDelay() async {
    final delay = 300 + _random.nextInt(1200); // 300ms to 1.5s
    await Future.delayed(Duration(milliseconds: delay));
  }

  /// Simulate occasional network errors (3% chance)
  static bool _shouldSimulateError() {
    return _random.nextInt(100) < 3; // 3% chance of error
  }

  // Mock data
  static final List<MapPointEntity> _mockMapPoints = [
    MapPointEntity(
      id: '1',
      position: const LatLng(50.0647, 19.9450), // Rynek Główny
      title: 'Rynek Główny',
      description: 'Główny plac Krakowa z Sukiennicami i Kościołem Mariackim',
      buttonText: 'Zobacz szczegóły',
      iconType: 'landmark',
      color: '#4CAF50',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    MapPointEntity(
      id: '2',
      position: const LatLng(50.0700, 19.9500), // Przystanek autobusowy
      title: 'Przystanek autobusowy - Rynek',
      description: 'Przystanek linii 1, 2, 3, 4, 5',
      buttonText: 'Sprawdź rozkład',
      iconType: 'bus',
      color: '#FF9800',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    MapPointEntity(
      id: '3',
      position: const LatLng(50.0600, 19.9400), // Restauracja
      title: 'Restauracja Pod Aniołami',
      description: 'Tradycyjna kuchnia polska w zabytkowej kamienicy',
      buttonText: 'Zobacz menu',
      iconType: 'restaurant',
      color: '#E91E63',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    MapPointEntity(
      id: '4',
      position: const LatLng(50.0750, 19.9550), // Sklep
      title: 'Galeria Krakowska',
      description: 'Największe centrum handlowe w Krakowie',
      buttonText: 'Sprawdź godziny',
      iconType: 'shopping',
      color: '#9C27B0',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    MapPointEntity(
      id: '5',
      position: const LatLng(50.0550, 19.9300), // Wawel
      title: 'Zamek Królewski na Wawelu',
      description: 'Siedziba królów polskich, obecnie muzeum',
      buttonText: 'Kup bilety',
      iconType: 'landmark',
      color: '#FF5722',
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
  ];

  static final List<BusRouteEntity> _mockBusRoutes = [
    BusRouteEntity(
      id: '1',
      name: 'Linia 1',
      number: '1',
      color: '#FF5722',
      description: 'Główna linia komunikacyjna Krakowa',
      coordinates: [
        const LatLng(50.0647, 19.9450), // Rynek Główny
        const LatLng(50.0700, 19.9500), // Przystanek 1
        const LatLng(50.0750, 19.9550), // Przystanek 2
        const LatLng(50.0800, 19.9600), // Dworzec Główny
        const LatLng(50.0850, 19.9650), // Przystanek 3
        const LatLng(50.0900, 19.9700), // Przystanek 4
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    BusRouteEntity(
      id: '2',
      name: 'Linia 2',
      number: '2',
      color: '#2196F3',
      description: 'Linia okrężna przez centrum miasta',
      coordinates: [
        const LatLng(50.0600, 19.9400), // Start
        const LatLng(50.0650, 19.9450), // Punkt 1
        const LatLng(50.0700, 19.9500), // Rynek
        const LatLng(50.0750, 19.9550), // Punkt 2
        const LatLng(50.0800, 19.9600), // Dworzec
        const LatLng(50.0750, 19.9650), // Punkt 3
        const LatLng(50.0700, 19.9700), // Punkt 4
        const LatLng(50.0650, 19.9750), // Punkt 5
        const LatLng(50.0600, 19.9800), // Koniec
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
    ),
    BusRouteEntity(
      id: '3',
      name: 'Linia 3',
      number: '3',
      color: '#4CAF50',
      description: 'Linia łącząca północ z południem',
      coordinates: [
        const LatLng(50.0900, 19.9200), // Północ
        const LatLng(50.0850, 19.9250), // Punkt 1
        const LatLng(50.0800, 19.9300), // Punkt 2
        const LatLng(50.0750, 19.9350), // Punkt 3
        const LatLng(50.0700, 19.9400), // Centrum
        const LatLng(50.0650, 19.9450), // Punkt 4
        const LatLng(50.0600, 19.9500), // Punkt 5
        const LatLng(50.0550, 19.9550), // Południe
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
    ),
  ];

  // Map Points API
  static Future<List<MapPointEntity>> getMapPoints({
    int? limit,
    int? offset,
    String? iconType,
  }) async {
    await _simulateDelay();

    if (_shouldSimulateError()) {
      throw Exception('Network error: Unable to fetch map points');
    }

    var points = List<MapPointEntity>.from(_mockMapPoints);

    // Filter by icon type if provided
    if (iconType != null) {
      points = points.where((point) => point.iconType == iconType).toList();
    }

    // Apply pagination
    final startIndex = offset ?? 0;
    final endIndex = limit != null ? startIndex + limit : points.length;

    return points.skip(startIndex).take(endIndex - startIndex).toList();
  }

  static Future<MapPointEntity?> getMapPoint(String id) async {
    await _simulateDelay();

    if (_shouldSimulateError()) {
      throw Exception('Network error: Unable to fetch map point');
    }

    try {
      return _mockMapPoints.firstWhere((point) => point.id == id);
    } catch (e) {
      return null;
    }
  }

  static Future<MapPointEntity> createMapPoint(MapPointEntity mapPoint) async {
    await _simulateDelay();

    if (_shouldSimulateError()) {
      throw Exception('Network error: Unable to create map point');
    }

    // Generate new ID if not provided
    final newId = mapPoint.id.isEmpty ? _generateId() : mapPoint.id;
    final newPoint = mapPoint.copyWith(
      id: newId,
      createdAt: DateTime.now(),
    );

    _mockMapPoints.add(newPoint);
    return newPoint;
  }

  static Future<MapPointEntity?> updateMapPoint(
      String id, MapPointEntity mapPoint) async {
    await _simulateDelay();

    if (_shouldSimulateError()) {
      throw Exception('Network error: Unable to update map point');
    }

    final index = _mockMapPoints.indexWhere((point) => point.id == id);
    if (index != -1) {
      final updatedPoint = mapPoint.copyWith(
        id: id,
        updatedAt: DateTime.now(),
      );
      _mockMapPoints[index] = updatedPoint;
      return updatedPoint;
    }
    return null;
  }

  static Future<bool> deleteMapPoint(String id) async {
    await _simulateDelay();

    if (_shouldSimulateError()) {
      throw Exception('Network error: Unable to delete map point');
    }

    final index = _mockMapPoints.indexWhere((point) => point.id == id);
    if (index != -1) {
      _mockMapPoints.removeAt(index);
      return true;
    }
    return false;
  }

  static Future<List<MapPointEntity>> searchMapPoints({
    required String query,
    int? limit,
    int? offset,
  }) async {
    await _simulateDelay();

    if (_shouldSimulateError()) {
      throw Exception('Network error: Unable to search map points');
    }

    final lowercaseQuery = query.toLowerCase();
    var results = _mockMapPoints.where((point) {
      return point.title.toLowerCase().contains(lowercaseQuery) ||
          (point.description?.toLowerCase().contains(lowercaseQuery) ?? false);
    }).toList();

    // Apply pagination
    final startIndex = offset ?? 0;
    final endIndex = limit != null ? startIndex + limit : results.length;

    return results.skip(startIndex).take(endIndex - startIndex).toList();
  }

  static Future<List<MapPointEntity>> getNearbyMapPoints({
    required LatLng location,
    double? radius,
    int? limit,
  }) async {
    await _simulateDelay();

    if (_shouldSimulateError()) {
      throw Exception('Network error: Unable to fetch nearby map points');
    }

    final searchRadius = radius ?? 1.0; // Default 1km radius
    var results = _mockMapPoints.where((point) {
      final distance = _calculateDistance(location, point.position);
      return distance <= searchRadius;
    }).toList();

    // Apply limit
    if (limit != null && results.length > limit) {
      results = results.take(limit).toList();
    }

    return results;
  }

  // Bus Routes API
  static Future<List<BusRouteEntity>> getBusRoutes({
    int? limit,
    int? offset,
    String? number,
  }) async {
    await _simulateDelay();

    if (_shouldSimulateError()) {
      throw Exception('Network error: Unable to fetch bus routes');
    }

    var routes = List<BusRouteEntity>.from(_mockBusRoutes);

    // Filter by number if provided
    if (number != null) {
      routes = routes.where((route) => route.number == number).toList();
    }

    // Apply pagination
    final startIndex = offset ?? 0;
    final endIndex = limit != null ? startIndex + limit : routes.length;

    return routes.skip(startIndex).take(endIndex - startIndex).toList();
  }

  static Future<BusRouteEntity?> getBusRoute(String id) async {
    await _simulateDelay();

    if (_shouldSimulateError()) {
      throw Exception('Network error: Unable to fetch bus route');
    }

    try {
      return _mockBusRoutes.firstWhere((route) => route.id == id);
    } catch (e) {
      return null;
    }
  }

  static Future<BusRouteEntity> createBusRoute(BusRouteEntity busRoute) async {
    await _simulateDelay();

    if (_shouldSimulateError()) {
      throw Exception('Network error: Unable to create bus route');
    }

    // Generate new ID if not provided
    final newId = busRoute.id.isEmpty ? _generateId() : busRoute.id;
    final newRoute = busRoute.copyWith(
      id: newId,
      createdAt: DateTime.now(),
    );

    _mockBusRoutes.add(newRoute);
    return newRoute;
  }

  static Future<BusRouteEntity?> updateBusRoute(
      String id, BusRouteEntity busRoute) async {
    await _simulateDelay();

    if (_shouldSimulateError()) {
      throw Exception('Network error: Unable to update bus route');
    }

    final index = _mockBusRoutes.indexWhere((route) => route.id == id);
    if (index != -1) {
      final updatedRoute = busRoute.copyWith(
        id: id,
        updatedAt: DateTime.now(),
      );
      _mockBusRoutes[index] = updatedRoute;
      return updatedRoute;
    }
    return null;
  }

  static Future<bool> deleteBusRoute(String id) async {
    await _simulateDelay();

    if (_shouldSimulateError()) {
      throw Exception('Network error: Unable to delete bus route');
    }

    final index = _mockBusRoutes.indexWhere((route) => route.id == id);
    if (index != -1) {
      _mockBusRoutes.removeAt(index);
      return true;
    }
    return false;
  }

  static Future<List<BusRouteEntity>> searchBusRoutes({
    required String query,
    int? limit,
    int? offset,
  }) async {
    await _simulateDelay();

    if (_shouldSimulateError()) {
      throw Exception('Network error: Unable to search bus routes');
    }

    final lowercaseQuery = query.toLowerCase();
    var results = _mockBusRoutes.where((route) {
      return route.name.toLowerCase().contains(lowercaseQuery) ||
          route.number.toLowerCase().contains(lowercaseQuery) ||
          route.description.toLowerCase().contains(lowercaseQuery);
    }).toList();

    // Apply pagination
    final startIndex = offset ?? 0;
    final endIndex = limit != null ? startIndex + limit : results.length;

    return results.skip(startIndex).take(endIndex - startIndex).toList();
  }

  static Future<List<BusRouteEntity>> getNearbyBusRoutes({
    required LatLng location,
    double? radius,
    int? limit,
  }) async {
    await _simulateDelay();

    if (_shouldSimulateError()) {
      throw Exception('Network error: Unable to fetch nearby bus routes');
    }

    final searchRadius = radius ?? 2.0; // Default 2km radius for bus routes
    var results = _mockBusRoutes.where((route) {
      // Check if any coordinate in the route is within radius
      return route.coordinates.any((coord) {
        final distance = _calculateDistance(location, coord);
        return distance <= searchRadius;
      });
    }).toList();

    // Apply limit
    if (limit != null && results.length > limit) {
      results = results.take(limit).toList();
    }

    return results;
  }

  /// Calculate distance between two points in kilometers
  static double _calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371; // Earth's radius in kilometers
    final double lat1Rad = point1.latitude * (pi / 180);
    final double lat2Rad = point2.latitude * (pi / 180);
    final double deltaLat = (point2.latitude - point1.latitude) * (pi / 180);
    final double deltaLng = (point2.longitude - point1.longitude) * (pi / 180);

    final double a = sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(deltaLng / 2) * sin(deltaLng / 2);
    final double c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }

  /// Generate a random ID for new entities
  static String _generateId() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
          8, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

  // GTFS Mock data
  static final List<GtfsRouteEntity> _mockGtfsRoutes = [
    GtfsRouteEntity(
      routeId: 'route_1',
      routeShortName: '15',
      routeLongName: 'Centrum - Dworzec Główny',
      routeType: 3, // Bus
      routeColor: '#FF5722',
      routeTextColor: '#FFFFFF',
    ),
    GtfsRouteEntity(
      routeId: 'route_2',
      routeShortName: '22',
      routeLongName: 'Nowa Huta - Centrum',
      routeType: 3, // Bus
      routeColor: '#2196F3',
      routeTextColor: '#FFFFFF',
    ),
    GtfsRouteEntity(
      routeId: 'route_3',
      routeShortName: '1',
      routeLongName: 'Tramwaj - Okrężna',
      routeType: 0, // Tram
      routeColor: '#4CAF50',
      routeTextColor: '#FFFFFF',
    ),
  ];

  static final List<GtfsStopEntity> _mockGtfsStops = [
    GtfsStopEntity(
      stopId: 'stop_1',
      stopName: 'Rynek Główny',
      position: const LatLng(50.0647, 19.9450),
      stopCode: 'R001',
      wheelchairBoarding: 1, // Available
    ),
    GtfsStopEntity(
      stopId: 'stop_2',
      stopName: 'Dworzec Główny',
      position: const LatLng(50.0700, 19.9500),
      stopCode: 'D001',
      wheelchairBoarding: 1, // Available
    ),
    GtfsStopEntity(
      stopId: 'stop_3',
      stopName: 'Plac Wszystkich Świętych',
      position: const LatLng(50.0750, 19.9550),
      stopCode: 'P001',
      wheelchairBoarding: 0, // Unknown
    ),
    GtfsStopEntity(
      stopId: 'stop_4',
      stopName: 'Kraków Główny',
      position: const LatLng(50.0800, 19.9600),
      stopCode: 'K001',
      wheelchairBoarding: 1, // Available
    ),
  ];

  static final List<GtfsShapeEntity> _mockGtfsShapes = [
    // Route 1 shapes
    GtfsShapeEntity(
      shapeId: 'shape_1',
      position: const LatLng(50.0647, 19.9450),
      sequence: 1,
    ),
    GtfsShapeEntity(
      shapeId: 'shape_1',
      position: const LatLng(50.0660, 19.9460),
      sequence: 2,
    ),
    GtfsShapeEntity(
      shapeId: 'shape_1',
      position: const LatLng(50.0680, 19.9480),
      sequence: 3,
    ),
    GtfsShapeEntity(
      shapeId: 'shape_1',
      position: const LatLng(50.0700, 19.9500),
      sequence: 4,
    ),
    // Route 2 shapes
    GtfsShapeEntity(
      shapeId: 'shape_2',
      position: const LatLng(50.0800, 19.9600),
      sequence: 1,
    ),
    GtfsShapeEntity(
      shapeId: 'shape_2',
      position: const LatLng(50.0780, 19.9580),
      sequence: 2,
    ),
    GtfsShapeEntity(
      shapeId: 'shape_2',
      position: const LatLng(50.0760, 19.9560),
      sequence: 3,
    ),
    GtfsShapeEntity(
      shapeId: 'shape_2',
      position: const LatLng(50.0740, 19.9540),
      sequence: 4,
    ),
    GtfsShapeEntity(
      shapeId: 'shape_2',
      position: const LatLng(50.0720, 19.9520),
      sequence: 5,
    ),
    GtfsShapeEntity(
      shapeId: 'shape_2',
      position: const LatLng(50.0700, 19.9500),
      sequence: 6,
    ),
  ];

  static final List<GtfsScheduleWithDelaysEntity> _mockGtfsSchedules = [
    GtfsScheduleWithDelaysEntity(
      stopId: 'stop_1',
      stopName: 'Rynek Główny',
      routeId: 'route_1',
      routeShortName: '15',
      routeLongName: 'Centrum - Dworzec Główny',
      routeColor: '#FF5722',
      tripId: 'trip_1',
      tripHeadsign: 'Dworzec Główny',
      scheduledArrivalTime: '08:30:00',
      scheduledDepartureTime: '08:32:00',
      realTimeArrivalTime: '08:32:00',
      realTimeDepartureTime: '08:34:00',
      delaySeconds: 120,
      delayType: 'arrival',
      delayReason: 'Korek uliczny',
      stopSequence: 1,
      directionId: 0,
      wheelchairAccessible: 1,
      bikesAllowed: 1,
      serviceId: 'service_1',
      isRealTime: true,
    ),
    GtfsScheduleWithDelaysEntity(
      stopId: 'stop_1',
      stopName: 'Rynek Główny',
      routeId: 'route_2',
      routeShortName: '22',
      routeLongName: 'Nowa Huta - Centrum',
      routeColor: '#2196F3',
      tripId: 'trip_2',
      tripHeadsign: 'Nowa Huta',
      scheduledArrivalTime: '08:35:00',
      scheduledDepartureTime: '08:37:00',
      realTimeArrivalTime: '08:35:00',
      realTimeDepartureTime: '08:37:00',
      delaySeconds: 0,
      delayType: null,
      delayReason: null,
      stopSequence: 1,
      directionId: 1,
      wheelchairAccessible: 1,
      bikesAllowed: 1,
      serviceId: 'service_1',
      isRealTime: true,
    ),
  ];

  static final List<GtfsDelayEntity> _mockGtfsDelays = [
    GtfsDelayEntity(
      tripId: 'trip_1',
      stopId: 'stop_1',
      delaySeconds: 120,
      delayType: 'arrival',
      reason: 'Korek uliczny',
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    GtfsDelayEntity(
      tripId: 'trip_3',
      stopId: 'stop_2',
      delaySeconds: 300,
      delayType: 'departure',
      reason: 'Awaria pojazdu',
      createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
  ];

  // GTFS API methods
  static Future<List<GtfsRouteEntity>> getGtfsRoutes({
    int? limit,
    int? offset,
    String? routeType,
  }) async {
    await _simulateDelay();

    if (_shouldSimulateError()) {
      throw Exception('Network error: Unable to fetch GTFS routes');
    }

    var routes = List<GtfsRouteEntity>.from(_mockGtfsRoutes);

    // Filter by route type if provided
    if (routeType != null) {
      final type = int.tryParse(routeType);
      if (type != null) {
        routes = routes.where((route) => route.routeType == type).toList();
      }
    }

    // Apply pagination
    final startIndex = offset ?? 0;
    final endIndex = limit != null ? startIndex + limit : routes.length;

    return routes.skip(startIndex).take(endIndex - startIndex).toList();
  }

  static Future<List<GtfsStopEntity>> getGtfsStops({
    int? limit,
    int? offset,
    String? stopId,
  }) async {
    await _simulateDelay();

    if (_shouldSimulateError()) {
      throw Exception('Network error: Unable to fetch GTFS stops');
    }

    var stops = List<GtfsStopEntity>.from(_mockGtfsStops);

    // Filter by stop ID if provided
    if (stopId != null) {
      stops = stops.where((stop) => stop.stopId == stopId).toList();
    }

    // Apply pagination
    final startIndex = offset ?? 0;
    final endIndex = limit != null ? startIndex + limit : stops.length;

    return stops.skip(startIndex).take(endIndex - startIndex).toList();
  }

  static Future<List<GtfsShapeEntity>> getGtfsShapes({
    required String routeId,
  }) async {
    await _simulateDelay();

    if (_shouldSimulateError()) {
      throw Exception('Network error: Unable to fetch GTFS shapes');
    }

    // Map route IDs to shape IDs
    final shapeIdMap = {
      'route_1': 'shape_1',
      'route_2': 'shape_2',
      'route_3': 'shape_3',
    };

    final shapeId = shapeIdMap[routeId];
    if (shapeId == null) {
      return [];
    }

    return _mockGtfsShapes.where((shape) => shape.shapeId == shapeId).toList()
      ..sort((a, b) => a.sequence.compareTo(b.sequence));
  }

  static Future<List<GtfsStopEntity>> getGtfsStopsForRoute({
    required String routeId,
  }) async {
    await _simulateDelay();

    if (_shouldSimulateError()) {
      throw Exception('Network error: Unable to fetch GTFS stops for route');
    }

    // Map route IDs to stop IDs
    final routeStopsMap = {
      'route_1': ['stop_1', 'stop_2'],
      'route_2': ['stop_2', 'stop_3', 'stop_4'],
      'route_3': ['stop_1', 'stop_3', 'stop_4'],
    };

    final stopIds = routeStopsMap[routeId] ?? [];
    return _mockGtfsStops
        .where((stop) => stopIds.contains(stop.stopId))
        .toList();
  }

  static Future<List<GtfsScheduleWithDelaysEntity>> getGtfsScheduleForStop({
    required String stopId,
    int? limit,
  }) async {
    await _simulateDelay();

    if (_shouldSimulateError()) {
      throw Exception('Network error: Unable to fetch GTFS schedule for stop');
    }

    var schedules = _mockGtfsSchedules
        .where((schedule) => schedule.stopId == stopId)
        .toList();

    // Apply limit
    if (limit != null && schedules.length > limit) {
      schedules = schedules.take(limit).toList();
    }

    return schedules;
  }

  static Future<List<GtfsDelayEntity>> getGtfsDelaysForRoute({
    required String routeId,
  }) async {
    await _simulateDelay();

    if (_shouldSimulateError()) {
      throw Exception('Network error: Unable to fetch GTFS delays for route');
    }

    // Map route IDs to trip IDs
    final routeTripsMap = {
      'route_1': ['trip_1'],
      'route_2': ['trip_2'],
      'route_3': ['trip_3'],
    };

    final tripIds = routeTripsMap[routeId] ?? [];
    return _mockGtfsDelays
        .where((delay) => tripIds.contains(delay.tripId))
        .toList();
  }

  static Future<List<GtfsStopEntity>> getNearbyGtfsStops({
    required LatLng location,
    double? radius,
    int? limit,
  }) async {
    await _simulateDelay();

    if (_shouldSimulateError()) {
      throw Exception('Network error: Unable to fetch nearby GTFS stops');
    }

    final searchRadius = radius ?? 1.0; // Default 1km radius
    var results = _mockGtfsStops.where((stop) {
      final distance = _calculateDistance(location, stop.position);
      return distance <= searchRadius;
    }).toList();

    // Apply limit
    if (limit != null && results.length > limit) {
      results = results.take(limit).toList();
    }

    return results;
  }
}
