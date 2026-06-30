import 'package:equatable/equatable.dart';

enum MemoryCategory {
  preference,
  fact,
  goal,
  event,
  concept,
  relationship,
  achievement,
  routine,
  opinion;

  String toJson() => name;

  static MemoryCategory fromJson(String value) {
    return MemoryCategory.values.firstWhere(
      (e) => e.name == value,
      orElse: () => MemoryCategory.fact,
    );
  }
}

class Memory extends Equatable {
  final String id;
  final String content;
  final String userId;
  final MemoryCategory category;
  final int importance;
  final double confidence;
  final DateTime timestamp;
  final DateTime? lastAccessed;
  final int accessCount;
  final bool pinned;

  const Memory({
    required this.id,
    required this.content,
    required this.userId,
    this.category = MemoryCategory.fact,
    this.importance = 5,
    this.confidence = 0.5,
    required this.timestamp,
    this.lastAccessed,
    this.accessCount = 0,
    this.pinned = false,
  });

  Memory copyWith({
    String? id,
    String? content,
    String? userId,
    MemoryCategory? category,
    int? importance,
    double? confidence,
    DateTime? timestamp,
    DateTime? lastAccessed,
    int? accessCount,
    bool? pinned,
  }) {
    return Memory(
      id: id ?? this.id,
      content: content ?? this.content,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      importance: importance ?? this.importance,
      confidence: confidence ?? this.confidence,
      timestamp: timestamp ?? this.timestamp,
      lastAccessed: lastAccessed ?? this.lastAccessed,
      accessCount: accessCount ?? this.accessCount,
      pinned: pinned ?? this.pinned,
    );
  }

  @override
  List<Object?> get props => [
        id,
        content,
        userId,
        category,
        importance,
        confidence,
        timestamp,
        lastAccessed,
        accessCount,
        pinned,
      ];
}
