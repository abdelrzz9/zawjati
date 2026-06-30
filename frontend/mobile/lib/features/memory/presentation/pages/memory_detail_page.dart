import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zawjati_mobile/core/theme/app_theme_colors.dart';
import 'package:zawjati_mobile/features/memory/domain/entities/memory.dart';
import '../bloc/memory_bloc.dart';
import '../widgets/memory_category_chip.dart';

class MemoryDetailPage extends StatelessWidget {
  final Memory memory;
  final String userId;

  const MemoryDetailPage({
    super.key,
    required this.memory,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeColors.background,
      appBar: AppBar(
        backgroundColor: AppThemeColors.surface,
        title: const Text(
          'Memory Detail',
          style: TextStyle(color: AppThemeColors.primaryText),
        ),
        elevation: 0,
        actions: [
          BlocBuilder<MemoryBloc, MemoryState>(
            builder: (context, state) {
              final isPinned = state is MemoryLoaded
                  ? state.memories
                      .firstWhere((m) => m.id == memory.id,
                          orElse: () => memory)
                      .pinned
                  : memory.pinned;
              return IconButton(
                icon: Icon(
                  isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                  color: isPinned
                      ? AppThemeColors.primaryAccent
                      : AppThemeColors.neutral300,
                ),
                onPressed: () {
                  context
                      .read<MemoryBloc>()
                      .add(PinMemory(id: memory.id));
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: AppThemeColors.neutral300,
            ),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                MemoryCategoryChip(
                  category: memory.category,
                  isSelected: false,
                  onTap: () {},
                ),
                const Spacer(),
                _ConfidenceBadge(confidence: memory.confidence),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              memory.content,
              style: const TextStyle(
                color: AppThemeColors.primaryText,
                fontSize: 16,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            _InfoRow(
              icon: Icons.flag,
              label: 'Importance',
              child: _ImportanceBar(importance: memory.importance),
            ),
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.access_time,
              label: 'Created',
              value: DateFormat('MMM d, yyyy – h:mm a')
                  .format(memory.timestamp),
            ),
            if (memory.lastAccessed != null) ...[
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.history,
                label: 'Last Accessed',
                value: DateFormat('MMM d, yyyy – h:mm a')
                    .format(memory.lastAccessed!),
              ),
            ],
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.visibility,
              label: 'Access Count',
              value: '${memory.accessCount}',
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppThemeColors.surface,
        title: const Text(
          'Delete Memory',
          style: TextStyle(color: AppThemeColors.primaryText),
        ),
        content: const Text(
          'Are you sure you want to delete this memory?',
          style: TextStyle(color: AppThemeColors.secondaryText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppThemeColors.neutral300),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<MemoryBloc>().add(DeleteMemory(id: memory.id));
              Navigator.of(context).pop();
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppThemeColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final Widget? child;

  const _InfoRow({
    required this.icon,
    required this.label,
    this.value,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppThemeColors.neutral300),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            color: AppThemeColors.neutral300,
            fontSize: 13,
          ),
        ),
        if (value != null)
          Expanded(
            child: Text(
              value!,
              style: const TextStyle(
                color: AppThemeColors.primaryText,
                fontSize: 13,
              ),
            ),
          ),
        if (child != null) Expanded(child: child!),
      ],
    );
  }
}

class _ImportanceBar extends StatelessWidget {
  final int importance;

  const _ImportanceBar({required this.importance});

  Color _color(int level) {
    if (level <= 3) return AppThemeColors.success;
    if (level <= 6) return AppThemeColors.warning;
    return AppThemeColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(10, (i) {
        final filled = i < importance;
        return Container(
          width: 20,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: filled ? _color(importance) : AppThemeColors.neutral500,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

class _ConfidenceBadge extends StatelessWidget {
  final double confidence;

  const _ConfidenceBadge({required this.confidence});

  @override
  Widget build(BuildContext context) {
    final pct = (confidence * 100).round();
    final color = confidence >= 0.7
        ? AppThemeColors.success
        : confidence >= 0.4
            ? AppThemeColors.warning
            : AppThemeColors.error;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        '$pct% confidence',
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
