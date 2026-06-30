import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/memory.dart';

part 'memory_model.g.dart';

@JsonSerializable()
class MemoryModel extends Memory {
  const MemoryModel({
    required super.id,
    required super.content,
    @JsonKey(name: 'user_id') required super.userId,
    @JsonKey(unknownEnumValue: MemoryCategory.fact)
    super.category = MemoryCategory.fact,
    super.importance = 5,
    super.confidence = 0.5,
    required super.timestamp,
    @JsonKey(name: 'last_accessed') super.lastAccessed,
    @JsonKey(name: 'access_count') super.accessCount = 0,
    super.pinned = false,
  });

  factory MemoryModel.fromJson(Map<String, dynamic> json) =>
      _$MemoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$MemoryModelToJson(this);

  factory MemoryModel.fromEntity(Memory memory) {
    return MemoryModel(
      id: memory.id,
      content: memory.content,
      userId: memory.userId,
      category: memory.category,
      importance: memory.importance,
      confidence: memory.confidence,
      timestamp: memory.timestamp,
      lastAccessed: memory.lastAccessed,
      accessCount: memory.accessCount,
      pinned: memory.pinned,
    );
  }
}
