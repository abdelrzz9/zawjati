import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawjati_mobile/core/theme/theme.dart';
import 'package:zawjati_mobile/core/extensions/context_extensions.dart';
import 'package:zawjati_mobile/injection.dart' as di;
import '../bloc/settings_bloc.dart';

class SettingsStoragePage extends StatelessWidget {
  const SettingsStoragePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di.sl<SettingsBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Storage')),
        body: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is! SettingsLoaded) {
              return const Center(child: CircularProgressIndicator());
            }
            final cacheSize = state.settings.cacheSize;
            return ListView(
              padding: const EdgeInsets.all(AppThemeMetrics.spacingMd),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppThemeMetrics.spacingMd),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.storage_outlined, size: 40),
                            const SizedBox(width: AppThemeMetrics.spacingMd),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Cached Data',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$cacheSize MB',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: context.theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppThemeMetrics.spacingMd),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _clearCache(context),
                            icon: const Icon(Icons.delete_sweep_outlined),
                            label: const Text('Clear Cache'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppThemeMetrics.spacingMd),
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(AppThemeMetrics.spacingMd),
                        child: Text(
                          'Cache Types',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      _cacheTypeTile(Icons.chat_outlined, 'Conversations'),
                      _cacheTypeTile(Icons.memory_outlined, 'Memories'),
                      _cacheTypeTile(Icons.person_outlined, 'Profiles'),
                      _cacheTypeTile(Icons.people_outlined, 'Personalities'),
                      _cacheTypeTile(Icons.dashboard_outlined, 'Dashboard'),
                      _cacheTypeTile(Icons.description_outlined, 'Documents'),
                      _cacheTypeTile(Icons.notifications_outlined, 'Notifications'),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _clearCache(BuildContext context) {
    context.read<SettingsBloc>().add(const UpdateSetting(key: 'cache_size', value: 0));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cache cleared')),
    );
  }

  Widget _cacheTypeTile(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      dense: true,
    );
  }
}
