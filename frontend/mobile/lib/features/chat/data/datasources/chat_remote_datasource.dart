import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:zawjati_mobile/core/constants/end_points.dart';
import 'package:zawjati_mobile/core/network/dio_client.dart';
import '../models/chat_response_model.dart';
import '../models/chat_request_model.dart';
import '../models/chat_conversation_model.dart';

class ChatRemoteDataSource {
  final DioClient _dioClient;

  ChatRemoteDataSource({required DioClient dioClient}) : _dioClient = dioClient;

  Future<ChatResponseModel> sendMessage(ChatRequestModel request) async {
    final response = await _dioClient.post(
      EndPoints.chat,
      data: request.toJson(),
    );
    return ChatResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Stream<String> streamMessage(ChatRequestModel request) async* {
    final response = await _dioClient.postStream(
      EndPoints.chatStream,
      data: request.toJson(),
    );

    final stream = response.data?.stream;
    if (stream == null) {
      throw const ServerException('No response stream');
    }

    String buffer = '';
    await for (final chunk in stream) {
      buffer += utf8.decode(chunk);
      final events = buffer.split('\n\n');
      buffer = events.removeLast();
      for (final event in events) {
        final token = _parseSseToken(event);
        if (token != null) yield token;
      }
    }
    if (buffer.isNotEmpty) {
      final token = _parseSseToken(buffer);
      if (token != null) yield token;
    }
  }

  String? _parseSseToken(String event) {
    if (event.trim().isEmpty) return null;
    String? eventType;
    String? data;
    for (final line in event.split('\n')) {
      if (line.startsWith('event: ')) {
        eventType = line.substring(7).trim();
      } else if (line.startsWith('data: ')) {
        data = line.substring(6).trim();
      }
    }
    if (eventType == 'token' && data != null && data.isNotEmpty) {
      try {
        final json = jsonDecode(data) as Map<String, dynamic>;
        return json['token'] as String?;
      } catch (_) {
        return data;
      }
    }
    return null;
  }

  WebSocketChannel connectWebSocket(String userId) {
    final baseUrl = EndPoints.baseUrl;
    final wsUrl = baseUrl
        .replaceFirst('https://', 'wss://')
        .replaceFirst('http://', 'ws://');
    final uri = Uri.parse('$wsUrl${EndPoints.chatWs}?user_id=$userId');
    return WebSocketChannel.connect(uri);
  }

  Future<List<ChatConversationModel>> getConversations() async {
    final response = await _dioClient.get(EndPoints.chat);
    final data = response.data;
    if (data is List) {
      return data
          .map((e) =>
              ChatConversationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (data is Map && data['conversations'] is List) {
      return (data['conversations'] as List)
          .map(
              (e) => ChatConversationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}

class ServerException implements Exception {
  final String message;
  const ServerException(this.message);

  @override
  String toString() => message;
}
