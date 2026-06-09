import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'components_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'database_helper.dart';

class AttendanceSheet extends StatefulWidget {
  const AttendanceSheet({super.key});

  @override
  State<AttendanceSheet> createState() => _AttendanceSheetState();
}

class _AttendanceSheetState extends State<AttendanceSheet> {
  bool _isLoading = false;
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _showManualEntry() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text("Manual Code Entry", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: _codeController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Enter Site Code (e.g. SITE-A-123)",
            hintStyle: TextStyle(color: Colors.white38),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              final code = _codeController.text.trim();
              Navigator.pop(context);
              if (code.isNotEmpty) {
                _validateAndClockIn(code, 'MANUAL_ENTRY');
              }
            },
            child: const Text("Validate"),
          ),
        ],
      ),
    );
  }

  void _showQRScanner() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text("Scan Site QR"),
          leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        ),
        body: MobileScanner(
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            if (barcodes.isNotEmpty) {
              final String? code = barcodes.first.rawValue;
              Navigator.pop(context);
              if (code != null) {
                _validateAndClockIn(code, 'QR_SCAN');
              }
            }
          },
        ),
      ),
    );
  }

  Future<void> _validateAndClockIn(String code, String method) async {
    setState(() => _isLoading = true);
    
    final site = await DatabaseHelper().validateSiteCode(code);
    
    if (site != null) {
      await _completeAttendance('CLOCK_IN', site['site_name'], method);
    } else {
      setState(() => _isLoading = false);
      _showError("Invalid Site Code. Access Denied.");
    }
  }

  Future<void> _completeAttendance(String type, String siteName, String method) async {
    final user = AppState.currentUser.value;
    final now = DateTime.now();
    
    try {
      if (!AppState.isDemoMode.value && user != null) {
        await DatabaseHelper().insertAttendance({
          'user_id': user['id'],
          'user_email': user['email'],
          'action_type': type,
          'timestamp': now.toIso8601String(),
          'site_location': siteName,
          'selfie_url': 'none', // Removed selfie requirement for this refactor as per user flow description
          'location_status': 'verified',
          'is_on_time': now.hour < 9 ? 1 : 0,
          'method': method,
        });
      }

      if (mounted) {
        setState(() {
          AppState.isClockedIn.value = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Success: $type at $siteName verified via SQLite"), backgroundColor: AppColors.success),
        );
        Navigator.pop(context); // Close the sheet upon success
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 24),
          const Text("Local Attendance Verification", style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("Choose validation method to proceed", style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          const SizedBox(height: 32),
          
          if (_isLoading)
            Center(child: Padding(padding: const EdgeInsets.all(20), child: CircularProgressIndicator(color: AppColors.primary)))
          else
            Column(
              children: [
                _AttendanceOption(
                  icon: LucideIcons.qrCode,
                  label: "QR Scan",
                  description: "Scan the site's unique QR code",
                  onTap: _showQRScanner,
                ),
                const SizedBox(height: 16),
                _AttendanceOption(
                  icon: LucideIcons.keyboard,
                  label: "Manual Code Entry",
                  description: "Enter the site code manually",
                  onTap: _showManualEntry,
                ),
              ],
            ),
          
          const SizedBox(height: 32),
          AppButton(
            label: "Cancel",
            onPressed: () => Navigator.pop(context),
            backgroundColor: Colors.white.withValues(alpha: 0.1),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _AttendanceOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final VoidCallback onTap;

  const _AttendanceOption({
    required this.icon,
    required this.label,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(description, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            const Icon(LucideIcons.chevronRight, color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}
