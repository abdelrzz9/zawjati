import 'package:flutter/material.dart';
import '../router/app_routes.dart';

enum NavItem { chat, memory, profile, settings }

class NavItemData {
  final NavItem item;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  const NavItemData({
    required this.item,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}

const List<NavItemData> navItems = [
  NavItemData(
    item: NavItem.chat,
    icon: Icons.chat_bubble_outline,
    activeIcon: Icons.chat_bubble,
    label: 'Chat',
    route: AppRoutes.chat,
  ),
  NavItemData(
    item: NavItem.memory,
    icon: Icons.auto_awesome_outlined,
    activeIcon: Icons.auto_awesome,
    label: 'Memory',
    route: AppRoutes.memories,
  ),
  NavItemData(
    item: NavItem.profile,
    icon: Icons.person_outline,
    activeIcon: Icons.person,
    label: 'Profile',
    route: AppRoutes.profile,
  ),
  NavItemData(
    item: NavItem.settings,
    icon: Icons.settings_outlined,
    activeIcon: Icons.settings,
    label: 'Settings',
    route: AppRoutes.settings,
  ),
];
