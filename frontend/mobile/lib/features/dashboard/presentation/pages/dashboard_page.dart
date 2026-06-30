import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawjati_mobile/core/theme/app_theme_colors.dart';
import 'package:zawjati_mobile/core/theme/app_theme_metrics.dart';
import 'package:zawjati_mobile/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:zawjati_mobile/features/dashboard/presentation/widgets/stat_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(LoadDashboard());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardInitial || state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DashboardError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppThemeMetrics.spacingLg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.bar_chart_outlined,
                      size: AppThemeMetrics.iconLg * 2,
                      color: AppThemeColors.hintText,
                    ),
                    const SizedBox(height: AppThemeMetrics.spacingMd),
                    Text(
                      state.message,
                      style: TextStyle(color: AppThemeColors.hintText),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppThemeMetrics.spacingLg),
                    ElevatedButton(
                      onPressed: () {
                        context.read<DashboardBloc>().add(LoadDashboard());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is DashboardLoaded) {
            final m = state.metrics;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppThemeMetrics.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(title: 'Overview'),
                  const SizedBox(height: AppThemeMetrics.spacingSm),
                  _StatGrid(metrics: m),

                  const SizedBox(height: AppThemeMetrics.spacingLg),
                  _SectionHeader(title: 'Daily Activity'),
                  const SizedBox(height: AppThemeMetrics.spacingSm),
                  _DailyActivityChart(activity: m.dailyActivity),

                  const SizedBox(height: AppThemeMetrics.spacingLg),
                  if (m.toolUsage.isNotEmpty) ...[
                    _SectionHeader(title: 'Tool Usage'),
                    const SizedBox(height: AppThemeMetrics.spacingSm),
                    _ToolUsageList(tools: m.toolUsage),
                    const SizedBox(height: AppThemeMetrics.spacingLg),
                  ],

                  _SectionHeader(title: 'Provider'),
                  const SizedBox(height: AppThemeMetrics.spacingSm),
                  _ProviderCard(provider: m.providerInfo),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: AppThemeColors.secondaryText,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _StatGrid extends StatelessWidget {
  final dynamic metrics;

  const _StatGrid({required this.metrics});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppThemeMetrics.spacingSm,
          crossAxisSpacing: AppThemeMetrics.spacingSm,
          childAspectRatio: 1.5,
          children: [
            StatCard(
              label: 'Conversations',
              value: _formatNum(metrics.totalConversations),
              icon: Icons.chat_bubble_outline,
            ),
            StatCard(
              label: 'Messages',
              value: _formatNum(metrics.totalMessages),
              icon: Icons.message_outlined,
            ),
            StatCard(
              label: 'Total Tokens',
              value: _formatNum(metrics.totalTokens),
              icon: Icons.token_outlined,
            ),
            StatCard(
              label: 'Cost',
              value: '\$${metrics.totalCost.toStringAsFixed(4)}',
              icon: Icons.attach_money,
            ),
            StatCard(
              label: 'Avg Latency',
              value: '${metrics.avgLatency.toStringAsFixed(1)}ms',
              icon: Icons.timer_outlined,
            ),
            StatCard(
              label: 'Memories',
              value: _formatNum(metrics.totalMemories),
              icon: Icons.auto_stories_outlined,
            ),
          ],
        );
      },
    );
  }

  String _formatNum(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }
}

class _DailyActivityChart extends StatelessWidget {
  final List<dynamic> activity;

  const _DailyActivityChart({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.all(AppThemeMetrics.spacingMd),
      decoration: BoxDecoration(
        color: AppThemeColors.surface,
        borderRadius: BorderRadius.circular(AppThemeMetrics.radiusLg),
        border: Border.all(
          color: AppThemeColors.border,
          width: AppThemeMetrics.borderHairline,
        ),
      ),
      child: activity.isEmpty
          ? Center(
              child: Text(
                'No activity data yet',
                style: TextStyle(color: AppThemeColors.hintText),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Messages over time',
                  style: TextStyle(
                    color: AppThemeColors.hintText,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: activity.map((d) {
                    final maxCount = activity.fold<int>(
                      0,
                      (max, e) => e.count > max ? e.count : max,
                    );
                    final height = maxCount > 0
                        ? (d.count / maxCount * 120)
                        : 0.0;
                    final dayStr = '${d.date.month}/${d.date.day}';
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (d.count > 0)
                              Text(
                                '${d.count}',
                                style: TextStyle(
                                  color: AppThemeColors.hintText,
                                  fontSize: 9,
                                ),
                              ),
                            const SizedBox(height: 2),
                            Container(
                              height: height.clamp(4.0, 120.0),
                              decoration: BoxDecoration(
                                color: AppThemeColors.primaryAccent.withValues(alpha: 0.6),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(3),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              dayStr,
                              style: TextStyle(
                                color: AppThemeColors.hintText,
                                fontSize: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
    );
  }
}

class _ToolUsageList extends StatelessWidget {
  final List<dynamic> tools;

  const _ToolUsageList({required this.tools});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppThemeMetrics.spacingMd),
      decoration: BoxDecoration(
        color: AppThemeColors.surface,
        borderRadius: BorderRadius.circular(AppThemeMetrics.radiusLg),
        border: Border.all(
          color: AppThemeColors.border,
          width: AppThemeMetrics.borderHairline,
        ),
      ),
      child: Column(
        children: tools.map((t) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: AppThemeMetrics.spacingSm),
            child: Row(
              children: [
                Icon(
                  Icons.build_outlined,
                  color: AppThemeColors.primaryAccent,
                  size: AppThemeMetrics.iconSm,
                ),
                const SizedBox(width: AppThemeMetrics.spacingSm),
                Expanded(
                  child: Text(
                    t.tool,
                    style: TextStyle(color: AppThemeColors.primaryText, fontSize: 14),
                  ),
                ),
                Text(
                  '${t.count}',
                  style: TextStyle(
                    color: AppThemeColors.secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ProviderCard extends StatelessWidget {
  final dynamic provider;

  const _ProviderCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppThemeMetrics.spacingMd),
      decoration: BoxDecoration(
        color: AppThemeColors.surface,
        borderRadius: BorderRadius.circular(AppThemeMetrics.radiusLg),
        border: Border.all(
          color: AppThemeColors.border,
          width: AppThemeMetrics.borderHairline,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppThemeColors.selected,
              borderRadius: BorderRadius.circular(AppThemeMetrics.radiusSm),
            ),
            child: Icon(
              Icons.cloud_outlined,
              color: AppThemeColors.primaryAccent,
              size: AppThemeMetrics.iconMd,
            ),
          ),
          const SizedBox(width: AppThemeMetrics.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.provider.isNotEmpty ? provider.provider : 'N/A',
                  style: TextStyle(
                    color: AppThemeColors.primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (provider.model.isNotEmpty)
                  Text(
                    provider.model,
                    style: TextStyle(
                      color: AppThemeColors.hintText,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppThemeMetrics.spacingSm,
              vertical: AppThemeMetrics.spacing2xs,
            ),
            decoration: BoxDecoration(
              color: AppThemeColors.success.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppThemeMetrics.radiusPill),
            ),
            child: Text(
              provider.status,
              style: TextStyle(
                color: AppThemeColors.success,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
