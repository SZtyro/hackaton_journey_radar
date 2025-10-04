import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

class MapPointEntity extends Equatable {
  final String id;
  final LatLng position;
  final String title;
  final String? description;
  final String? buttonText;
  final String iconType;
  final String color;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const MapPointEntity({
    required this.id,
    required this.position,
    required this.title,
    this.description,
    this.buttonText,
    required this.iconType,
    required this.color,
    required this.createdAt,
    this.updatedAt,
  });

  MapPointEntity copyWith({
    String? id,
    LatLng? position,
    String? title,
    String? description,
    String? buttonText,
    String? iconType,
    String? color,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MapPointEntity(
      id: id ?? this.id,
      position: position ?? this.position,
      title: title ?? this.title,
      description: description ?? this.description,
      buttonText: buttonText ?? this.buttonText,
      iconType: iconType ?? this.iconType,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        position,
        title,
        description,
        buttonText,
        iconType,
        color,
        createdAt,
        updatedAt,
      ];
}
