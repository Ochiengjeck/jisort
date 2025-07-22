import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jisort/model/user.dart';

import '../../provider/providers.dart';

class AssignUsersPage extends ConsumerStatefulWidget {
  final int taskId;

  const AssignUsersPage({super.key, required this.taskId});

  @override
  _AssignUsersPageState createState() => _AssignUsersPageState();
}

class _AssignUsersPageState extends ConsumerState<AssignUsersPage> {
  List<User> _users = [];
  List<int> _selectedUserIds = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final users = await ref.read(apiServiceProvider).getUsers();
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  void _assignUsers() async {
    await ref
        .read(taskProvider.notifier)
        .assignTask(widget.taskId, _selectedUserIds);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Assign Users')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : _users.isEmpty
                  ? const Center(child: Text('No users available'))
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: _users.length,
                            itemBuilder: (context, index) {
                              final user = _users[index];
                              return CheckboxListTile(
                                title: Text(user.fullName ??
                                    user.username ??
                                    'Unknown'),
                                subtitle: Text(user.email ?? ''),
                                value: _selectedUserIds.contains(user.id),
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      _selectedUserIds.add(user.id!);
                                    } else {
                                      _selectedUserIds.remove(user.id);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: taskState.isLoading
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: _selectedUserIds.isNotEmpty
                                      ? _assignUsers
                                      : null,
                                  child: const Text('Assign Selected Users'),
                                ),
                        ),
                        if (taskState.error != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              taskState.error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    ),
    );
  }
}
