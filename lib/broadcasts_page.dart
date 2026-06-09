import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'components_ui.dart';

class BroadcastsPage extends StatefulWidget {
  const BroadcastsPage({super.key});

  @override
  State<BroadcastsPage> createState() => _BroadcastsPageState();
}

class _BroadcastsPageState extends State<BroadcastsPage> {
  final List<Map<String, dynamic>> _broadcasts = [
    {
      "id": "1",
      "tag": "Compliance",
      "title": "Updated Q2 site safety guidelines",
      "body": "All construction staff must review and acknowledge the updated PPE and lift-zone protocols before next shift.",
      "time": "2h ago",
      "ack": 87,
      "total": 100,
      "pinned": true
    },
    {
      "id": "2",
      "tag": "All Staff",
      "title": "Payroll cycle changes for June",
      "body": "Effective June 1, payroll attendance cuts off Sundays at midnight. Adjust personal planners accordingly.",
      "time": "Yesterday",
      "ack": 120,
      "total": 1284,
      "pinned": false
    },
  ];

  void _showBroadcastWizard() {
    String selectedTarget = 'Entire Org';
    final subjectController = TextEditingController();
    final messageController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            top: 24,
            left: 24,
            right: 24,
          ),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Broadcast Wizard", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(LucideIcons.x, color: Colors.white38)),
                  ],
                ),
                const SizedBox(height: 24),
                
                const Text("Target Audience", style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ['Entire Org', 'By Team', 'Selected Individuals'].map((t) => ChoiceChip(
                    label: Text(t, style: TextStyle(color: selectedTarget == t ? Colors.white : AppColors.textSecondary, fontSize: 12)),
                    selected: selectedTarget == t,
                    selectedColor: AppColors.primary,
                    backgroundColor: Colors.white.withValues(alpha: 0.05),
                    onSelected: (val) => setModalState(() => selectedTarget = t),
                  )).toList(),
                ),
                const SizedBox(height: 24),
                
                AppTextField(
                  label: "Subject",
                  placeholder: "e.g. Site Maintenance",
                  icon: LucideIcons.type,
                  controller: subjectController,
                ),
                const SizedBox(height: 16),
                
                AppTextField(
                  label: "Message Content",
                  placeholder: "Enter your announcement here...",
                  icon: LucideIcons.messageSquare,
                  controller: messageController,
                ),
                const SizedBox(height: 32),
                
                AppButton(
                  label: "Deploy Broadcast",
                  icon: LucideIcons.send,
                  onPressed: () {
                    if (subjectController.text.isNotEmpty) {
                      setState(() {
                        _broadcasts.insert(0, {
                          "id": DateTime.now().millisecondsSinceEpoch.toString(),
                          "tag": selectedTarget,
                          "title": subjectController.text,
                          "body": messageController.text,
                          "time": "Just now",
                          "ack": 0,
                          "total": selectedTarget == 'Entire Org' ? 1284 : 15,
                          "pinned": false
                        });
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Broadcast deployed to Communication Center"), backgroundColor: AppColors.success),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _deleteBroadcast(String id) {
    setState(() {
      _broadcasts.removeWhere((b) => b['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Broadcast permanently removed."), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppState.demoRole,
      builder: (context, role, _) {
        final isManager = role == UserRole.manager;
        return Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: isManager 
            ? FloatingActionButton(
                onPressed: _showBroadcastWizard,
                backgroundColor: AppColors.primary,
                child: const Icon(LucideIcons.megaphone, color: Colors.white),
              )
            : null,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Communication Center',
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Company-wide and targeted mission briefings.',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  if (_broadcasts.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: Text("No active broadcasts.", style: TextStyle(color: Colors.white38)),
                      ),
                    )
                  else
                    ..._broadcasts.map((b) => _buildBroadcastCard(b, isManager)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBroadcastCard(Map<String, dynamic> data, bool isManager) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (data['pinned'] == true) ...[
                    const Icon(LucideIcons.pin, size: 12, color: AppColors.accent),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    data['tag'].toString().toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              if (isManager)
                GestureDetector(
                  onTap: () => _deleteBroadcast(data['id']),
                  child: const Icon(LucideIcons.trash2, size: 16, color: Colors.white24),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            data['title'],
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            data['body'],
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data['time'], style: const TextStyle(color: Colors.white38, fontSize: 11)),
              Row(
                children: [
                  const Icon(LucideIcons.eye, size: 12, color: Colors.white38),
                  const SizedBox(width: 6),
                  Text(
                    '${data['ack']} / ${data['total']} Read',
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
