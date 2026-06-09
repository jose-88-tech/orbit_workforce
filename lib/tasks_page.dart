import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'components_ui.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  void _showCreateTaskModal() {
    final titleController = TextEditingController();
    String selectedPriority = "Medium";
    String selectedColumn = "Backlog";
    String? selectedAssignee;

    // Mock staff list with skills and workload for "Smart" suggestions
    final staff = [
      {"name": "Joseph Ahadi", "skills": "Safety, Civil", "load": 45},
      {"name": "Promise Michael", "skills": "CAD, Design", "load": 78},
      {"name": "Marcus Lee", "skills": "Operations", "load": 30},
      {"name": "Sara Tominaga", "skills": "Admin, HR", "load": 62},
      {"name": "Omar Said", "skills": "Logistics", "load": 20},
      {"name": "Yuki Kato", "skills": "Inventory", "load": 55},
    ];

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
                    const Text("Smart Create Task", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(LucideIcons.x, color: Colors.white38)),
                  ],
                ),
                const SizedBox(height: 24),
                AppTextField(
                  label: "Task Title",
                  placeholder: "e.g. Operations Audit",
                  icon: LucideIcons.type,
                  controller: titleController,
                ),
                const SizedBox(height: 24),
                
                const Text("SUGGESTED STAFF (By Workload)", style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: staff.length,
                    itemBuilder: (context, index) {
                      final s = staff[index];
                      final isSelected = selectedAssignee == s['name'];
                      final int load = s['load'] as int;
                      final Color loadColor = load > 70 ? Colors.redAccent : (load > 40 ? Colors.orangeAccent : Colors.greenAccent);

                      return GestureDetector(
                        onTap: () => setModalState(() => selectedAssignee = s['name'] as String),
                        child: Container(
                          width: 140,
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: isSelected ? AppColors.primary : Colors.white10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(s['name'] as String, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              Text(s['skills'] as String, style: const TextStyle(color: Colors.white38, fontSize: 10), overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(width: 4, height: 4, decoration: BoxDecoration(color: loadColor, shape: BoxShape.circle)),
                                  const SizedBox(width: 4),
                                  Text("$load% load", style: TextStyle(color: loadColor, fontSize: 9, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),
                const Text("Priority", style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                const SizedBox(height: 8),
                Row(
                  children: ["Low", "Medium", "High"].map((p) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(p, style: TextStyle(color: selectedPriority == p ? Colors.white : AppColors.textSecondary, fontSize: 12)),
                      selected: selectedPriority == p,
                      selectedColor: AppColors.primary,
                      backgroundColor: Colors.white.withValues(alpha: 0.05),
                      onSelected: (val) => setModalState(() => selectedPriority = p),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 32),
                AppButton(
                  label: "Deploy Task",
                  icon: LucideIcons.rocket,
                  onPressed: () {
                    if (titleController.text.isNotEmpty) {
                      final currentTasks = List<Map<String, dynamic>>.from(AppState.tasks.value);
                      final colIndex = currentTasks.indexWhere((c) => c['name'] == selectedColumn);
                      
                      if (colIndex != -1) {
                        final tasksInCol = List<Map<String, dynamic>>.from(currentTasks[colIndex]['tasks']);
                        tasksInCol.insert(0, {
                          "t": titleController.text,
                          "dept": selectedAssignee ?? "General",
                          "p": selectedPriority,
                          "pct": 0,
                          "s": "Sent", // Initial Status
                        });
                        
                        currentTasks[colIndex]['tasks'] = tasksInCol;
                        AppState.tasks.value = currentTasks;

                        // Simulate "Delivered" -> "Achieved" lifecycle
                        Future.delayed(const Duration(seconds: 3), () {
                          _updateTaskStatus(titleController.text, "Delivered");
                        });
                        
                        Future.delayed(const Duration(seconds: 7), () {
                          _updateTaskStatus(titleController.text, "Achieved");
                        });
                      }

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Task SENT. Tracking delivery status..."), 
                          backgroundColor: Color(0xFF38BDF8), // Indigo/Accent shade
                        ),
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

  void _updateTaskStatus(String title, String status) {
    if (!mounted) return;
    final currentTasks = List<Map<String, dynamic>>.from(AppState.tasks.value);
    bool updated = false;
    
    for (var i = 0; i < currentTasks.length; i++) {
      final col = Map<String, dynamic>.from(currentTasks[i]);
      final tasks = List<Map<String, dynamic>>.from(col['tasks']);
      bool foundInCol = false;
      
      for (var j = 0; j < tasks.length; j++) {
        if (tasks[j]['t'] == title) {
          tasks[j]['s'] = status;
          if (status == "Achieved") tasks[j]['pct'] = 100;
          if (status == "Delivered") tasks[j]['pct'] = 10;
          foundInCol = true;
          updated = true;
          break;
        }
      }
      
      if (foundInCol) {
        col['tasks'] = tasks;
        currentTasks[i] = col;
        break;
      }
    }
    
    if (updated) {
      AppState.tasks.value = currentTasks;
    }
  }

  void _deleteTask(String title) {
    final currentTasks = List<Map<String, dynamic>>.from(AppState.tasks.value);
    bool updated = false;

    for (var i = 0; i < currentTasks.length; i++) {
      final col = Map<String, dynamic>.from(currentTasks[i]);
      final tasks = List<Map<String, dynamic>>.from(col['tasks']);
      final originalLength = tasks.length;
      
      tasks.removeWhere((task) => task['t'] == title);
      
      if (tasks.length != originalLength) {
        col['tasks'] = tasks;
        currentTasks[i] = col;
        updated = true;
        break;
      }
    }

    if (updated) {
      AppState.tasks.value = currentTasks;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Task removed from board."), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: AppState.demoRole.value == UserRole.manager 
        ? FloatingActionButton(
            onPressed: _showCreateTaskModal,
            backgroundColor: AppColors.primary,
            child: const Icon(LucideIcons.plus, color: Colors.white),
          )
        : null,
      body: SafeArea(
        child: ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable: AppState.tasks,
          builder: (context, columns, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Operations Board', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Real-time task tracking and deployment.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  const SizedBox(height: 24),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = constraints.maxWidth > 1200 ? 4 : (constraints.maxWidth > 600 ? 2 : 1);
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: columns.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          mainAxisExtent: 500,
                        ),
                        itemBuilder: (context, index) {
                          final col = columns[index];
                          return _KanbanColumn(
                            name: col['name'], 
                            tasks: col['tasks'],
                            onDeleteTask: _deleteTask,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _KanbanColumn extends StatelessWidget {
  final String name;
  final List<dynamic> tasks;
  final Function(String) onDeleteTask;
  const _KanbanColumn({required this.name, required this.tasks, required this.onDeleteTask});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: name,
      icon: LucideIcons.listTodo,
      actionText: tasks.length.toString(),
      child: tasks.isEmpty 
        ? const Expanded(child: Center(child: Text("No tasks", style: TextStyle(color: Colors.white24, fontSize: 12))))
        : Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return _TaskItem(
                  title: task['t'],
                  dept: task['dept'],
                  priority: task['p'],
                  pct: task['pct'],
                  status: task['s'],
                  onDelete: () => onDeleteTask(task['t']),
                );
              },
            ),
          ),
    );
  }
}

class _TaskItem extends StatelessWidget {
  final String title;
  final String dept;
  final String priority;
  final int pct;
  final String? status;
  final VoidCallback onDelete;
  const _TaskItem({
    required this.title, 
    required this.dept, 
    required this.priority, 
    required this.pct, 
    this.status,
    required this.onDelete,
  });

  Color _getPriorityColor() {
    switch (priority) {
      case 'High': return Colors.redAccent;
      case 'Medium': return AppColors.warning;
      case 'Low': return AppColors.success;
      default: return AppColors.textSecondary;
    }
  }

  Color _getStatusColor() {
    switch (status) {
      case 'Sent': return AppColors.accent;
      case 'Delivered': return AppColors.warning;
      case 'Achieved': return AppColors.success;
      default: return Colors.white24;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isAchieved = status == "Achieved";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
              if (status != null) ...[
                StatusBadge(label: status!.toUpperCase(), color: _getStatusColor()),
                if (isAchieved) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onDelete,
                    child: const Icon(LucideIcons.trash2, size: 14, color: Colors.white38),
                  ),
                ],
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(dept, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
          const SizedBox(height: 12),
          Row(
            children: [
              StatusBadge(label: priority, color: _getPriorityColor()),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: pct / 100, minHeight: 4,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text('$pct%', style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}
