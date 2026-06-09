import 'package:flutter/material.dart';
import 'components_ui.dart';
import 'login_page.dart';
import 'main_layout.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logo.png', width: 64, height: 64),
                  const SizedBox(width: 16),
                  const Text(
                    'Orbit',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Workforce Management Platform',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              ),
              const Spacer(),
              
              // Illustration or Premium Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Ready to scale your team?',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Join thousands of organizations using Orbit to automate attendance and tasks.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.5),
                    ),
                    const SizedBox(height: 32),
                    
                    AppButton(
                      label: 'Login / Join Organization',
                      icon: Icons.arrow_forward,
                      onPressed: () {
                        AppState.isDemoMode.value = false;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    TextButton(
                      onPressed: () {
                        AppState.isDemoMode.value = true;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const MainLayoutPage()),
                        );
                      },
                      child: Text(
                        'Continue as Guest (Demo Mode)',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
