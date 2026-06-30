import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawjati_mobile/core/theme/theme.dart';
import 'package:zawjati_mobile/features/profile/domain/entities/profile.dart';
import '../bloc/profile_bloc.dart';

class ProfileEditPage extends StatefulWidget {
  final UserProfile? profile;

  const ProfileEditPage({super.key, this.profile});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late TextEditingController _nicknameController;
  late String _relationshipType;
  late String _language;

  static const _relationshipTypes = ['companion', 'friend', 'partner', 'custom'];
  static const _languages = ['en', 'ar', 'fr'];

  @override
  void initState() {
    super.initState();
    final profile = widget.profile ??
        UserProfile(
          userId: '',
          nickname: '',
          relationshipType: 'companion',
          personality: '',
          language: 'en',
        );
    _nicknameController = TextEditingController(text: profile.nickname);
    _relationshipType = profile.relationshipType;
    _language = profile.language;
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Save'),
          ),
        ],
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            Navigator.pop(context);
          }
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  labelText: 'Nickname',
                ),
              ),
              const SizedBox(height: AppTheme.spacingLg),
              Text(
                'Relationship Type',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppTheme.spacingSm),
              Wrap(
                spacing: AppTheme.spacingSm,
                runSpacing: AppTheme.spacingSm,
                children: _relationshipTypes.map((type) {
                  final selected = _relationshipType == type;
                  return ChoiceChip(
                    label: Text(type),
                    selected: selected,
                    onSelected: (_) {
                      setState(() => _relationshipType = type);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: AppTheme.spacingLg),
              Text(
                'Language',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppTheme.spacingSm),
              Wrap(
                spacing: AppTheme.spacingSm,
                runSpacing: AppTheme.spacingSm,
                children: _languages.map((lang) {
                  final selected = _language == lang;
                  return ChoiceChip(
                    label: Text(lang.toUpperCase()),
                    selected: selected,
                    onSelected: (_) {
                      setState(() => _language = lang);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    final profile = widget.profile ??
        UserProfile(
          userId: '',
          nickname: '',
          relationshipType: 'companion',
          personality: '',
          language: 'en',
        );
    final updated = profile.copyWith(
      nickname: _nicknameController.text.trim(),
      relationshipType: _relationshipType,
      language: _language,
    );
    context.read<ProfileBloc>().add(
          UpdateProfileEvent(
            userId: profile.userId,
            profile: updated,
          ),
        );
  }
}
