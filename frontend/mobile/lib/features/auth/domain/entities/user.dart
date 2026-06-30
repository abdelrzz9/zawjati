import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final DateTime? createdAt;
  final String? personality;
  final String? language;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.createdAt,
    this.personality,
    this.language,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      personality: json['personality'] as String?,
      language: json['language'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'created_at': createdAt?.toIso8601String(),
      'personality': personality,
      'language': language,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    DateTime? createdAt,
    String? personality,
    String? language,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      personality: personality ?? this.personality,
      language: language ?? this.language,
    );
  }

  @override
  List<Object?> get props => [id, email, name, createdAt, personality, language];
}
