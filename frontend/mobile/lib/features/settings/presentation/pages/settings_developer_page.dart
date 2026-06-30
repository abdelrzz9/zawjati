import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawjati_mobile/core/theme/theme.dart';
import 'package:zawjati_mobile/injection.dart' as di;
import '../bloc/settings_bloc.dart';

class SettingsDeveloperPage extends StatelessWidget {
  const SettingsDeveloperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di.sl<SettingsBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Developer')),
        body: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is! SettingsLoaded) {
              return const Center(child: CircularProgressIndicator());
            }
            final s = state.settings;
            return ListView(
              padding: const EdgeInsets.all(AppThemeMetrics.spacingMd),
              children: [
                Card(
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Developer Mode'),
                        subtitle: const Text('Enable developer options'),
                        value: s.developerMode,
                        onChanged: (v) => _update(context, 'developer_mode', v),
                      ),
                      if (s.developerMode) ...[
                        const Divider(height: 1),
                        SwitchListTile(
                          title: const Text('Debug Logging'),
                          subtitle: const Text('Log debug information'),
                          value: s.debugLogging,
                          onChanged: (v) => _update(context, 'debug_logging', v),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.terminal_outlined),
                          title: const Text('Developer Console'),
                          subtitle: const Text('Open developer tools'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.api_outlined),
                          title: const Text('API Configuration'),
                          subtitle: const Text('View API endpoints'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {},
                        ),
                      ],
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

  void _update(BuildContext context, String key, dynamic value) {
    context.read<SettingsBloc>().add(UpdateSetting(key: key, value: value));
  }
}
