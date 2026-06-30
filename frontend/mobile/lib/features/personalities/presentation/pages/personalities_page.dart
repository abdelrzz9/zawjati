import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawjati_mobile/core/theme/theme.dart';
import '../bloc/personalities_bloc.dart';
import '../widgets/personality_card.dart';

class PersonalitiesPage extends StatefulWidget {
  const PersonalitiesPage({super.key});

  @override
  State<PersonalitiesPage> createState() => _PersonalitiesPageState();
}

class _PersonalitiesPageState extends State<PersonalitiesPage> {
  @override
  void initState() {
    super.initState();
    context.read<PersonalitiesBloc>().add(GetPersonalitiesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personalities'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/personalities/create');
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<PersonalitiesBloc, PersonalitiesState>(
        builder: (context, state) {
          if (state is PersonalitiesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PersonalitiesError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message,
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: AppTheme.spacingMd),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<PersonalitiesBloc>()
                          .add(GetPersonalitiesEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is PersonalitiesLoaded) {
            return Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.selected != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppTheme.spacingMd),
                      decoration: BoxDecoration(
                        color:
                            AppTheme.primaryAccent.withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMd),
                        border: Border.all(color: AppTheme.primaryAccent),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle,
                              color: AppTheme.primaryAccent, size: 20),
                          const SizedBox(width: AppTheme.spacingSm),
                          Text(
                            'Active: ${state.selected!.name}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: AppTheme.primaryAccent),
                          ),
                        ],
                      ),
                    ),
                  if (state.selected != null)
                    const SizedBox(height: AppTheme.spacingMd),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: AppTheme.spacingSm,
                        mainAxisSpacing: AppTheme.spacingSm,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: state.personalities.length,
                      itemBuilder: (context, index) {
                        final personality = state.personalities[index];
                        final isSelected =
                            state.selected?.id == personality.id;
                        return PersonalityCard(
                          personality: personality,
                          isSelected: isSelected,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/personalities/detail',
                              arguments: personality,
                            );
                          },
                        );
                      },
                    ),
                  ),
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
