import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/nav_items.dart';
import '../theme/app_theme_colors.dart';
import '../theme/app_theme_metrics.dart';

class AppBottomNavBar extends StatelessWidget {
  final String currentRoute;

  const AppBottomNavBar({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppThemeColors.background,
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
              final isSelected = currentRoute.startsWith(data.route);

              return _NavBarItem(
                icon: data.icon,
                label: data.label,
                isSelected: isSelected,
                onTap: () => context.go(data.route),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? AppThemeColors.primaryAccent
        : AppThemeColors.tabUnselectedText;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: AppThemeMetrics.iconMd),
            const SizedBox(height: AppThemeMetrics.spacingXs),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
