import 'package:equatable/equatable.dart';

class Personality extends Equatable {
  final String id;
  final String name;
  final String description;
  final String category;
  final bool isCustom;

  const Personality({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.isCustom = false,
  });

  factory Personality.fromJson(Map<String, dynamic> json) {
    return Personality(
      id: json['id'] as String? ?? json['name'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      isCustom: json['is_custom'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'is_custom': isCustom,
    };
  }

  Personality copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    bool? isCustom,
  }) {
    return Personality(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  @override
  List<Object?> get props => [id, name, description, category, isCustom];
}
