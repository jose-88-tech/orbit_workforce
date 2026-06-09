import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'components_ui.dart';

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Activities & Scheduling',
                          style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Company calendar, shifts, and attendance overlays.',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  AppButton(
                    label: "Create shift",
                    icon: LucideIcons.plus,
                    onPressed: () {},
                    isFullWidth: false,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Calendar and Sidebar
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 900) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: _buildCalendarCard()),
                        const SizedBox(width: 24),
                        Expanded(flex: 1, child: _buildSidebar()),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        _buildCalendarCard(),
                        const SizedBox(height: 24),
                        _buildSidebar(),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarCard() {
    final days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    final dates = List.generate(35, (i) => i - 2);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(LucideIcons.calendar, size: 16, color: AppColors.accent),
                  SizedBox(width: 8),
                  Text('May 2026', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              Row(
                children: [
                  _buildLegendItem(AppColors.success, "attended"),
                  const SizedBox(width: 12),
                  _buildLegendItem(AppColors.warning, "late"),
                  const SizedBox(width: 12),
                  _buildLegendItem(Colors.redAccent, "absent"),
                ],
              )
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: days.map((d) => Expanded(
              child: Center(
                child: Text(d, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ),
            )).toList(),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dates.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              final n = dates[index];
              final isValid = n > 0 && n <= 31;
              final isToday = n == 29;

              Color? dotColor;
              if (n == 12) {
                dotColor = AppColors.warning;
              } else if (n == 18) {
                dotColor = Colors.redAccent;
              } else if (isValid && n <= 28) {
                dotColor = AppColors.success;
              }


              return Container(
                decoration: BoxDecoration(
                  color: isValid ? Colors.white.withValues(alpha: 0.04) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: isToday ? Border.all(color: AppColors.primary, width: 2) : null,
                ),
                child: !isValid ? null : Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        n.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (dotColor != null)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
                        ),
                      )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
      ],
    );
  }

  Widget _buildSidebar() {
    return Column(
      children: [
        _buildShiftsPanel(),
        const SizedBox(height: 24),
        _buildPatternsPanel(),
      ],
    );
  }

  Widget _buildShiftsPanel() {
    final shifts = [
      { "t": "06:00–14:00", "label": "Morning · Site B", "n": 24 },
      { "t": "14:00–22:00", "label": "Afternoon · Site B", "n": 22 },
      { "t": "22:00–06:00", "label": "Night · Warehouse", "n": 12 },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Today's shifts", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...shifts.map((s) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 90,
                  child: Text(s['t'].toString(), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s['label'].toString(), style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                      Text("${s['n']} assigned", style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                    ],
                  ),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildPatternsPanel() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Recurring patterns", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildPatternRow("Weekday mornings", "Mon–Fri"),
          const SizedBox(height: 12),
          _buildPatternRow("Weekend nights", "Sat–Sun"),
        ],
      ),
    );
  }

  Widget _buildPatternRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
        Text(value, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ],
    );
  }
}
