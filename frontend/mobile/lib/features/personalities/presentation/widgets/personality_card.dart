import 'package:flutter/material.dart';
import 'package:zawjati_mobile/core/theme/app_theme_metrics.dart';
import 'package:zawjati_mobile/core/theme/theme.dart';
import 'package:zawjati_mobile/features/personalities/domain/entities/personality.dart';

class PersonalityCard extends StatelessWidget {
  final Personality personality;
  final bool isSelected;
  final VoidCallback onTap;

  const PersonalityCard({
    super.key,
    required this.personality,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryAccent.withValues(alpha: 0.1)
              : AppTheme.cardColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          border: Border.all(
            color: isSelected ? AppTheme.primaryAccent : AppTheme.borderColor,
            width: isSelected
                ? AppThemeMetrics.borderThick
                : AppThemeMetrics.borderHairline,
          ),
        ),
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryAccent
                        : AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                  child: Center(
                    child: Icon(
                      _iconForCategory(personality.category),
                      color: isSelected
                          ? Colors.white
                          : AppTheme.primaryAccent,
                      size: AppThemeMetrics.iconMd,
                    ),
                  ),
                ),
                if (isSelected)
                  const Padding(
                    padding: EdgeInsets.only(left: AppTheme.spacingSm),
                    child: Icon(Icons.check_circle,
                        color: AppTheme.primaryAccent, size: 20),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              personality.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppTheme.spacing2xs),
            Text(
              personality.description.isNotEmpty
                  ? personality.description
                  : personality.category,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'assistant':
        return Icons.smart_toy_outlined;
      case 'friend':
        return Icons.people_outline;
      case 'therapist':
        return Icons.psychology_outlined;
      case 'wife':
      case 'companion':
        return Icons.favorite_outline;
      default:
        return Icons.person_outline;
    }
  }
}
