import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zawjati_mobile/core/theme/app_theme_colors.dart';
import 'package:zawjati_mobile/features/memory/domain/entities/memory.dart';
import 'memory_category_chip.dart';

class MemoryCard extends StatelessWidget {
  final Memory memory;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onPin;

  const MemoryCard({
    super.key,
    required this.memory,
    required this.onTap,
    this.onDelete,
    this.onPin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppThemeColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: memory.pinned
                ? AppThemeColors.primaryAccent
                : AppThemeColors.border,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
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
                  _ImportanceDots(importance: memory.importance),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  memory.content,
                  style: const TextStyle(
                    color: AppThemeColors.primaryText,
                    fontSize: 14,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    DateFormat('MMM d, yyyy').format(memory.timestamp),
                    style: const TextStyle(
                      color: AppThemeColors.hintText,
                      fontSize: 11,
                    ),
                  ),
                  const Spacer(),
                  if (memory.pinned)
                    const Icon(
                      Icons.push_pin,
                      size: 16,
                      color: AppThemeColors.primaryAccent,
                    ),
                  if (onPin != null)
                    GestureDetector(
                      onTap: onPin,
                      child: Icon(
                        memory.pinned
                            ? Icons.push_pin
                            : Icons.push_pin_outlined,
                        size: 16,
                        color: memory.pinned
                            ? AppThemeColors.primaryAccent
                            : AppThemeColors.neutral300,
                      ),
                    ),
                  if (onDelete != null)
                    GestureDetector(
                      onTap: onDelete,
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(
                          Icons.delete_outline,
                          size: 16,
                          color: AppThemeColors.neutral300,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImportanceDots extends StatelessWidget {
  final int importance;

  const _ImportanceDots({required this.importance});

  Color _color(int level) {
    if (level <= 3) return AppThemeColors.success;
    if (level <= 6) return AppThemeColors.warning;
    return AppThemeColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(10, (i) {
        final filled = i < importance;
        return Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: filled ? _color(importance) : AppThemeColors.neutral500,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
