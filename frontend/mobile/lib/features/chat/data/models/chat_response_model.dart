import 'package:equatable/equatable.dart';

class ChatResponseModel extends Equatable {
  final String reply;
  final String requestId;
  final double? latencyMs;
  final int? promptTokens;
  final int? completionTokens;
  final int? totalTokens;
  final double? cost;

  const ChatResponseModel({
    required this.reply,
    required this.requestId,
    this.latencyMs,
    this.promptTokens,
    this.completionTokens,
    this.totalTokens,
    this.cost,
  });

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatResponseModel(
      reply: json['reply'] as String? ?? '',
      requestId: json['request_id'] as String? ?? '',
      latencyMs: (json['latency_ms'] as num?)?.toDouble(),
      promptTokens: json['prompt_tokens'] as int?,
      completionTokens: json['completion_tokens'] as int?,
      totalTokens: json['total_tokens'] as int?,
      cost: (json['cost'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reply': reply,
      'request_id': requestId,
      if (latencyMs != null) 'latency_ms': latencyMs,
      if (promptTokens != null) 'prompt_tokens': promptTokens,
      if (completionTokens != null) 'completion_tokens': completionTokens,
      if (totalTokens != null) 'total_tokens': totalTokens,
      if (cost != null) 'cost': cost,
    };
  }

  @override
  List<Object?> get props => [
        reply,
        requestId,
        latencyMs,
        promptTokens,
        completionTokens,
        totalTokens,
        cost,
      ];
}
