import 'package:flutter/material.dart';
import 'components_ui.dart';
import 'main_layout.dart';
import 'database_helper.dart';
import 'package:uuid/uuid.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _mode = "create"; // "create" or "join"
  bool _isLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _orgController = TextEditingController();
  final TextEditingController _inviteController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _orgController.dispose();
    _inviteController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    setState(() => _isLoading = true);
    try {
      final String userId = const Uuid().v4();
      final Map<String, dynamic> user = {
        'id': userId,
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(), // In a real app, hash this!
        'full_name': _nameController.text.trim(),
        'role': _mode == "create" ? 'manager' : 'employee',
        'org_name': _mode == "create" ? _orgController.text.trim() : 'Joined Org',
      };

      await DatabaseHelper().registerUser(user);
      
      AppState.currentUser.value = user;
      AppState.isDemoMode.value = false;
      AppState.demoRole.value = user['role'] == 'manager' ? UserRole.manager : UserRole.employee;

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainLayoutPage()),
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
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/logo.png', width: 36, height: 36),
                      const SizedBox(width: 8),
                      const Text(
                        'Orbit',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Create your account',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Local SQLite Backend (No WiFi Required)',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            _buildToggleItem("Create Organization", "create"),
                            _buildToggleItem("Join with Code", "join"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      AppTextField(
                        label: 'Full Name',
                        placeholder: '......',
                        icon: Icons.person_outline,
                        controller: _nameController,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Work Email',
                        placeholder: 'alex@company.com',
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
                      if (_mode == "create")
                        AppTextField(
                          label: 'Organization Name',
                          placeholder: 'Acme Industries',
                          icon: Icons.business,
                          controller: _orgController,
                        )
                      else
                        AppTextField(
                          label: 'Invite Code',
                          placeholder: 'ORG-EMP-4829',
                          icon: Icons.vpn_key_outlined,
                          controller: _inviteController,
                        ),
                      const SizedBox(height: 24),
                      _isLoading
                        ? Center(child: CircularProgressIndicator(color: AppColors.primary))
                        : AppButton(
                            label: 'Continue',
                            icon: Icons.arrow_forward,
                            onPressed: _signUp,
                          ),
                      const SizedBox(height: 20),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already on Orbit? ', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Text(
                                'Sign in',
                                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                          ],
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

  Widget _buildToggleItem(String label, String value) {
    bool isActive = _mode == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _mode = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.textSecondary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
