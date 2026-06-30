import 'package:equatable/equatable.dart';

class DailyActivity extends Equatable {
  final DateTime date;
  final int count;

  const DailyActivity({required this.date, required this.count});

  @override
  List<Object?> get props => [date, count];
}

class ToolUsage extends Equatable {
  final String tool;
  final int count;

  const ToolUsage({required this.tool, required this.count});

  @override
  List<Object?> get props => [tool, count];
}

class ProviderInfo extends Equatable {
  final String provider;
  final String model;
  final String status;

  const ProviderInfo({
    required this.provider,
    required this.model,
    this.status = 'active',
  });

  @override
  List<Object?> get props => [provider, model, status];
}

class DashboardMetrics extends Equatable {
  final int totalConversations;
  final int totalMessages;
  final int totalTokens;
  final double totalCost;
  final double avgLatency;
  final int totalMemories;
  final List<DailyActivity> dailyActivity;
  final List<ToolUsage> toolUsage;
  final ProviderInfo providerInfo;

  const DashboardMetrics({
    this.totalConversations = 0,
    this.totalMessages = 0,
    this.totalTokens = 0,
    this.totalCost = 0.0,
    this.avgLatency = 0.0,
    this.totalMemories = 0,
    this.dailyActivity = const [],
    this.toolUsage = const [],
    this.providerInfo = const ProviderInfo(provider: '', model: ''),
  });

  @override
  List<Object?> get props => [
    totalConversations,
    totalMessages,
    totalTokens,
    totalCost,
    avgLatency,
    totalMemories,
    dailyActivity,
    toolUsage,
    providerInfo,
  ];
}
