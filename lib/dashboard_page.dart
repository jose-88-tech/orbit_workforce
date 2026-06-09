import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'components_ui.dart';
import 'activities_page.dart';
import 'workforce_page.dart';
import 'broadcasts_page.dart';
import 'analytics_page.dart';
import 'attendance_sheet.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // 🕒 Shift Punch Card State Variables - handled by AppState.isClockedIn

  void _handleClockIn() async {
    bool authenticated = await BiometricService.authenticate();
    if (authenticated && mounted) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => const AttendanceSheet(),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication failed'), backgroundColor: Colors.redAccent),
      );
    }
  }

  void _handleClockOut() {
    if (!AppState.isClockedIn.value) return;
    AppState.isClockedIn.value = false;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: const Text('Shift ended!'), backgroundColor: AppColors.primary),
    );
  }

  void _showAddStaffModal() {
    final emailController = TextEditingController();
    String? generatedCode;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            top: 24, left: 24, right: 24,
          ),
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Add New Staff", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(LucideIcons.x, color: Colors.white38)),
                ],
              ),
              const SizedBox(height: 24),
              
              // Option 1: Organization Code
              const Text("ORGANIZATION INVITE CODE", style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              const SizedBox(height: 12),
              if (generatedCode == null)
                AppButton(
                  label: "Generate Organization Code",
                  icon: LucideIcons.refreshCw,
                  onPressed: () {
                    final random = Random();
                    final code = "ORG-${random.nextInt(9000) + 1000}";
                    setModalState(() => generatedCode = code);
                  },
                )
              else
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Text(generatedCode!, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2)),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(LucideIcons.copy, color: AppColors.accent, size: 20),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: generatedCode!));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Invite code copied to clipboard!"), backgroundColor: AppColors.success),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              
              const SizedBox(height: 32),
              const Center(child: Text("— OR —", style: TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold))),
              const SizedBox(height: 32),

              // Option 2: Email Invite
              AppTextField(
                label: "Invite via Email",
                placeholder: "staff@company.com",
                icon: LucideIcons.mail,
                controller: emailController,
              ),
              const SizedBox(height: 24),
              AppButton(
                label: "Send Email Invite",
                icon: LucideIcons.send,
                onPressed: () {
                  if (emailController.text.isNotEmpty) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Invite sent to ${emailController.text}"), backgroundColor: AppColors.success),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppState.isDemoMode,
      builder: (context, isDemo, _) {
        return ValueListenableBuilder(
          valueListenable: AppState.demoRole,
          builder: (context, role, _) {
            final user = isDemo ? null : AppState.currentUser.value;
            
            // Name Logic: Auth vs Guest
            String displayName = isDemo ? (role == UserRole.manager ? "Demo Manager" : "Demo Employee") : "Member";
            if (!isDemo && user != null) {
              displayName = user['full_name'] ?? user['email']?.split('@')[0] ?? "Member";
            }

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isDemo) _buildDemoBanner(),
                    _buildHeroHeader(displayName, role),
                    const SizedBox(height: 16),
                    _buildQuickLaunchBar(role),
                    const SizedBox(height: 24),
                    _buildMorningBriefCard(),
                    const SizedBox(height: 24),
                    if (role == UserRole.manager) ...[
                      _buildStatsGrid(),
                      const SizedBox(height: 24),
                    ],
                    _buildModularPanelsGrid(context, role),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDemoBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, color: AppColors.primary, size: 14),
          const SizedBox(width: 8),
          const Text('Viewing in Demo Mode.', style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildHeroHeader(String name, UserRole role) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('HOME', style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        const SizedBox(height: 6),
        Text('Hello, $name 👋', style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildQuickLaunchBar(UserRole role) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppState.isClockedIn,
      builder: (context, isClockedIn, _) {
        return SizedBox(
          height: 60,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              if (role == UserRole.employee) ...[
                _buildQuickAction(LucideIcons.clock, isClockedIn ? "Clock Out" : "Clock In", isClockedIn ? _handleClockOut : _handleClockIn),
              ],
              _buildQuickAction(LucideIcons.userPlus, "Add Staff", _showAddStaffModal),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickAction(IconData icon, String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMorningBriefCard() {
    return DashboardCard(
      title: 'Morning Brief',
      icon: LucideIcons.sun,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Your day at a glance:', style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 12),
          _buildBriefItem(LucideIcons.users, "94% of workforce on-shift today."),
          _buildBriefItem(LucideIcons.checkCircle, "3 tasks due for completion."),
          _buildBriefItem(LucideIcons.megaphone, "2 new broadcasts require attention."),
        ],
      ),
    );
  }

  Widget _buildBriefItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.accent),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12))),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.4,
      children: const [
        _StatCard(icon: Icons.people, label: 'Total Workers', value: '1,284', trend: '+12%', color: AppColors.success),
        _StatCard(icon: Icons.assignment_turned_in, label: 'Efficiency', value: '89%', trend: '+4.5%', color: AppColors.success),
        _StatCard(icon: Icons.trending_up, label: 'Productivity', value: '8.7', trend: '+0.4', color: AppColors.success),
        _StatCard(icon: Icons.health_and_safety, label: 'Burnout Risk', value: '3 staff', trend: 'Caution', color: AppColors.warning),
      ],
    );
  }

  Widget _buildModularPanelsGrid(BuildContext context, UserRole role) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 900 ? 3 : (constraints.maxWidth > 600 ? 2 : 1);
        final panels = <Widget>[];
        if (role == UserRole.manager) {
          panels.addAll([
            _buildTeamActivityPanel(context), 
            _buildPayrollStatusPanel(), 
            _buildBurnoutWarningsPanel(context)
          ]);
        }
        panels.addAll([_buildTasksSummaryPanel(), _buildBroadcastHighlightsPanel(context)]);
        if (role == UserRole.manager) panels.add(_buildUpcomingSchedulePanel(context));

        return GridView.count(
          shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: crossAxisCount, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.9,
          children: panels,
        );
      },
    );
  }

  Widget _buildTasksSummaryPanel() {
    final tasks = [{"title": "Safety inspection", "dept": "Const.", "pct": 65}, {"title": "Onboarding", "dept": "HR", "pct": 20}];
    return DashboardCard(
      title: 'Active Tasks', icon: Icons.assignment_outlined,
      child: Column(
        children: tasks.map((t) => Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t['title'].toString(), style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis), Text(t['dept'].toString(), style: const TextStyle(color: Colors.white38, fontSize: 10))])),
            Text('${t['pct']}%', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
          ]),
        )).toList(),
      ),
    );
  }

  Widget _buildTeamActivityPanel(BuildContext context) {
    final events = [{"name": "John Juma.", "action": "Clocked in", "time": "2m ago"}, {"name": "Priya R.", "action": "Task submit", "time": "8m ago"}];
    return DashboardCard(
      title: 'Team Activity', icon: Icons.group_outlined,
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const WorkforcePage())),
      child: Column(children: events.map((e) => Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Row(children: [Container(width: 32, height: 32, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary), child: const Icon(Icons.person, size: 16, color: Colors.white)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(e['name']!, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)), Text(e['action']!, style: const TextStyle(color: Colors.white38, fontSize: 11))])), Text(e['time']!, style: const TextStyle(color: Colors.white38, fontSize: 10))]),
      )).toList()),
    );
  }

  Widget _buildPayrollStatusPanel() {
    return DashboardCard(
      title: 'Payroll', icon: Icons.wallet,
      child: Center(child: Column(children: [
        const SizedBox(height: 8),
        Stack(alignment: Alignment.center, children: [SizedBox(width: 70, height: 70, child: CircularProgressIndicator(value: 0.68, strokeWidth: 8, backgroundColor: Colors.white.withValues(alpha: 0.05), valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary))), const Text('68%', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))]),
        const SizedBox(height: 14),
        const Text('Payout in 12 days', style: TextStyle(color: Colors.white38, fontSize: 11)),
      ])),
    );
  }

  Widget _buildBurnoutWarningsPanel(BuildContext context) {
    final warnings = [{"name": "Janet Nduta.", "risk": "62 hrs/wk", "level": "High"}];
    return DashboardCard(
      title: 'Burnout Risk', icon: Icons.heart_broken_outlined,
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AnalyticsPage())),
      child: Column(children: warnings.map((b) => Container(
        margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.warning.withValues(alpha: 0.15))),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(b['name']!, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)), Text(b['risk']!, style: const TextStyle(color: Colors.white38, fontSize: 11))]), StatusBadge(label: b['level']!, color: Colors.redAccent)]),
      )).toList()),
    );
  }

  Widget _buildUpcomingSchedulePanel(BuildContext context) {
    final schedule = [{"time": "14:00", "label": "Site B handover"}];
    return DashboardCard(
      title: 'Schedule', icon: Icons.calendar_month_outlined,
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ActivitiesPage())),
      child: Column(children: schedule.map((s) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [Container(width: 50, padding: const EdgeInsets.symmetric(vertical: 4), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(6)), child: Text(s['time']!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))), const SizedBox(width: 12), Expanded(child: Text(s['label']!, style: const TextStyle(color: Colors.white, fontSize: 12)))]),
      )).toList()),
    );
  }

  Widget _buildBroadcastHighlightsPanel(BuildContext context) {
    return DashboardCard(
      title: 'Broadcasts', icon: Icons.campaign_outlined,
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BroadcastsPage())),
      child: Container(
        width: double.infinity, padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primary.withValues(alpha: 0.2))),
        child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('PINNED', style: TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.bold)), SizedBox(height: 4), Text('Site safety guidelines', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)), SizedBox(height: 4), Text('Ack by 87%', style: TextStyle(color: Colors.white38, fontSize: 10))]),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon; final String label; final String value; final String trend; final Color color;
  const _StatCard({required this.icon, required this.label, required this.value, required this.trend, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withValues(alpha: 0.04))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Icon(icon, size: 20, color: AppColors.accent), Text(trend, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600))]),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)), const SizedBox(height: 2), Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold))])
      ]),
    );
  }
}
