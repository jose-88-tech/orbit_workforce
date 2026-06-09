import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'components_ui.dart';
import 'profile_page.dart';
import 'security_page.dart';
import 'help_page.dart';
import 'about_page.dart';
import 'landing_page.dart';
import 'database_helper.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Settings',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Profile, security and application preferences.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 32),
              
              _buildSettingsCategory(
                context,
                title: "Account",
                items: [
                  _SettingsItem(
                    icon: LucideIcons.user, 
                    label: "Personal Profile",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage())),
                  ),
                  ListTile(
                    leading: const Icon(LucideIcons.bell, color: AppColors.accent, size: 20),
                    title: const Text("Notification Preference", style: TextStyle(fontSize: 14)),
                    trailing: Switch.adaptive(
                      value: _notificationsEnabled,
                      activeColor: AppColors.primary,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildSettingsCategory(
                context,
                title: "Appearance",
                items: [
                  ValueListenableBuilder<ThemeMode>(
                    valueListenable: AppState.themeMode,
                    builder: (context, mode, _) {
                      bool isDark = mode == ThemeMode.dark;
                      return ListTile(
                        leading: Icon(isDark ? LucideIcons.moon : LucideIcons.sun, color: AppColors.accent, size: 20),
                        title: const Text("Dark Mode", style: TextStyle(fontSize: 14)),
                        trailing: Switch.adaptive(
                          value: isDark,
                          activeColor: AppColors.primary,
                          onChanged: (value) {
                            AppState.themeMode.value = value ? ThemeMode.dark : ThemeMode.light;
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              _buildSettingsCategory(
                context,
                title: "Security",
                items: [
                  _SettingsItem(
                    icon: LucideIcons.shieldCheck, 
                    label: "Security & Access",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SecuritySettingsPage())),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              _buildSettingsCategory(
                context,
                title: "Support & About",
                items: [
                  _SettingsItem(
                    icon: LucideIcons.helpCircle, 
                    label: "Help & Support",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpSupportPage())),
                  ),
                  _SettingsItem(
                    icon: LucideIcons.info, 
                    label: "About App",
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutPage())),
                  ),
                ],
              ),
              
              const SizedBox(height: 48),
              
              // Logout Section moved to Settings as requested
              _buildSettingsCategory(
                context,
                title: "Account Actions",
                items: [
                  ListTile(
                    leading: const Icon(LucideIcons.logOut, color: Colors.redAccent, size: 20),
                    title: const Text("Logout", style: TextStyle(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.bold)),
                    onTap: () async {
                      // Strict Logout Sanitization
                      await DatabaseHelper().secureWipe();
                      AppState.currentUser.value = null;
                      
                      // Navigate back to landing
                      if (context.mounted) {
                        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const LandingPage()),
                          (route) => false,
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCategory(BuildContext context, {required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _SettingsItem({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.accent, size: 20),
      title: Text(label, style: const TextStyle(fontSize: 14)),
      trailing: const Icon(LucideIcons.chevronRight, size: 16),
      onTap: onTap,
    );
  }
}
