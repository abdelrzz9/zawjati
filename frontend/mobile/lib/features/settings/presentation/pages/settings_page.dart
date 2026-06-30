import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zawjati_mobile/core/theme/theme.dart';
import 'package:zawjati_mobile/core/extensions/context_extensions.dart';
import 'package:zawjati_mobile/injection.dart' as di;
import '../bloc/settings_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di.sl<SettingsBloc>()..add(const LoadSettings()),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatefulWidget {
  const _SettingsView();

  @override
  State<_SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<_SettingsView> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(const LoadSettings());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoaded) {
            return ListView(
              padding: const EdgeInsets.all(AppThemeMetrics.spacingMd),
              children: [
                _buildSection(
                  context,
                  'General',
                  [
                    _SettingsTile(
                      icon: Icons.palette_outlined,
                      title: 'Theme',
                      subtitle: _themeLabel(state.settings.themeMode),
                      onTap: () => context.push('/settings/theme'),
                    ),
                    _SettingsTile(
                      icon: Icons.language_outlined,
                      title: 'Language',
                      subtitle: _languageLabel(state.settings.language),
                      onTap: () => context.push('/settings/language'),
                    ),
                  ],
                ),
                _buildSection(
                  context,
                  'Chat',
                  [
                    _SettingsTile(
                      icon: Icons.speed_outlined,
                      title: 'Streaming',
                      trailing: Switch(
                        value: state.settings.streamingEnabled,
                        onChanged: (v) => _updateSetting('streaming_enabled', v),
                      ),
                    ),
                    _SettingsTile(
                      icon: Icons.animation_outlined,
                      title: 'Animations',
                      trailing: Switch(
                        value: state.settings.animationsEnabled,
                        onChanged: (v) => _updateSetting('animations_enabled', v),
                      ),
                    ),
                  ],
                ),
                _buildSection(
                  context,
                  'Notifications',
                  [
                    _SettingsTile(
                      icon: Icons.notifications_outlined,
                      title: 'Push Notifications',
                      trailing: Switch(
                        value: state.settings.pushNotificationsEnabled,
                        onChanged: (v) => _updateSetting('push_notifications_enabled', v),
                      ),
                    ),
                    _SettingsTile(
                      icon: Icons.volume_up_outlined,
                      title: 'Sound',
                      trailing: Switch(
                        value: state.settings.soundEnabled,
                        onChanged: (v) => _updateSetting('sound_enabled', v),
                      ),
                    ),
                  ],
                ),
                _buildSection(
                  context,
                  'Voice',
                  [
                    _SettingsTile(
                      icon: Icons.mic_outlined,
                      title: 'Voice Settings',
                      onTap: () => context.push('/settings/voice'),
                    ),
                  ],
                ),
                _buildSection(
                  context,
                  'Privacy',
                  [
                    _SettingsTile(
                      icon: Icons.lock_outlined,
                      title: 'Privacy Settings',
                      onTap: () => context.push('/settings/privacy'),
                    ),
                  ],
                ),
                _buildSection(
                  context,
                  'Storage',
                  [
                    _SettingsTile(
                      icon: Icons.storage_outlined,
                      title: 'Storage Usage',
                      subtitle: '${state.settings.cacheSize} MB',
                      onTap: () => context.push('/settings/storage'),
                    ),
                  ],
                ),
                _buildSection(
                  context,
                  'Developer',
                  [
                    _SettingsTile(
                      icon: Icons.code_outlined,
                      title: 'Developer Mode',
                      trailing: Switch(
                        value: state.settings.developerMode,
                        onChanged: (v) => _updateSetting('developer_mode', v),
                      ),
                      onTap: () => context.push('/settings/developer'),
                    ),
                  ],
                ),
                _buildSection(
                  context,
                  'Accessibility',
                  [
                    _SettingsTile(
                      icon: Icons.accessibility_new_outlined,
                      title: 'Accessibility Options',
                      onTap: () => context.push('/settings/accessibility'),
                    ),
                  ],
                ),
                const SizedBox(height: AppThemeMetrics.spacingMd),
                _buildSection(
                  context,
                  'Account',
                  [
                    _SettingsTile(
                      icon: Icons.delete_forever_outlined,
                      title: 'Delete Account',
                      textColor: context.theme.colorScheme.error,
                      onTap: () => _confirmDeleteAccount(context),
                    ),
                  ],
                ),
                const SizedBox(height: AppThemeMetrics.spacingXxl),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _updateSetting(String key, dynamic value) {
    context.read<SettingsBloc>().add(UpdateSetting(key: key, value: value));
  }

  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This action cannot be undone. All your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppThemeMetrics.spacingSm,
            bottom: AppThemeMetrics.spacingSm,
            top: AppThemeMetrics.spacingMd,
          ),
          child: Text(
            title,
            style: context.textTheme.titleSmall?.copyWith(
              color: context.theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Card(
          child: Column(children: children),
        ),
      ],
    );
  }

  String _themeLabel(String mode) {
    switch (mode) {
      case 'light':
        return 'Light';
      case 'dark':
        return 'Dark';
      case 'amoled':
        return 'AMOLED';
      default:
        return 'System';
    }
  }

  String _languageLabel(String code) {
    switch (code) {
      case 'ar':
        return 'العربية';
      case 'fr':
        return 'Français';
      default:
        return 'English';
    }
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Color? textColor;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(title, style: TextStyle(color: textColor)),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
      onTap: onTap,
    );
  }
}
