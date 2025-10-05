import 'package:journey_radar_mobile/entity/entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gtfs_block_dto.g.dart';

@JsonSerializable()
class GtfsBlockDto {
  @JsonKey(name: 'block_id')
  final String blockId;

  @JsonKey(name: 'shift')
  final String? shift;

  const GtfsBlockDto({
    required this.blockId,
    this.shift,
  });

  factory GtfsBlockDto.fromJson(Map<String, dynamic> json) =>
      _$GtfsBlockDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GtfsBlockDtoToJson(this);

  GtfsBlockEntity toEntity() {
    return GtfsBlockEntity(
      blockId: blockId,
      shift: shift,
    );
  }

  factory GtfsBlockDto.fromEntity(GtfsBlockEntity entity) {
    return GtfsBlockDto(
      blockId: entity.blockId,
      shift: entity.shift,
    );
  }
}
