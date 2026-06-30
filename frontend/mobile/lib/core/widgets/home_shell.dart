import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../constants/nav_items.dart';
import '../theme/app_theme_colors.dart';
import '../theme/app_theme_metrics.dart';
import '../../features/notifications/presentation/bloc/notifications_bloc.dart';

class HomeShell extends StatelessWidget {
  final Widget child;

  const HomeShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsBloc, NotificationsState>(
      builder: (context, notifState) {
        final unreadCount = notifState is NotificationsLoaded
            ? notifState.totalUnread
            : 0;

        return Scaffold(
          body: child,
          bottomNavigationBar: _BottomNavBar(unreadCount: unreadCount),
        );
      },
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final int unreadCount;

  const _BottomNavBar({required this.unreadCount});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    return Container(
      decoration: const BoxDecoration(
        color: AppThemeColors.surface,
        border: Border(
          top: BorderSide(
            color: AppThemeColors.divider,
            width: AppThemeMetrics.borderHairline,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: navItems.map((data) {
              final isSelected = location.startsWith(data.route);
              final color = isSelected
                  ? AppThemeColors.primaryAccent
                  : AppThemeColors.tabUnselectedText;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (location != data.route) {
                      context.go(data.route);
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            AnimatedContainer(
                              duration: AppThemeMetrics.durationFast,
                              curve: AppThemeMetrics.curveStandard,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppThemeColors.primaryAccent
                                        .withValues(alpha: 0.14)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                  AppThemeMetrics.radiusPill,
                                ),
                              ),
                              child: Icon(
                                isSelected ? data.activeIcon : data.icon,
                                color: color,
                                size: AppThemeMetrics.iconMd,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          data.label,
                          style: TextStyle(
                            color: color,
                            fontSize: 10,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
