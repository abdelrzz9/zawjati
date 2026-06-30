import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawjati_mobile/injection.dart' as di;
import '../bloc/settings_bloc.dart';

class SettingsThemePage extends StatelessWidget {
  const SettingsThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di.sl<SettingsBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Theme')),
        body: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is! SettingsLoaded) {
              return const Center(child: CircularProgressIndicator());
            }
            final current = state.settings.themeMode;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                RadioListTile<String>(
                  title: const Text('System'),
                  secondary: const Icon(Icons.phone_android_outlined),
                  value: 'system',
                  groupValue: current,
                  onChanged: (v) => _updateAndPop(context, v!),
                ),
                RadioListTile<String>(
                  title: const Text('Light'),
                  secondary: const Icon(Icons.light_mode_outlined),
                  value: 'light',
                  groupValue: current,
                  onChanged: (v) => _updateAndPop(context, v!),
                ),
                RadioListTile<String>(
                  title: const Text('Dark'),
                  secondary: const Icon(Icons.dark_mode_outlined),
                  value: 'dark',
                  groupValue: current,
                  onChanged: (v) => _updateAndPop(context, v!),
                ),
                RadioListTile<String>(
                  title: const Text('AMOLED'),
                  secondary: const Icon(Icons.contrast_outlined),
                  value: 'amoled',
                  groupValue: current,
                  onChanged: (v) => _updateAndPop(context, v!),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _updateAndPop(BuildContext context, String value) {
    context.read<SettingsBloc>().add(UpdateSetting(key: 'theme_mode', value: value));
    Navigator.pop(context);
  }
}
