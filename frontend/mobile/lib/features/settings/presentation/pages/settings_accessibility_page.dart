import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawjati_mobile/core/theme/theme.dart';
import 'package:zawjati_mobile/injection.dart' as di;
import '../bloc/settings_bloc.dart';

class SettingsAccessibilityPage extends StatelessWidget {
  const SettingsAccessibilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di.sl<SettingsBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Accessibility')),
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
                        title: const Text('Reduced Motion'),
                        subtitle: const Text('Minimize animations and transitions'),
                        value: s.reducedMotion,
                        onChanged: (v) => _update(context, 'reduced_motion', v),
                      ),
                      const Divider(height: 1),
                      SwitchListTile(
                        title: const Text('High Contrast'),
                        subtitle: const Text('Increase contrast for better visibility'),
                        value: s.highContrast,
                        onChanged: (v) => _update(context, 'high_contrast', v),
                      ),
                      const Divider(height: 1),
                      SwitchListTile(
                        title: const Text('Large Text'),
                        subtitle: const Text('Increase text size for better readability'),
                        value: s.largeText,
                        onChanged: (v) => _update(context, 'large_text', v),
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
