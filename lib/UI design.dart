import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

// Data Models
class Activity {
  String id;
  String title;
  bool isCompleted;
  DateTime? completedAt;

  Activity({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.completedAt,
  });
}

class Task {
  String id;
  String title;
  String description;
  List<Activity> activities;
  String? assignedTo;
  bool isAssigned;
  DateTime createdAt;
  DateTime? dueDate;
  TaskPriority priority;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    required this.activities,
    this.assignedTo,
    this.isAssigned = false,
    required this.createdAt,
    this.dueDate,
    this.priority = TaskPriority.medium,
  });

  double get progressPercentage {
    if (activities.isEmpty) return 0.0;
    int completedCount =
        activities.where((activity) => activity.isCompleted).length;
    return completedCount / activities.length;
  }

  bool get isCompleted => progressPercentage == 1.0;
}

enum TaskPriority { low, medium, high, urgent }

class Assistant {
  String id;
  String name;
  String email;
  bool isActive;

  Assistant({
    required this.id,
    required this.name,
    required this.email,
    this.isActive = true,
  });
}

// Task List Screen
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<Task> tasks = [];
  List<Assistant> assistants = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeData();
  }

  void _initializeData() {
    assistants = [
      Assistant(
          id: const Uuid().v4(),
          name: 'Emma Wilson',
          email: 'emma@cleaningservice.com'),
      Assistant(
          id: const Uuid().v4(),
          name: 'James Okoth',
          email: 'james@cleaningservice.com'),
      Assistant(
          id: const Uuid().v4(),
          name: 'Aisha Mwangi',
          email: 'aisha@cleaningservice.com'),
    ];

    tasks = [
      Task(
        id: const Uuid().v4(),
        title: 'Office Deep Cleaning',
        description: 'Thorough cleaning of corporate office spaces',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        dueDate: DateTime.now().add(const Duration(days: 7)),
        priority: TaskPriority.high,
        activities: [
          Activity(id: const Uuid().v4(), title: 'Vacuum carpets'),
          Activity(
              id: const Uuid().v4(),
              title: 'Sanitize workstations',
              isCompleted: true),
          Activity(id: const Uuid().v4(), title: 'Clean windows'),
          Activity(id: const Uuid().v4(), title: 'Disinfect restrooms'),
        ],
      ),
      Task(
        id: const Uuid().v4(),
        title: 'Residential Cleaning Contract',
        description: 'Weekly cleaning for client residence',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        dueDate: DateTime.now().add(const Duration(days: 14)),
        priority: TaskPriority.medium,
        assignedTo: 'Emma Wilson',
        isAssigned: true,
        activities: [
          Activity(
              id: const Uuid().v4(),
              title: 'Dust furniture',
              isCompleted: true),
          Activity(
              id: const Uuid().v4(), title: 'Mop floors', isCompleted: true),
          Activity(id: const Uuid().v4(), title: 'Clean kitchen appliances'),
          Activity(id: const Uuid().v4(), title: 'Organize storage areas'),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          ),
        ),
        child: Column(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Jisort',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.person_add, color: Colors.white),
                          onPressed: _showAssistantDialog,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Manage your cleaning tasks and team',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.white,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white.withOpacity(0.6),
                      tabs: const [
                        Tab(text: 'All Tasks'),
                        Tab(text: 'My Tasks'),
                        Tab(text: 'Assigned'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTaskList(tasks),
                    _buildTaskList(
                        tasks.where((task) => !task.isAssigned).toList()),
                    _buildTaskList(
                        tasks.where((task) => task.isAssigned).toList()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: const Color(0xFF667EEA),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTaskList(List<Task> taskList) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: taskList.isEmpty
          ? const Center(
              child: Text(
                'No cleaning tasks yet. Tap + to create one!',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: taskList.length,
              itemBuilder: (context, index) {
                final task = taskList[index];
                return _buildTaskCard(task);
              },
            ),
    );
  }

  Widget _buildTaskCard(Task task) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => _showTaskDetails(task),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  _buildPriorityIndicator(task.priority),
                ],
              ),
              if (task.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  task.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: task.progressPercentage,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        task.progressPercentage == 1.0
                            ? Colors.green
                            : const Color(0xFF667EEA),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${(task.progressPercentage * 100).toInt()}%',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${task.activities.where((a) => a.isCompleted).length}/${task.activities.length} activities',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (task.isAssigned)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF667EEA).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Assigned to ${task.assignedTo}',
                        style: const TextStyle(
                          color: Color(0xFF667EEA),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityIndicator(TaskPriority priority) {
    Color color;
    String text;

    switch (priority) {
      case TaskPriority.urgent:
        color = Colors.red;
        text = 'Urgent';
        break;
      case TaskPriority.high:
        color = Colors.orange;
        text = 'High';
        break;
      case TaskPriority.medium:
        color = Colors.blue;
        text = 'Medium';
        break;
      case TaskPriority.low:
        color = Colors.green;
        text = 'Low';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showTaskDetails(Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TaskDetailsSheet(
        task: task,
        assistants: assistants,
        onTaskUpdated: (updatedTask) {
          setState(() {
            final index = tasks.indexWhere((t) => t.id == updatedTask.id);
            if (index != -1) {
              tasks[index] = updatedTask;
            }
          });
        },
      ),
    );
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        assistants: assistants,
        onTaskAdded: (newTask) {
          setState(() {
            tasks.add(newTask);
          });
        },
      ),
    );
  }

  void _showAssistantDialog() {
    showDialog(
      context: context,
      builder: (context) => AddAssistantDialog(
        onAssistantAdded: (newAssistant) {
          setState(() {
            assistants.add(newAssistant);
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

// Task Details Sheet
class TaskDetailsSheet extends StatefulWidget {
  final Task task;
  final List<Assistant> assistants;
  final Function(Task) onTaskUpdated;

  const TaskDetailsSheet({
    Key? key,
    required this.task,
    required this.assistants,
    required this.onTaskUpdated,
  }) : super(key: key);

  @override
  State<TaskDetailsSheet> createState() => _TaskDetailsSheetState();
}

class _TaskDetailsSheetState extends State<TaskDetailsSheet> {
  late Task task;

  @override
  void initState() {
    super.initState();
    task = widget.task;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          task.title,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: _editTask,
                      ),
                    ],
                  ),
                  if (task.description.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      task.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                  const SizedBox(height: 20),
                  Text(
                    'Progress',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: task.progressPercentage,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      task.progressPercentage == 1.0
                          ? Colors.green
                          : const Color(0xFF667EEA),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${(task.progressPercentage * 100).toInt()}% Complete',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cleaning Activities',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      ElevatedButton.icon(
                        onPressed: _addActivity,
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Add'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: task.activities.length,
                      itemBuilder: (context, index) {
                        final activity = task.activities[index];
                        return CheckboxListTile(
                          title: Text(activity.title),
                          value: activity.isCompleted,
                          onChanged: (value) {
                            setState(() {
                              activity.isCompleted = value ?? false;
                              if (activity.isCompleted) {
                                activity.completedAt = DateTime.now();
                              } else {
                                activity.completedAt = null;
                              }
                            });
                            widget.onTaskUpdated(task);
                          },
                          activeColor: const Color(0xFF667EEA),
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _showAssignmentDialog,
                          icon: Icon(task.isAssigned
                              ? Icons.person
                              : Icons.person_add),
                          label: Text(task.isAssigned
                              ? 'Assigned to ${task.assignedTo}'
                              : 'Assign Cleaning Task'),
                        ),
                      ),
                      if (task.isAssigned) ...[
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              task.isAssigned = false;
                              task.assignedTo = null;
                            });
                            widget.onTaskUpdated(task);
                          },
                          icon: const Icon(Icons.person_remove),
                          tooltip: 'Unassign',
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addActivity() {
    showDialog(
      context: context,
      builder: (context) {
        String activityTitle = '';
        return AlertDialog(
          title: const Text('Add Cleaning Activity'),
          content: TextField(
            onChanged: (value) => activityTitle = value,
            decoration: const InputDecoration(
              hintText: 'Enter cleaning activity title',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (activityTitle.isNotEmpty) {
                  setState(() {
                    task.activities.add(Activity(
                      id: const Uuid().v4(),
                      title: activityTitle,
                    ));
                  });
                  widget.onTaskUpdated(task);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _editTask() {
    showDialog(
      context: context,
      builder: (context) {
        final titleController = TextEditingController(text: task.title);
        final descriptionController =
            TextEditingController(text: task.description);
        TaskPriority priority = task.priority;

        return AlertDialog(
          title: const Text('Edit Cleaning Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Cleaning Task Title',
                    hintText: 'Enter cleaning task title',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter cleaning task description',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<TaskPriority>(
                  value: priority,
                  decoration: const InputDecoration(labelText: 'Priority'),
                  items: TaskPriority.values.map((p) {
                    return DropdownMenuItem(
                      value: p,
                      child: Text(p.name.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      priority = value;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  setState(() {
                    task.title = titleController.text;
                    task.description = descriptionController.text;
                    task.priority = priority;
                  });
                  widget.onTaskUpdated(task);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showAssignmentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Assign Cleaning Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.assistants.map((assistant) {
            return ListTile(
              title: Text(assistant.name),
              subtitle: Text(assistant.email),
              onTap: () {
                setState(() {
                  task.assignedTo = assistant.name;
                  task.isAssigned = true;
                });
                widget.onTaskUpdated(task);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

// Add Task Dialog
class AddTaskDialog extends StatefulWidget {
  final List<Assistant> assistants;
  final Function(Task) onTaskAdded;

  const AddTaskDialog({
    Key? key,
    required this.assistants,
    required this.onTaskAdded,
  }) : super(key: key);

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TaskPriority _priority = TaskPriority.medium;
  DateTime? _dueDate;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Cleaning Task'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Cleaning Task Title',
                hintText: 'Enter cleaning task title',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter cleaning task description',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<TaskPriority>(
              value: _priority,
              decoration: const InputDecoration(labelText: 'Priority'),
              items: TaskPriority.values.map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(priority.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _priority = value ?? TaskPriority.medium;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (selectedDate != null) {
                  setState(() {
                    _dueDate = selectedDate;
                  });
                }
              },
              child: Text(_dueDate == null
                  ? 'Select Due Date'
                  : 'Due: ${_dueDate!.toString().substring(0, 10)}'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _createTask,
          child: const Text('Create'),
        ),
      ],
    );
  }

  void _createTask() {
    if (_titleController.text.isNotEmpty) {
      final newTask = Task(
        id: const Uuid().v4(),
        title: _titleController.text,
        description: _descriptionController.text,
        activities: [],
        createdAt: DateTime.now(),
        dueDate: _dueDate,
        priority: _priority,
      );
      widget.onTaskAdded(newTask);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

// Add Assistant Dialog
class AddAssistantDialog extends StatefulWidget {
  final Function(Assistant) onAssistantAdded;

  const AddAssistantDialog({Key? key, required this.onAssistantAdded})
      : super(key: key);

  @override
  State<AddAssistantDialog> createState() => _AddAssistantDialogState();
}

class _AddAssistantDialogState extends State<AddAssistantDialog> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Cleaning Staff'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Staff Name',
              hintText: 'Enter cleaning staff name',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'Enter cleaning staff email',
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _addAssistant,
          child: const Text('Add'),
        ),
      ],
    );
  }

  void _addAssistant() {
    if (_nameController.text.isNotEmpty && _emailController.text.isNotEmpty) {
      final newAssistant = Assistant(
        id: const Uuid().v4(),
        name: _nameController.text,
        email: _emailController.text,
      );
      widget.onAssistantAdded(newAssistant);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
