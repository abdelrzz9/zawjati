import 'package:flutter/material.dart';
import 'package:zawjati_mobile/core/theme/app_theme_colors.dart';
import 'package:zawjati_mobile/features/memory/domain/entities/memory.dart';

class MemoryCategoryChip extends StatelessWidget {
  final MemoryCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const MemoryCategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  static const Map<MemoryCategory, IconData> _icons = {
    MemoryCategory.preference: Icons.favorite,
    MemoryCategory.fact: Icons.info,
    MemoryCategory.goal: Icons.flag,
    MemoryCategory.event: Icons.event,
    MemoryCategory.concept: Icons.lightbulb,
    MemoryCategory.relationship: Icons.people,
    MemoryCategory.achievement: Icons.emoji_events,
    MemoryCategory.routine: Icons.repeat,
    MemoryCategory.opinion: Icons.rate_review,
  };

  static const Map<MemoryCategory, Color> _colors = {
    MemoryCategory.preference: Color(0xFFF472B6),
    MemoryCategory.fact: Color(0xFF60A5FA),
    MemoryCategory.goal: Color(0xFF34D399),
    MemoryCategory.event: Color(0xFFFBBF24),
    MemoryCategory.concept: Color(0xFFA78BFA),
    MemoryCategory.relationship: Color(0xFFFB923C),
    MemoryCategory.achievement: Color(0xFFF87171),
    MemoryCategory.routine: Color(0xFF2DD4BF),
    MemoryCategory.opinion: Color(0xFF818CF8),
  };

  static String label(MemoryCategory category) {
    switch (category) {
      case MemoryCategory.preference:
        return 'Preference';
      case MemoryCategory.fact:
        return 'Fact';
      case MemoryCategory.goal:
        return 'Goal';
      case MemoryCategory.event:
        return 'Event';
      case MemoryCategory.concept:
        return 'Concept';
      case MemoryCategory.relationship:
        return 'Relationship';
      case MemoryCategory.achievement:
        return 'Achievement';
      case MemoryCategory.routine:
        return 'Routine';
      case MemoryCategory.opinion:
        return 'Opinion';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _colors[category] ?? AppThemeColors.primaryAccent;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.2)
              : AppThemeColors.surfaceHigh,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : AppThemeColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_icons[category], size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label(category),
              style: TextStyle(
                color: isSelected ? color : AppThemeColors.secondaryText,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
