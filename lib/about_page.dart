import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'components_ui.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About Orbit"), elevation: 0, backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Image.asset('assets/logo.png', width: 80, height: 80),
            const SizedBox(height: 24),
            const Text("Orbit Workforce", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text("Version 1.0.0 (Build 2024.1)", style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 48),
            _buildAboutSection(
              context,
              items: [
                _AboutItem(title: "Privacy Policy", onTap: () {}),
                _AboutItem(title: "Terms of Service", onTap: () {}),
                _AboutItem(title: "Open Source Licenses", onTap: () {}),
                _AboutItem(title: "System Status", value: "All Systems Operational"),
              ],
            ),
            const SizedBox(height: 48),
            const Text(
              "© 2026 Orbit Technologies Inc.\nMade with ❤️ by the Orbit Projomise",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 11, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context, {required List<Widget> items}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
      ),
      child: Column(children: items),
    );
  }
}

class _AboutItem extends StatelessWidget {
  final String title;
  final String? value;
  final VoidCallback? onTap;

  const _AboutItem({required this.title, this.value, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null) Text(value!, style: const TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          const Icon(LucideIcons.chevronRight, size: 16, color: Colors.white24),
        ],
      ),
      onTap: onTap,
    );
  }
}
