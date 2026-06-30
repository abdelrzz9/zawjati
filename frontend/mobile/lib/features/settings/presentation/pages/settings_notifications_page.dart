import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawjati_mobile/core/theme/theme.dart';
import 'package:zawjati_mobile/injection.dart' as di;
import '../bloc/settings_bloc.dart';

class SettingsNotificationsPage extends StatelessWidget {
  const SettingsNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di.sl<SettingsBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Notifications')),
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
                        title: const Text('Push Notifications'),
                        subtitle: const Text('Receive push notifications'),
                        value: s.pushNotificationsEnabled,
                        onChanged: (v) => _update(context, 'push_notifications_enabled', v),
                      ),
                      const Divider(height: 1),
                      SwitchListTile(
                        title: const Text('Sound'),
                        subtitle: const Text('Play sound for notifications'),
                        value: s.soundEnabled,
                        onChanged: (v) => _update(context, 'sound_enabled', v),
                      ),
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
