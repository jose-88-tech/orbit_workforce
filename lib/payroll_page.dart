import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'components_ui.dart';

class PayrollPage extends StatelessWidget {
  const PayrollPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Payroll Tracking',
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Attendance accumulation, approved hours, payout stages.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 48),
              
              Center(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(48),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            )
                          ],
                        ),
                        child: const Icon(LucideIcons.construction, color: Colors.white, size: 24),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Coming next",
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "This module is part of the full build. The dashboard shell, navigation, and key surfaces are ready — wire data and flows in the next iteration.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.5),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
