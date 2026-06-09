import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'components_ui.dart';

class WorkforcePage extends StatefulWidget {
  const WorkforcePage({super.key});

  @override
  State<WorkforcePage> createState() => _WorkforcePageState();
}

class _WorkforcePageState extends State<WorkforcePage> {
  String _selectedDepartment = "All";

  final List<Map<String, String>> _allPeople = [
    { "name": "Joseph Ahadi", "role": "Team Lead", "dept": "Construction", "status": "online", "attendance": "On shift", "needsAttention": "true" },
    { "name": "Promise Michael", "role": "Engineer", "dept": "Operations", "status": "online", "attendance": "On shift", "needsAttention": "false" },
    { "name": "Jane Nduta", "role": "Operator", "dept": "Logistics", "status": "offline", "attendance": "Late", "needsAttention": "true" },
    { "name": "Sara Tominaga", "role": "Coordinator", "dept": "Admin", "status": "online", "attendance": "On shift", "needsAttention": "false" },
    { "name": "Omar Said", "role": "Driver", "dept": "Logistics", "status": "offline", "attendance": "Off duty", "needsAttention": "false" },
    { "name": "stacy Kavonesa", "role": "Operator", "dept": "Warehouse", "status": "online", "attendance": "On shift", "needsAttention": "false" },
  ];

  final List<String> _departments = ["All", "Action Required", "Construction", "Logistics", "Operations", "Warehouse", "Admin"];

  void _showProfile(Map<String, String> person) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.all(24),
          child: ListView(
            controller: controller,
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primary,
                      child: Text(person['name']![0], style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 16),
                    Text(person['name']!, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    Text('${person['role']} · ${person['dept']}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text('RELATIONSHIP TIMELINE', style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              const SizedBox(height: 16),
              _buildTimelineItem("Joined Orbit Workforce", "Jan 12, 2024", LucideIcons.userPlus),
              _buildTimelineItem("Promoted to ${person['role']}", "Mar 05, 2024", LucideIcons.trendingUp),
              _buildTimelineItem("Last Activity Recorded", person['attendance']!, LucideIcons.clock),
              const SizedBox(height: 32),
              AppButton(
                label: "Send Message",
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => MessageForm(userName: person['name']!),
                  );
                },
                icon: LucideIcons.messageSquare,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineItem(String title, String subtitle, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, size: 16, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredPeople = _selectedDepartment == "All"
        ? _allPeople
        : _selectedDepartment == "Action Required"
            ? _allPeople.where((p) => p['needsAttention'] == "true").toList()
            : _allPeople.where((p) => p['dept'] == _selectedDepartment).toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Workers Hub', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Search and filter your entire organization.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 20),

            // Filter Tabs
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _departments.length,
                itemBuilder: (context, index) {
                  final dept = _departments[index];
                  final isSelected = dept == _selectedDepartment;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedDepartment = dept),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isSelected ? Colors.transparent : Colors.white.withValues(alpha: 0.05)),
                        ),
                        child: Center(
                          child: Text(
                            dept,
                            style: TextStyle(color: isSelected ? Colors.white : AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Personnel Grid
            Expanded(
              child: filteredPeople.isEmpty
                  ? const Center(child: Text('No personnel found.', style: TextStyle(color: AppColors.textSecondary)))
                  : GridView.builder(
                itemCount: filteredPeople.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.35,
                ),
                itemBuilder: (context, index) {
                  final person = filteredPeople[index];
                  final isOnline = person['status'] == 'online';

                  return GestureDetector(
                    onTap: () => _showProfile(person),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: AppColors.primary,
                                    child: Text(person['name']![0], style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: isOnline ? AppColors.success : Colors.grey,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: AppColors.surface, width: 1.5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  person['name']!,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Text('${person['role']} · ${person['dept']}', maxLines: 1, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                          const SizedBox(height: 4),
                          StatusBadge(label: person['attendance']!, color: person['attendance'] == 'On shift' ? AppColors.success : AppColors.warning),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageForm extends StatefulWidget {
  final String userName;
  const MessageForm({super.key, required this.userName});

  @override
  State<MessageForm> createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageForm> {
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<bool> _sendMessage(String subject, String message) async {
    // Simulated sending logic
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 24,
        left: 24,
        right: 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Message ${widget.userName}", style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          AppTextField(
            label: "Subject",
            placeholder: "e.g. Schedule Update",
            icon: LucideIcons.type,
            controller: _subjectController,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: "Message Content",
            placeholder: "Type your message here...",
            icon: LucideIcons.messageSquare,
            controller: _messageController,
          ),
          const SizedBox(height: 32),
          _isSending 
            ? const Center(child: CircularProgressIndicator())
            : AppButton(
                label: "Send Message",
                icon: LucideIcons.send,
                onPressed: () async {
                  if (_subjectController.text.isEmpty || _messageController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fill in all fields"), backgroundColor: Colors.orangeAccent),
                    );
                    return;
                  }

                  setState(() => _isSending = true);
                  bool success = await _sendMessage(_subjectController.text, _messageController.text);
                  setState(() => _isSending = false);
                  
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(success ? "Message sent to ${widget.userName}!" : "Failed to send message."),
                        backgroundColor: success ? AppColors.success : Colors.redAccent,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
              ),
        ],
      ),
    );
  }
}
