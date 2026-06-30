import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/theme/app_theme_metrics.dart';
import '../../../../core/theme/app_theme_text_styles.dart';
import '../bloc/developer_bloc.dart';

class DeveloperPage extends StatelessWidget {
  const DeveloperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DeveloperBloc(),
      child: const _DeveloperBody(),
    );
  }
}

class _DeveloperBody extends StatelessWidget {
  const _DeveloperBody();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DeveloperBloc>().state;

    return Scaffold(
      backgroundColor: AppThemeColors.background,
      appBar: AppBar(
        title: const Text('Developer Tools'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppThemeMetrics.spacingMd),
        children: [
          _CardTile(
            icon: Icons.terminal,
            title: 'Logs Viewer',
            subtitle: '${state.logs.length} entries',
            onTap: () => context.push('/developer/logs'),
          ),
          const SizedBox(height: AppThemeMetrics.spacingSm),
          _CardTile(
            icon: Icons.api,
            title: 'API Tester',
            subtitle: 'Test API endpoints',
            onTap: () => context.push('/developer/api'),
          ),
          const SizedBox(height: AppThemeMetrics.spacingSm),
          _CardTile(
            icon: Icons.settings_suggest,
            title: 'Config Viewer',
            subtitle: 'View app configuration',
            onTap: () => _showConfig(context),
          ),
          const SizedBox(height: AppThemeMetrics.spacingSm),
          _CardTile(
            icon: Icons.memory,
            title: 'Memory Inspector',
            subtitle: 'Inspect app memory & state',
            onTap: () => _showMemoryInspector(context),
          ),
        ],
      ),
    );
  }

  void _showConfig(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => _ConfigSheet(),
    );
  }

  void _showMemoryInspector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => _MemoryInspectorSheet(),
    );
  }
}

class _CardTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _CardTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: AppThemeColors.primaryAccent),
        title: Text(title, style: AppThemeTextStyles.textTheme.titleMedium),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _ConfigSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppThemeMetrics.spacingLg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'App Configuration',
            style: AppThemeTextStyles.textTheme.titleLarge,
          ),
          const SizedBox(height: AppThemeMetrics.spacingMd),
          _configRow('App Version', '1.0.0+1'),
          _configRow('Build Mode', 'debug'),
          _configRow('Flutter', '3.x'),
          const SizedBox(height: AppThemeMetrics.spacingLg),
        ],
      ),
    );
  }

  Widget _configRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppThemeMetrics.spacingSm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppThemeColors.subtitleText)),
          Text(value),
        ],
      ),
    );
  }
}

class _MemoryInspectorSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppThemeMetrics.spacingLg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Memory Inspector',
            style: AppThemeTextStyles.textTheme.titleLarge,
          ),
          const SizedBox(height: AppThemeMetrics.spacingMd),
          const Text('Active BLoCs and their current states...'),
          const SizedBox(height: AppThemeMetrics.spacingLg),
        ],
      ),
    );
  }
}
