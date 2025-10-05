import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  Position? _currentPosition;
  bool _isLocationEnabled = false;

  Position? get currentPosition => _currentPosition;
  bool get isLocationEnabled => _isLocationEnabled;

  /// Sprawdza i prosi o uprawnienia do lokalizacji
  Future<bool> requestLocationPermission() async {
    final status = await Permission.location.status;

    if (status.isGranted) {
      _isLocationEnabled = true;
      return true;
    }

    if (status.isDenied) {
      final result = await Permission.location.request();
      if (result.isGranted) {
        _isLocationEnabled = true;
        return true;
      }
    }

    if (status.isPermanentlyDenied) {
      // Użytkownik trwale odrzucił uprawnienia
      return false;
    }

    return false;
  }

  /// Pobiera aktualną pozycję użytkownika
  Future<Position?> getCurrentLocation() async {
    try {
      if (!_isLocationEnabled) {
        final hasPermission = await requestLocationPermission();
        if (!hasPermission) {
          return null;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      _currentPosition = position;
      return position;
    } catch (e) {
      print('Błąd podczas pobierania lokalizacji: $e');
      return null;
    }
  }

  /// Sprawdza czy usługi lokalizacji są włączone
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Konwertuje Position na LatLng
  LatLng positionToLatLng(Position position) {
    return LatLng(position.latitude, position.longitude);
  }

  /// Pobiera aktualną pozycję jako LatLng
  Future<LatLng?> getCurrentLatLng() async {
    final position = await getCurrentLocation();
    if (position != null) {
      return positionToLatLng(position);
    }
    return null;
  }

  /// Nasłuchuje zmian pozycji
  Stream<Position> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // metry
      ),
    );
  }

  /// Sprawdza czy aplikacja ma uprawnienia do lokalizacji
  Future<bool> hasLocationPermission() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }
}
