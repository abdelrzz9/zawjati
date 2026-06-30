import 'package:zawjati_mobile/features/dashboard/domain/entities/dashboard_metrics.dart';

class DashboardMetricsModel extends DashboardMetrics {
  const DashboardMetricsModel({
    required super.totalConversations,
    required super.totalMessages,
    required super.totalTokens,
    required super.totalCost,
    required super.avgLatency,
    required super.totalMemories,
    required super.dailyActivity,
    required super.toolUsage,
    required super.providerInfo,
  });

  factory DashboardMetricsModel.fromJson(Map<String, dynamic> json) {
    final daily = (json['daily_activity'] as List<dynamic>?)
            ?.map((e) => DailyActivity(
                  date: DateTime.parse(e['date'] as String),
                  count: e['count'] as int,
                ))
            .toList() ??
        [];

    final tools = (json['tool_usage'] as List<dynamic>?)
            ?.map((e) => ToolUsage(
                  tool: e['tool'] as String,
                  count: e['count'] as int,
                ))
            .toList() ??
        [];

    final provider = json['provider'] as Map<String, dynamic>?;
    final providerInfo = provider != null
        ? ProviderInfo(
            provider: provider['provider'] as String? ?? '',
            model: provider['model'] as String? ?? '',
            status: provider['status'] as String? ?? 'active',
          )
        : const ProviderInfo(provider: '', model: '');

    return DashboardMetricsModel(
      totalConversations: json['total_conversations'] as int? ?? 0,
      totalMessages: json['total_messages'] as int? ?? 0,
      totalTokens: json['total_tokens'] as int? ?? 0,
      totalCost: (json['total_cost'] as num?)?.toDouble() ?? 0.0,
      avgLatency: (json['avg_latency'] as num?)?.toDouble() ?? 0.0,
      totalMemories: json['total_memories'] as int? ?? 0,
      dailyActivity: daily,
      toolUsage: tools,
      providerInfo: providerInfo,
    );
  }

  Map<String, dynamic> toJson() => {
    'total_conversations': totalConversations,
    'total_messages': totalMessages,
    'total_tokens': totalTokens,
    'total_cost': totalCost,
    'avg_latency': avgLatency,
    'total_memories': totalMemories,
    'daily_activity': dailyActivity
        .map((e) => {'date': e.date.toIso8601String(), 'count': e.count})
        .toList(),
    'tool_usage': toolUsage
        .map((e) => {'tool': e.tool, 'count': e.count})
        .toList(),
    'provider': {
      'provider': providerInfo.provider,
      'model': providerInfo.model,
      'status': providerInfo.status,
    },
  };
}
