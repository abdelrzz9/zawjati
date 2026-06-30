import 'package:zawjati_mobile/features/profile/domain/entities/profile.dart';

class ProfileModel extends UserProfile {
  const ProfileModel({
    required super.userId,
    required super.nickname,
    required super.relationshipType,
    required super.personality,
    required super.language,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      userId: json['user_id'] as String,
      nickname: json['nickname'] as String,
      relationshipType: json['relationship_type'] as String? ?? 'companion',
      personality: json['personality'] as String? ?? 'assistant',
      language: json['language'] as String? ?? 'en',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'nickname': nickname,
      'relationship_type': relationshipType,
      'personality': personality,
      'language': language,
    };
  }

  factory ProfileModel.fromEntity(UserProfile entity) {
    return ProfileModel(
      userId: entity.userId,
      nickname: entity.nickname,
      relationshipType: entity.relationshipType,
      personality: entity.personality,
      language: entity.language,
    );
  }
}
