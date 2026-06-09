import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'workforce_page.dart';
import 'broadcasts_page.dart';
import 'tasks_page.dart';
import 'settings_page.dart';

/// Central navigation controller for Orbit Workforce
class NavigationShell extends StatefulWidget {
  const NavigationShell({super.key});

  @override
  State<NavigationShell> createState() => NavigationShellState();
}

class NavigationShellState extends State<NavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(), // Home page
    const WorkforcePage(), // Workers Hub
    const TasksPage(),     // Tasks (Operations Board)
    const BroadcastsPage(),// Notices (Communication Center)
    const SettingsPage(),
  ];

  void switchToPage(int index) {
    if (index >= 0 && index < _pages.length) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _currentIndex,
      children: _pages,
    );
  }
}
