import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'components_ui.dart';

class SecuritySettingsPage extends StatelessWidget {
  const SecuritySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Security"), elevation: 0, backgroundColor: Colors.transparent),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSecuritySection(
            context,
            title: "Access",
            items: [
              _SecurityItem(
                icon: LucideIcons.key,
                title: "Change Password",
                subtitle: "Update your account password regularly",
                onTap: () {},
              ),
              _SecurityItem(
                icon: LucideIcons.shieldCheck,
                title: "Two-Factor Auth",
                subtitle: "Add an extra layer of security",
                trailing: Switch(value: true, activeColor: AppColors.primary, onChanged: (v) {}),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSecuritySection(
            context,
            title: "Devices",
            items: [
              _SecurityItem(
                icon: LucideIcons.smartphone,
                title: "Login Activity",
                subtitle: "See where you are signed in",
                onTap: () {},
              ),
              _SecurityItem(
                icon: LucideIcons.fingerprint,
                title: "Biometric Lock",
                subtitle: "Use fingerprint to open Orbit",
                trailing: Switch(value: false, activeColor: AppColors.primary, onChanged: (v) {}),
              ),
            ],
          ),
          const SizedBox(height: 32),
          AppButton(
            label: "Sign out from all devices",
            backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySection(BuildContext context, {required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }
}

class _SecurityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SecurityItem({required this.icon, required this.title, required this.subtitle, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      trailing: trailing ?? const Icon(LucideIcons.chevronRight, size: 16, color: Colors.white24),
      onTap: onTap,
    );
  }
}
