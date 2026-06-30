import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawjati_mobile/core/theme/app_theme_colors.dart';
import 'package:zawjati_mobile/features/memory/domain/entities/memory.dart';
import '../bloc/memory_bloc.dart';
import '../widgets/memory_card.dart';
import '../widgets/memory_category_chip.dart';
import '../widgets/memory_search_bar.dart';
import 'memory_detail_page.dart';

class MemoryPage extends StatefulWidget {
  final String? userId;

  const MemoryPage({super.key, this.userId});

  @override
  State<MemoryPage> createState() => _MemoryPageState();
}

class _MemoryPageState extends State<MemoryPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<MemoryBloc>().add(LoadMemories(userId: widget.userId ?? ''));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeColors.background,
      appBar: AppBar(
        backgroundColor: AppThemeColors.surface,
        title: const Text(
          'Memories',
          style: TextStyle(color: AppThemeColors.primaryText),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: MemorySearchBar(
              onChanged: (query) {
                if (query.isEmpty) {
                  context
                      .read<MemoryBloc>()
                      .add(LoadMemories(userId: widget.userId ?? ''));
                } else {
                  context
                      .read<MemoryBloc>()
                      .add(SearchMemories(query: query));
                }
              },
              onClear: () {
                _searchController.clear();
                context
                    .read<MemoryBloc>()
                    .add(LoadMemories(userId: widget.userId ?? ''));
              },
            ),
          ),
          BlocBuilder<MemoryBloc, MemoryState>(
            builder: (context, state) {
              if (state is MemoryLoaded) {
                return _CategoryFilterBar(
                  selectedCategory: state.selectedCategory,
                  onCategorySelected: (category) {
                    context
                        .read<MemoryBloc>()
                        .add(FilterByCategory(category: category));
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
          Expanded(
            child: BlocBuilder<MemoryBloc, MemoryState>(
              builder: (context, state) {
                if (state is MemoryInitial) {
                  return const SizedBox.shrink();
                }
                if (state is MemoryLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppThemeColors.primaryAccent,
                    ),
                  );
                }
                if (state is MemoryError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.message,
                          style: const TextStyle(
                            color: AppThemeColors.error,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<MemoryBloc>()
                                .add(LoadMemories(userId: widget.userId ?? ''));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppThemeColors.primaryAccent,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                if (state is MemoryLoaded) {
                  final displayed = state.filtered;
                  if (displayed.isEmpty) {
                    return const Center(
                      child: Text(
                        'No memories found',
                        style: TextStyle(color: AppThemeColors.hintText),
                      ),
                    );
                  }
                  final pinned = displayed.where((m) => m.pinned).toList();
                  final unpinned = displayed.where((m) => !m.pinned).toList();
                  final sorted = [...pinned, ...unpinned];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      padding: const EdgeInsets.only(bottom: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: sorted.length,
                      itemBuilder: (context, index) {
                        final memory = sorted[index];
                        return MemoryCard(
                          memory: memory,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => MemoryDetailPage(
                                  memory: memory,
                                  userId: widget.userId ?? '',
                                ),
                              ),
                            );
                          },
                          onPin: () {
                            context
                                .read<MemoryBloc>()
                                .add(PinMemory(id: memory.id));
                          },
                          onDelete: () => _confirmDelete(context, memory),
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, Memory memory) {
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

class _CategoryFilterBar extends StatelessWidget {
  final MemoryCategory? selectedCategory;
  final ValueChanged<MemoryCategory?> onCategorySelected;

  const _CategoryFilterBar({
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: MemoryCategory.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = MemoryCategory.values[index];
          final isSelected = category == selectedCategory;
          return MemoryCategoryChip(
            category: category,
            isSelected: isSelected,
            onTap: () {
              onCategorySelected(isSelected ? null : category);
            },
          );
        },
      ),
    );
  }
}
