import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'components_ui.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Help & Support"), elevation: 0, backgroundColor: Colors.transparent),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildHelpCard(
            context,
            icon: LucideIcons.bookOpen,
            title: "Help Center",
            desc: "Browse our documentation and tutorials for Orbit features.",
            onTap: () {},
          ),
          const SizedBox(height: 16),
          _buildHelpCard(
            context,
            icon: LucideIcons.messageSquare,
            title: "Contact Support",
            desc: "Chat with our team or send us an email for direct assistance.",
            onTap: () {},
          ),
          const SizedBox(height: 16),
          _buildHelpCard(
            context,
            icon: LucideIcons.bug,
            title: "Report a Bug",
            desc: "Found an issue? Let us know and we'll fix it as soon as possible.",
            onTap: () {},
          ),
          const SizedBox(height: 32),
          const Center(
            child: Text(
              "Orbit Support is available 24/7 for Enterprise accounts.",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpCard(BuildContext context, {required IconData icon, required String title, required String desc, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.accent.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(icon, color: AppColors.accent, size: 24),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(desc, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4)),
                ],
              ),
            ),
            const Icon(LucideIcons.arrowUpRight, size: 20, color: Colors.white24),
          ],
        ),
      ),
    );
  }
}
