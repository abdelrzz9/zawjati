import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/theme/app_theme_metrics.dart';
import '../../../../core/theme/app_theme_text_styles.dart';
import '../bloc/developer_bloc.dart';

class DeveloperLogsPage extends StatelessWidget {
  const DeveloperLogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<DeveloperBloc>(),
      child: const _LogsBody(),
    );
  }
}

class _LogsBody extends StatefulWidget {
  const _LogsBody();

  @override
  State<_LogsBody> createState() => _LogsBodyState();
}

class _LogsBodyState extends State<_LogsBody> {
  String _selectedLevel = 'all';
  final _scrollController = ScrollController();

  final _levels = ['all', 'debug', 'info', 'warning', 'error'];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DeveloperBloc>().state;
    final filteredLogs = _selectedLevel == 'all'
        ? state.logs
        : state.logs
            .where((log) => log.contains('[${_selectedLevel.toUpperCase()}]'))
            .toList();

    return Scaffold(
      backgroundColor: AppThemeColors.background,
      appBar: AppBar(
        title: const Text('Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              context.read<DeveloperBloc>().add(const ClearLogs());
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _addSampleLog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 48,
            color: AppThemeColors.surface,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppThemeMetrics.spacingSm,
              ),
              children: _levels.map((level) {
                final isSelected = level == _selectedLevel;
                return Padding(
                  padding: const EdgeInsets.all(AppThemeMetrics.spacingXs),
                  child: FilterChip(
                    label: Text(level.toUpperCase()),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() => _selectedLevel = level);
                    },
                    selectedColor: AppThemeColors.selected,
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: filteredLogs.isEmpty
                ? Center(
                    child: Text(
                      'No logs',
                      style: AppThemeTextStyles.textTheme.bodyMedium?.copyWith(
                        color: AppThemeColors.subtitleText,
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(AppThemeMetrics.spacingSm),
                    itemCount: filteredLogs.length,
                    itemBuilder: (context, index) {
                      return _LogEntry(log: filteredLogs[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _addSampleLog(BuildContext context) {
    final levels = ['debug', 'info', 'warning', 'error'];
    final level = levels[DateTime.now().second % levels.length];
    context.read<DeveloperBloc>().add(
      LoadLogs(
        level: level,
        message: 'Sample log entry at ${DateTime.now()}',
      ),
    );
  }
}

class _LogEntry extends StatelessWidget {
  final String log;

  const _LogEntry({required this.log});

  Color _logColor(String log) {
    if (log.contains('[ERROR]')) return AppThemeColors.error;
    if (log.contains('[WARNING]')) return AppThemeColors.warning;
    if (log.contains('[DEBUG]')) return AppThemeColors.info;
    return AppThemeColors.success;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppThemeMetrics.spacing2xs),
      padding: const EdgeInsets.symmetric(
        horizontal: AppThemeMetrics.spacingSm,
        vertical: AppThemeMetrics.spacingXs,
      ),
      decoration: BoxDecoration(
        color: AppThemeColors.surface,
        borderRadius: BorderRadius.circular(AppThemeMetrics.radiusXs),
        border: Border(
          left: BorderSide(
            color: _logColor(log),
            width: 3,
          ),
        ),
      ),
      child: Text(
        log,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
          color: AppThemeColors.primaryText,
        ),
      ),
    );
  }
}
