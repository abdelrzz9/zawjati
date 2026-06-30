import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String userId;
  final String nickname;
  final String relationshipType;
  final String personality;
  final String language;

  const UserProfile({
    required this.userId,
    required this.nickname,
    required this.relationshipType,
    required this.personality,
    required this.language,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
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

  UserProfile copyWith({
    String? userId,
    String? nickname,
    String? relationshipType,
    String? personality,
    String? language,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      nickname: nickname ?? this.nickname,
      relationshipType: relationshipType ?? this.relationshipType,
      personality: personality ?? this.personality,
      language: language ?? this.language,
    );
  }

  @override
  List<Object?> get props =>
      [userId, nickname, relationshipType, personality, language];
}
