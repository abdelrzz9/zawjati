import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawjati_mobile/core/theme/theme.dart';
import 'package:zawjati_mobile/injection.dart' as di;
import '../bloc/settings_bloc.dart';

class SettingsVoicePage extends StatelessWidget {
  const SettingsVoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di.sl<SettingsBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Voice Settings')),
        body: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is! SettingsLoaded) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView(
              padding: const EdgeInsets.all(AppThemeMetrics.spacingMd),
              children: [
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.mic_outlined),
                        title: const Text('Voice Input'),
                        subtitle: const Text('Configure voice input settings'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.volume_up_outlined),
                        title: const Text('Voice Output'),
                        subtitle: const Text('Configure text-to-speech settings'),
                      ),
                      const Divider(height: 1),
                      SwitchListTile(
                        title: const Text('Streaming'),
                        subtitle: const Text('Enable streaming voice responses'),
                        value: state.settings.streamingEnabled,
                        onChanged: (v) => _update(context, 'streaming_enabled', v),
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
