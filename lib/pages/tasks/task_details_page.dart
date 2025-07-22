import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jisort/model/tasks.dart';
import 'package:jisort/model/user.dart';
import 'package:jisort/provider/task_notifier.dart';
import 'package:jisort/provider/user_notifier.dart';
import 'package:jisort/provider/providers.dart';

class TaskDetailsScreen extends ConsumerWidget {
  final Task task;

  const TaskDetailsScreen({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskNotifier = ref.read(taskProvider.notifier);
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditDialog(context, task, taskNotifier),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await taskNotifier.deleteTask(task.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${task.description ?? "No description"}'),
            const SizedBox(height: 8),
            Text('Status: ${task.status}'),
            Text('Progress: ${task.progress}%'),
            Text('Created by: ${task.createdBy.username}'),
            const SizedBox(height: 16),
            const Text('Assigned to:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ...task.assignedTo.map((user) => Text('- ${user.username}')),
            const SizedBox(height: 16),
            const Text('Activities:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ...task.activities.map((activity) => ListTile(
                  title: Text(activity.description),
                  subtitle: Text(
                      'By ${activity.createdBy.username} at ${activity.createdAt}'),
                )),
            const SizedBox(height: 16),
            if (authState.user != null)
              ElevatedButton(
                onPressed: () =>
                    _showAssignDialog(context, task, taskNotifier, ref),
                child: const Text('Assign Task'),
              ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(
      BuildContext context, Task task, TaskNotifier taskNotifier) {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);
    final progressController =
        TextEditingController(text: task.progress.toString());
    String status = task.status;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            TextField(
              controller: progressController,
              decoration: const InputDecoration(labelText: 'Progress (%)'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: status,
              items: ['To Do', 'In Progress', 'Done']
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  status = value;
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final title = titleController.text;
              final description = descriptionController.text;
              final progress =
                  int.tryParse(progressController.text) ?? task.progress;

              if (title.isNotEmpty) {
                try {
                  await taskNotifier.updateTask(
                    task.id,
                    title: title,
                    description: description.isNotEmpty ? description : null,
                    progress: progress,
                    status: status,
                  );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error updating task: $e')),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAssignDialog(BuildContext context, Task task,
      TaskNotifier taskNotifier, WidgetRef ref) {
    final apiService = ref.read(apiServiceProvider);
    List<int?> selectedUserIds =
        task.assignedTo.map((user) => user.id).toList();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => FutureBuilder<List<User>>(
          future: apiService.getUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AlertDialog(
                content: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError) {
              return AlertDialog(
                content: Text('Error: ${snapshot.error}'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Close'),
                  ),
                ],
              );
            }

            final users = snapshot.data ?? [];
            return AlertDialog(
              title: const Text('Assign Task'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: users.map((user) {
                    return CheckboxListTile(
                      title: Text(user.username ?? ''),
                      value: selectedUserIds.contains(user.id),
                      onChanged: (bool? selected) {
                        setState(() {
                          if (selected == true) {
                            if (!selectedUserIds.contains(user.id)) {
                              if (user.id != null) {
                                selectedUserIds.add(user.id!);
                              }
                            }
                          } else {
                            selectedUserIds.remove(user.id);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      await taskNotifier.assignTask(
                        task.id,
                        selectedUserIds.whereType<int>().toList(),
                      );
                      Navigator.pop(dialogContext);
                    } catch (e) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        SnackBar(content: Text('Error assigning task: $e')),
                      );
                    }
                  },
                  child: const Text('Assign'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
