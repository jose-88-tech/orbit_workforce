import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'register_page.dart';
import 'main_layout.dart';
import 'components_ui.dart';
import 'database_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;

  Future<void> _handleForgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your email first"), backgroundColor: Colors.orangeAccent),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password reset email sent!"), backgroundColor: AppColors.success),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}"), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() => _isLoading = true);
    try {
      final user = await DatabaseHelper().loginUser(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (user != null) {
        AppState.currentUser.value = user;
        AppState.isDemoMode.value = false;
        AppState.demoRole.value = user['role'] == 'manager' ? UserRole.manager : UserRole.employee;

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainLayoutPage()),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid email or password"), backgroundColor: Colors.redAccent),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("An unexpected error occurred"), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset('assets/logo.png', width: 40, height: 40),
                    const SizedBox(width: 8),
                    const Text(
                      'Orbit',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Workforce',
                      style: TextStyle(color: AppColors.primary, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Text(
                  'Welcome back',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sign in to your local workspace.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
                const SizedBox(height: 32),
                AppTextField(
                  label: 'Work Email',
                  placeholder: 'work@company.com',
                  icon: Icons.mail_outline,
                  controller: _emailController,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Password',
                  placeholder: '••••••••',
                  icon: Icons.lock_outline,
                  controller: _passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: _rememberMe,
                            activeColor: AppColors.primary,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Remember me',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: _handleForgotPassword,
                      child: Text(
                        'Forgot?',
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _isLoading 
                  ? Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : AppButton(
                      label: 'Sign in',
                      icon: Icons.arrow_forward,
                      onPressed: _signIn,
                    ),
                const SizedBox(height: 24),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'New to Orbit? ',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterPage()),
                          );
                        },
                        child: Text(
                          'Create an account',
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
      ),
    );
  }
}
