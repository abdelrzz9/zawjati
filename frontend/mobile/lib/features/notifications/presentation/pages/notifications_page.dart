import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawjati_mobile/core/theme/app_theme_colors.dart';
import 'package:zawjati_mobile/core/theme/app_theme_metrics.dart';
import 'package:zawjati_mobile/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationsBloc>().add(LoadNotifications());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          BlocBuilder<NotificationsBloc, NotificationsState>(
            builder: (context, state) {
              if (state is NotificationsLoaded && state.totalUnread > 0) {
                return TextButton(
                  onPressed: () {
                    context.read<NotificationsBloc>().add(MarkAllRead());
                  },
                  child: const Text('Mark all read'),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsInitial || state is NotificationsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is NotificationsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppThemeMetrics.spacingLg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.notifications_off_outlined,
                      size: AppThemeMetrics.iconLg * 2,
                      color: AppThemeColors.hintText,
                    ),
                    const SizedBox(height: AppThemeMetrics.spacingMd),
                    Text(
                      state.message,
                      style: TextStyle(
                        color: AppThemeColors.hintText,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppThemeMetrics.spacingLg),
                    ElevatedButton(
                      onPressed: () {
                        context.read<NotificationsBloc>().add(LoadNotifications());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is NotificationsLoaded) {
            if (state.notifications.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppThemeMetrics.spacingLg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.notifications_none_rounded,
                        size: AppThemeMetrics.iconLg * 2,
                        color: AppThemeColors.hintText,
                      ),
                      const SizedBox(height: AppThemeMetrics.spacingMd),
                      Text(
                        'No notifications yet',
                        style: TextStyle(
                          color: AppThemeColors.secondaryText,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppThemeMetrics.spacingSm),
                      Text(
                        'We\'ll notify you when something arrives.',
                        style: TextStyle(
                          color: AppThemeColors.hintText,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: AppThemeMetrics.spacingMd,
                vertical: AppThemeMetrics.spacingSm,
              ),
              itemCount: state.notifications.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppThemeMetrics.spacingSm),
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                final timeStr = _formatTime(notification.createdAt);
                return Dismissible(
                  key: ValueKey(notification.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: AppThemeMetrics.spacingMd),
                    decoration: BoxDecoration(
                      color: AppThemeColors.success.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppThemeMetrics.radiusLg),
                    ),
                    child: Icon(
                      Icons.check_circle_outline,
                      color: AppThemeColors.success,
                    ),
                  ),
                  onDismissed: (_) {
                    if (!notification.read) {
                      context.read<NotificationsBloc>().add(MarkRead(notification.id));
                    }
                  },
                  child: GestureDetector(
                    onTap: () {
                      if (!notification.read) {
                        context.read<NotificationsBloc>().add(MarkRead(notification.id));
                      }
                    },
                    child: AnimatedContainer(
                      duration: AppThemeMetrics.durationFast,
                      curve: AppThemeMetrics.curveStandard,
                      padding: const EdgeInsets.all(AppThemeMetrics.spacingMd),
                      decoration: BoxDecoration(
                        color: notification.read
                            ? AppThemeColors.surface
                            : AppThemeColors.selected.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(AppThemeMetrics.radiusLg),
                        border: Border.all(
                          color: notification.read
                              ? AppThemeColors.border
                              : AppThemeColors.primaryAccent.withValues(alpha: 0.2),
                          width: AppThemeMetrics.borderHairline,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _iconColor(notification.type).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
                            ),
                            child: Icon(
                              _iconForType(notification.type),
                              color: _iconColor(notification.type),
                              size: AppThemeMetrics.iconMd,
                            ),
                          ),
                          const SizedBox(width: AppThemeMetrics.spacingMd),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        notification.title,
                                        style: TextStyle(
                                          color: AppThemeColors.primaryText,
                                          fontSize: 14,
                                          fontWeight: notification.read
                                              ? FontWeight.w500
                                              : FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: AppThemeMetrics.spacingSm),
                                    Text(
                                      timeStr,
                                      style: TextStyle(
                                        color: AppThemeColors.hintText,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppThemeMetrics.spacingXs),
                                Text(
                                  notification.body,
                                  style: TextStyle(
                                    color: AppThemeColors.secondaryText,
                                    fontSize: 13,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          if (!notification.read)
                            Padding(
                              padding: const EdgeInsets.only(left: AppThemeMetrics.spacingSm),
                              child: Container(
                                width: AppThemeMetrics.notifDotSize,
                                height: AppThemeMetrics.notifDotSize,
                                decoration: BoxDecoration(
                                  color: AppThemeColors.primaryAccent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'message':
        return Icons.message_outlined;
      case 'memory':
        return Icons.auto_stories_outlined;
      case 'system':
        return Icons.settings_outlined;
      case 'alert':
        return Icons.warning_amber_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _iconColor(String type) {
    switch (type) {
      case 'message':
        return AppThemeColors.info;
      case 'memory':
        return AppThemeColors.success;
      case 'system':
        return AppThemeColors.warning;
      case 'alert':
        return AppThemeColors.error;
      default:
        return AppThemeColors.primaryAccent;
    }
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM d').format(dt);
  }
}
