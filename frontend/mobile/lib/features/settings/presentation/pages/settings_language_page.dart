import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawjati_mobile/injection.dart' as di;
import '../bloc/settings_bloc.dart';

class SettingsLanguagePage extends StatelessWidget {
  const SettingsLanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di.sl<SettingsBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Language')),
        body: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is! SettingsLoaded) {
              return const Center(child: CircularProgressIndicator());
            }
            final current = state.settings.language;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                RadioListTile<String>(
                  title: const Text('English'),
                  subtitle: const Text('English'),
                  value: 'en',
                  groupValue: current,
                  onChanged: (v) => _updateAndPop(context, v!),
                ),
                RadioListTile<String>(
                  title: const Text('العربية'),
                  subtitle: const Text('Arabic'),
                  value: 'ar',
                  groupValue: current,
                  onChanged: (v) => _updateAndPop(context, v!),
                ),
                RadioListTile<String>(
                  title: const Text('Français'),
                  subtitle: const Text('French'),
                  value: 'fr',
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
    context.read<SettingsBloc>().add(UpdateSetting(key: 'language', value: value));
    Navigator.pop(context);
  }
}
