import 'package:equatable/equatable.dart';

class GtfsBlockEntity extends Equatable {
  final String blockId;
  final String? shift;

  const GtfsBlockEntity({
    required this.blockId,
    this.shift,
  });

  GtfsBlockEntity copyWith({
    String? blockId,
    String? shift,
  }) {
    return GtfsBlockEntity(
      blockId: blockId ?? this.blockId,
      shift: shift ?? this.shift,
    );
  }

  @override
  List<Object?> get props => [
        blockId,
        shift,
      ];
}
