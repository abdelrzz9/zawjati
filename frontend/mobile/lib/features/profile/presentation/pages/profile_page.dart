import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawjati_mobile/core/theme/theme.dart';
import '../bloc/profile_bloc.dart';

class ProfilePage extends StatelessWidget {
  final String? userId;

  const ProfilePage({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              final state = context.read<ProfileBloc>().state;
              if (state is ProfileLoaded) {
                Navigator.pushNamed(
                  context,
                  '/profile/edit',
                  arguments: state.profile,
                );
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProfileError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: AppTheme.spacingMd),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<ProfileBloc>()
                          .add(GetProfileEvent(userId: userId ?? ''));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is ProfileLoaded) {
            final profile = state.profile;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: AppTheme.primaryAccent.withValues(alpha: 0.2),
                      child: Text(
                        profile.nickname.isNotEmpty
                            ? profile.nickname[0].toUpperCase()
                            : '?',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: AppTheme.primaryAccent,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingLg),
                  _buildInfoRow(context, 'Nickname', profile.nickname),
                  _buildInfoRow(context, 'Relationship', profile.relationshipType),
                  _buildInfoRow(context, 'Personality', profile.personality),
                  _buildInfoRow(context, 'Language', profile.language),
                  const SizedBox(height: AppTheme.spacingXl),
                  Text(
                    'Stats',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(context, 'Conversations', '--'),
                      ),
                      const SizedBox(width: AppTheme.spacingSm),
                      Expanded(
                        child: _buildStatCard(context, 'Messages', '--'),
                      ),
                      const SizedBox(width: AppTheme.spacingSm),
                      Expanded(
                        child: _buildStatCard(context, 'Memories', '--'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingSm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.secondaryTextColor,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.primaryAccent,
                ),
          ),
          const SizedBox(height: AppTheme.spacingXs),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
