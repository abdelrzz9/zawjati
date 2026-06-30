import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawjati_mobile/core/theme/theme.dart';
import 'package:zawjati_mobile/features/personalities/domain/entities/personality.dart';
import '../bloc/personalities_bloc.dart';

class PersonalityDetailPage extends StatelessWidget {
  final Personality personality;

  const PersonalityDetailPage({super.key, required this.personality});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(personality.name),
      ),
      body: BlocBuilder<PersonalitiesBloc, PersonalitiesState>(
        builder: (context, state) {
          final isActive = state is PersonalitiesLoaded &&
              state.selected?.id == personality.id;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppTheme.primaryAccent
                          : AppTheme.surfaceColor,
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusXxl),
                    ),
                    child: Icon(
                      _iconForCategory(personality.category),
                      color: isActive ? Colors.white : AppTheme.primaryAccent,
                      size: 36,
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingLg),
                Center(
                  child: Text(
                    personality.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                if (personality.category.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: AppTheme.spacingSm),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingMd,
                          vertical: AppTheme.spacingXs,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryAccent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusPill,
                          ),
                        ),
                        child: Text(
                          personality.category,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: AppTheme.primaryAccent),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: AppTheme.spacingXl),
                if (personality.description.isNotEmpty) ...[
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  Text(
                    personality.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.secondaryTextColor,
                          height: 1.6,
                        ),
                  ),
                  const SizedBox(height: AppTheme.spacingXl),
                ],
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isActive
                        ? null
                        : () {
                            context.read<PersonalitiesBloc>().add(
                                  SelectPersonalityEvent(
                                    personality: personality,
                                  ),
                                );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${personality.name} set as active',
                                ),
                              ),
                            );
                            Navigator.pop(context);
                          },
                    child: Text(
                      isActive ? 'Already Active' : 'Set as Active',
                    ),
                  ),
                ),
              ],
            ),
          );
        },
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
