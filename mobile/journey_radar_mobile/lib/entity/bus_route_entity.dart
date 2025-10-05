import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

class BusRouteEntity extends Equatable {
  final String id;
  final String name;
  final String number;
  final List<LatLng> coordinates;
  final String color;
  final String description;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const BusRouteEntity({
    required this.id,
    required this.name,
    required this.number,
    required this.coordinates,
    required this.color,
    required this.description,
    required this.createdAt,
    this.updatedAt,
  });

  BusRouteEntity copyWith({
    String? id,
    String? name,
    String? number,
    List<LatLng>? coordinates,
    String? color,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BusRouteEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      number: number ?? this.number,
      coordinates: coordinates ?? this.coordinates,
      color: color ?? this.color,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        number,
        coordinates,
        color,
        description,
        createdAt,
        updatedAt,
      ];
}
