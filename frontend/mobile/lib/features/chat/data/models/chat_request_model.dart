class ChatRequestModel {
  final String message;
  final String userId;
  final String? personality;
  final bool stream;

  const ChatRequestModel({
    required this.message,
    this.userId = 'default',
    this.personality,
    this.stream = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user_id': userId,
      if (personality != null) 'personality': personality,
      'stream': stream,
    };
  }
}
