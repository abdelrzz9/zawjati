import 'package:flutter/material.dart';
import '../router/app_routes.dart';

enum NavItem { events, gallery, notifications, account }

class NavItemData {
  final NavItem item;
  final IconData icon;
  final String label;
  final String route;

  const NavItemData({
    required this.item,
    required this.icon,
    required this.label,
    required this.route,
  });
}

const List<NavItemData> navItems = [
  NavItemData(
    item: NavItem.events,
    icon: Icons.calendar_month_outlined,
    label: 'EVENTS',
    route: AppRoutes.events,
  ),
  NavItemData(
    item: NavItem.gallery,
    icon: Icons.image_outlined,
    label: 'GALLERY',
    route: AppRoutes.gallery,
  ),
  NavItemData(
    item: NavItem.notifications,
    icon: Icons.notifications_outlined,
    label: 'ALERTS',
    route: AppRoutes.notifications,
  ),
  NavItemData(
    item: NavItem.account,
    icon: Icons.person_outline,
    label: 'ACCOUNT',
    route: AppRoutes.account,
  ),
];
