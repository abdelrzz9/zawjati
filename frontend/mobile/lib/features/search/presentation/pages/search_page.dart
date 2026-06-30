import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/theme/app_theme_metrics.dart';
import '../../../../core/theme/app_theme_text_styles.dart';
import '../bloc/search_bloc.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchBloc(),
      child: const _SearchBody(),
    );
  }
}

class _SearchBody extends StatelessWidget {
  const _SearchBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeColors.background,
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          _SearchBar(),
          const Expanded(child: _SearchResults()),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppThemeMetrics.spacingMd),
      child: TextField(
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Search messages & memories...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: Builder(
            builder: (innerContext) {
              final state = context.watch<SearchBloc>().state;
              if (state.query.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    context.read<SearchBloc>().add(const SearchClear());
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        onChanged: (value) {
          context.read<SearchBloc>().add(SearchQueryChanged(value));
        },
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SearchBloc>().state;

    if (state.query.isEmpty) {
      return _EmptyState();
    }

    if (state.isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    final hasMessages = state.messages.isNotEmpty;
    final hasMemories = state.memories.isNotEmpty;

    if (!hasMessages && !hasMemories) {
      return _NoResultsState(query: state.query);
    }

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Messages'),
              Tab(text: 'Memories'),
            ],
            labelColor: AppThemeColors.primaryAccent,
            unselectedLabelColor: AppThemeColors.tabUnselectedText,
            indicatorColor: AppThemeColors.primaryAccent,
          ),
          Expanded(
            child: TabBarView(
              children: [
                _ResultList(items: state.messages),
                _ResultList(items: state.memories),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultList extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const _ResultList({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          'No results found',
          style: AppThemeTextStyles.textTheme.bodyMedium?.copyWith(
            color: AppThemeColors.subtitleText,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppThemeMetrics.spacingMd),
      itemCount: items.length,
      separatorBuilder: (_, _) => const Divider(),
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          title: Text(
            item['title'] as String? ?? '',
            style: AppThemeTextStyles.textTheme.titleMedium,
          ),
          subtitle: Text(
            item['snippet'] as String? ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: AppThemeColors.neutral500,
          ),
          const SizedBox(height: AppThemeMetrics.spacingMd),
          Text(
            'Search your conversations',
            style: AppThemeTextStyles.textTheme.bodyMedium?.copyWith(
              color: AppThemeColors.subtitleText,
            ),
          ),
          const SizedBox(height: AppThemeMetrics.spacingXs),
          Text(
            'Find messages and memories instantly',
            style: AppThemeTextStyles.textTheme.bodySmall?.copyWith(
              color: AppThemeColors.hintText,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoResultsState extends StatelessWidget {
  final String query;

  const _NoResultsState({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppThemeColors.neutral500,
          ),
          const SizedBox(height: AppThemeMetrics.spacingMd),
          Text(
            'No results for "$query"',
            style: AppThemeTextStyles.textTheme.bodyMedium?.copyWith(
              color: AppThemeColors.subtitleText,
            ),
          ),
        ],
      ),
    );
  }
}
