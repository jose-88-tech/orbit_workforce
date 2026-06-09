import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'navigation_shell.dart';
import 'components_ui.dart';
import 'attendance_sheet.dart';
import 'landing_page.dart';
import 'database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainLayoutPage extends StatefulWidget {
  const MainLayoutPage({super.key});

  @override
  State<MainLayoutPage> createState() => _MainLayoutPageState();
}

class _MainLayoutPageState extends State<MainLayoutPage> {
  final GlobalKey<NavigationShellState> _navShellKey = GlobalKey<NavigationShellState>();
  int _bottomNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
    if (isFirstTime) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showOnboarding());
      await prefs.setBool('isFirstTime', false);
    }
  }

  void _showOnboarding() {
    showDialog(context: context, barrierDismissible: false, builder: (context) => const OnboardingDialog());
  }

  void _onTabTapped(int index) {
    if (index < 4) {
      setState(() => _bottomNavIndex = index);
    }
    _navShellKey.currentState?.switchToPage(index);
  }

  void _showAttendance() async {
    bool authenticated = await BiometricService.authenticate();
    if (authenticated && mounted) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => const AttendanceSheet(),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication failed'), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(LucideIcons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Row(
          children: [
            Image.asset('assets/logo.png', width: 28, height: 28),
            const SizedBox(width: 8),
            const Text('Orbit', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          ValueListenableBuilder<UserRole>(
            valueListenable: AppState.demoRole,
            builder: (context, role, _) {
              if (role == UserRole.manager) return const SizedBox.shrink();
              return IconButton(
                icon: Icon(LucideIcons.fingerprint, color: AppColors.primary, size: 24),
                onPressed: _showAttendance,
              );
            },
          ),
          IconButton(icon: const Icon(LucideIcons.bell, color: AppColors.textSecondary, size: 20), onPressed: () {}),
          IconButton(
            icon: const Icon(LucideIcons.settings, color: AppColors.textSecondary, size: 20),
            onPressed: () => _onTabTapped(4), // Settings index
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: NavigationShell(key: _navShellKey),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.06)))),
        child: BottomNavigationBar(
          currentIndex: _bottomNavIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.background,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          items: const [
            BottomNavigationBarItem(icon: Icon(LucideIcons.layoutDashboard), label: 'Home page'),
            BottomNavigationBarItem(icon: Icon(LucideIcons.users), label: 'Workers Hub'),
            BottomNavigationBarItem(icon: Icon(LucideIcons.checkSquare), label: 'Operations'),
            BottomNavigationBarItem(icon: Icon(LucideIcons.megaphone), label: 'Communication'),
          ],
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppState.isDemoMode,
      builder: (context, isDemo, _) {
        return ValueListenableBuilder(
          valueListenable: AppState.demoRole,
          builder: (context, role, _) {
            final isManager = role == UserRole.manager;
            final user = isDemo ? null : AppState.currentUser.value;
            
            // Name Logic: Auth vs Guest
            String name = "Guest User";
            if (!isDemo && user != null) {
              name = user['full_name'] ?? user['email']?.split('@')[0] ?? "Member";
            } else if (isDemo) {
              name = isManager ? "Demo Manager" : "Demo Employee";
            }
            
            final String roleTitle = isDemo ? (isManager ? "Site Manager" : "Field Employee") : "Member";

            return Drawer(
              backgroundColor: const Color(0xFF0F172A),
              child: Column(
                children: [
                  if (!isManager || isDemo)
                    DrawerHeader(
                      decoration: const BoxDecoration(color: Color(0xFF1E293B), border: Border(bottom: BorderSide(color: Colors.white10))),
                      child: Row(
                        children: [
                          CircleAvatar(radius: 30, backgroundColor: AppColors.primary, child: Text(name.isNotEmpty ? name[0] : "?", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                                Text(roleTitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 20),
                  _DrawerItem(icon: LucideIcons.banknote, label: 'Payroll', onTap: () => Navigator.pop(context)),
                  _DrawerItem(icon: LucideIcons.shieldCheck, label: 'Compliance', onTap: () => Navigator.pop(context)),

                  if (isDemo) ...[
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Divider(color: Colors.white12)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text('DEMO CONTROLS', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    ),
                    ListTile(
                      leading: Icon(LucideIcons.user, color: role == UserRole.employee ? AppColors.primary : Colors.white70, size: 20),
                      title: Text('View as Employee', style: TextStyle(color: role == UserRole.employee ? Colors.white : Colors.white70, fontSize: 13)),
                      onTap: () { AppState.demoRole.value = UserRole.employee; Navigator.pop(context); },
                    ),
                    ListTile(
                      leading: Icon(LucideIcons.shieldCheck, color: role == UserRole.manager ? AppColors.primary : Colors.white70, size: 20),
                      title: Text('View as Manager', style: TextStyle(color: role == UserRole.manager ? Colors.white : Colors.white70, fontSize: 13)),
                      onTap: () { AppState.demoRole.value = UserRole.manager; Navigator.pop(context); },
                    ),
                  ],

                  const Spacer(),
                  const Divider(color: Colors.white10),
                  
                  _DrawerItem(icon: LucideIcons.logOut, label: 'Logout', isDestructive: true, onTap: () async {
                    // Strict Logout Sanitization
                    await DatabaseHelper().secureWipe();
                    AppState.currentUser.value = null;
                    if (context.mounted) {
                      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const LandingPage()),
                        (route) => false,
                      );
                    }
                  }),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }
}


class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;
  const _DrawerItem({required this.icon, required this.label, required this.onTap, this.isDestructive = false});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.redAccent : AppColors.textSecondary, size: 20),
      title: Text(label, style: TextStyle(color: isDestructive ? Colors.redAccent : Colors.white, fontSize: 14)),
      onTap: onTap,
    );
  }
}

class OnboardingDialog extends StatefulWidget {
  const OnboardingDialog({super.key});
  @override
  State<OnboardingDialog> createState() => _OnboardingDialogState();
}

class _OnboardingDialogState extends State<OnboardingDialog> {
  int _step = 0;
  final List<Map<String, String>> _steps = [
    {"title": "Welcome to Orbit!", "desc": "Your mission control for workforce management is ready."},
    {"title": "Daily Attendance", "desc": "Use the fingerprint icon at the top to open your Attendance Sheet."},
    {"title": "Task Management", "desc": "The Kanban board in your Operations tab keeps track of your work."},
    {"title": "Global Settings", "desc": "Access your profile and organization from the top-right settings icon."}
  ];
  @override
  Widget build(BuildContext context) {
    final stepData = _steps[_step];
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.sparkles, color: AppColors.primary, size: 48),
            const SizedBox(height: 24),
            Text(stepData["title"]!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(stepData["desc"]!, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.5)),
            const SizedBox(height: 32),
            AppButton(
              label: _step == _steps.length - 1 ? "Get Started" : "Next",
              onPressed: () {
                if (_step < _steps.length - 1) { setState(() => _step++); }
                else { Navigator.pop(context); }
              },
            ),
          ],
        ),
      ),
    );
  }
}
