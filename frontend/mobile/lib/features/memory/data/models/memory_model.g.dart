// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemoryModel _$MemoryModelFromJson(Map<String, dynamic> json) => MemoryModel(
  id: json['id'] as String,
  content: json['content'] as String,
  userId: json['user_id'] as String,
  category:
      $enumDecodeNullable(
        _$MemoryCategoryEnumMap,
        json['category'],
        unknownValue: MemoryCategory.fact,
      ) ??
      MemoryCategory.fact,
  importance: (json['importance'] as num?)?.toInt() ?? 5,
  confidence: (json['confidence'] as num?)?.toDouble() ?? 0.5,
  timestamp: DateTime.parse(json['timestamp'] as String),
  lastAccessed: json['last_accessed'] == null
      ? null
      : DateTime.parse(json['last_accessed'] as String),
  accessCount: (json['access_count'] as num?)?.toInt() ?? 0,
  pinned: json['pinned'] as bool? ?? false,
);

Map<String, dynamic> _$MemoryModelToJson(MemoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'user_id': instance.userId,
      'category': instance.category,
      'importance': instance.importance,
      'confidence': instance.confidence,
      'timestamp': instance.timestamp.toIso8601String(),
      'last_accessed': instance.lastAccessed?.toIso8601String(),
      'access_count': instance.accessCount,
      'pinned': instance.pinned,
    };

const _$MemoryCategoryEnumMap = {
  MemoryCategory.preference: 'preference',
  MemoryCategory.fact: 'fact',
  MemoryCategory.goal: 'goal',
  MemoryCategory.event: 'event',
  MemoryCategory.concept: 'concept',
  MemoryCategory.relationship: 'relationship',
  MemoryCategory.achievement: 'achievement',
  MemoryCategory.routine: 'routine',
  MemoryCategory.opinion: 'opinion',
};
