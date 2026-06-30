import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawjati_mobile/core/theme/theme.dart';
import 'package:zawjati_mobile/injection.dart' as di;
import '../bloc/settings_bloc.dart';

class SettingsPrivacyPage extends StatelessWidget {
  const SettingsPrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di.sl<SettingsBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Privacy')),
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
                      SwitchListTile(
                        title: const Text('Biometric Authentication'),
                        subtitle: const Text('Use fingerprint or face to unlock'),
                        value: state.settings.userBiometricEnabled,
                        onChanged: (v) => _update(context, 'user_biometric_enabled', v),
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
