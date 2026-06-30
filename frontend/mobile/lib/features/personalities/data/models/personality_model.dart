import 'package:zawjati_mobile/features/personalities/domain/entities/personality.dart';

class PersonalityModel extends Personality {
  const PersonalityModel({
    required super.id,
    required super.name,
    required super.description,
    required super.category,
    super.isCustom = false,
  });

  factory PersonalityModel.fromJson(Map<String, dynamic> json) {
    return PersonalityModel(
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

  factory PersonalityModel.fromEntity(Personality entity) {
    return PersonalityModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      category: entity.category,
      isCustom: entity.isCustom,
    );
  }
}
