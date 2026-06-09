import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

/// Shared Reusable Widgets Library for Orbit Workforce
/// This file contains common UI elements used across the platform.

class BiometricService {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> authenticate() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
      
      if (!canAuthenticate) return true; // Fallback if device doesn't support biometrics

      return await _auth.authenticate(
        localizedReason: 'Please authenticate to access attendance verification',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }
}

class AppColors {
  static Color get primary => AppState.demoRole.value == UserRole.manager
      ? const Color(0xFF1A237E)
      : const Color(0xFF00796B);

  static const Color background = Color(0xFF0F172A); // Slate 900
  static const Color surface = Color(0xFF1E293B); // Slate 800
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white60;
  static const Color accent = Color(0xFF38BDF8); // Sky blue
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color success = Color(0xFF10B981); // Emerald
}

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isFullWidth;
  final Color? backgroundColor;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isFullWidth = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          if (icon != null) ...[
            const SizedBox(width: 8),
            Icon(icon, size: 18),
          ],
        ],
      ),
    );

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}

class AppTextField extends StatelessWidget {
  final String label;
  final String placeholder;
  final IconData icon;
  final TextEditingController controller;
  final bool obscureText;

  const AppTextField({
    super.key,
    required this.label,
    required this.placeholder,
    required this.icon,
    required this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 18),
              hintText: placeholder,
              hintStyle: TextStyle(color: AppColors.textPrimary.withValues(alpha: 0.3), fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final VoidCallback? onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.actionText,
    this.onActionPressed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, color: AppColors.accent, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                if (actionText != null)
                  TextButton(
                    onPressed: onActionPressed ?? () {},
                    style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0)),
                    child: Row(
                      children: [
                        Text(actionText!, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 14),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const StatusBadge({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}

enum UserRole { employee, manager }

class AppState {
  static final ValueNotifier<bool> isDemoMode = ValueNotifier(true);
  static final ValueNotifier<UserRole> demoRole = ValueNotifier(UserRole.manager);
  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.dark);
  
  // Local User Session
  static final ValueNotifier<Map<String, dynamic>?> currentUser = ValueNotifier(null);
  
  // New Architectural State Flags
  static final ValueNotifier<bool> isEmergencyActive = ValueNotifier(false);
  static final ValueNotifier<bool> isBurnoutRisk = ValueNotifier(false);
  static final ValueNotifier<bool> isClockedIn = ValueNotifier(false);

  // Global Mock Task Data for Demo Session Persistence
  static final ValueNotifier<List<Map<String, dynamic>>> tasks = ValueNotifier([
    {
      "name": "Backlog",
      "tasks": [
        {"t": "Q2 inventory audit", "dept": "Warehouse", "p": "Medium", "pct": 0, "s": "Delivered"},
        {"t": "Onboard new contractors", "dept": "HR", "p": "Low", "pct": 0, "s": "Delivered"},
      ]
    },
    {
      "name": "In Progress",
      "tasks": [
        {"t": "Site B safety inspection", "dept": "Construction", "p": "High", "pct": 65, "s": "Delivered"},
        {"t": "Quarterly compliance report", "dept": "Admin", "p": "High", "pct": 40, "s": "Delivered"},
        {"t": "Driver schedule v3", "dept": "Logistics", "p": "Medium", "pct": 80, "s": "Delivered"},
      ]
    },
    {
      "name": "Review",
      "tasks": [
        {"t": "Updated PPE policy", "dept": "Compliance", "p": "High", "pct": 95, "s": "Delivered"},
      ]
    },
    {
      "name": "Done",
      "tasks": [
        {"t": "May payroll attendance", "dept": "Payroll", "p": "High", "pct": 100, "s": "Achieved"},
        {"t": "Team A monthly review", "dept": "Operations", "p": "Medium", "pct": 100, "s": "Achieved"},
      ]
    },
  ]);
}
