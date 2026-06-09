import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'components_ui.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile picture updated locally"), backgroundColor: AppColors.success),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error picking image: ${e.toString()}"), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Update Profile Picture", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ImagePickerOption(
                    icon: LucideIcons.camera,
                    label: "Camera",
                    onTap: () => _pickImage(ImageSource.camera),
                  ),
                  _ImagePickerOption(
                    icon: LucideIcons.image,
                    label: "Gallery",
                    onTap: () => _pickImage(ImageSource.gallery),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AppState.currentUser.value;
    final String name = user?['full_name'] ?? "User";
    final String email = user?['email'] ?? "no-email@orbit.com";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppColors.primary,
                    backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null,
                    child: _selectedImage == null 
                        ? Text(name[0], style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold))
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _showImagePicker(context),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                          border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 3),
                        ),
                        child: const Icon(LucideIcons.camera, size: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => _showImagePicker(context),
              child: const Text("Change Photo", style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 32),
            AppTextField(
              label: "Full Name",
              placeholder: name,
              icon: LucideIcons.user,
              controller: TextEditingController(text: name),
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: "Email Address",
              placeholder: email,
              icon: LucideIcons.mail,
              controller: TextEditingController(text: email),
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: "Phone Number",
              placeholder: "+1 234 567 890",
              icon: LucideIcons.phone,
              controller: TextEditingController(),
            ),
            const SizedBox(height: 32),
            AppButton(
              label: "Save Changes",
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImagePickerOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ImagePickerOption({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
