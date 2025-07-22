import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jisort/model/tasks.dart';
import 'package:jisort/services/api_service.dart';

class TaskState {
  final List<Task> tasks;
  final bool isLoading;
  final String? error;

  TaskState({
    this.tasks = const [],
    this.isLoading = false,
    this.error,
  });

  TaskState copyWith({
    List<Task>? tasks,
    bool? isLoading,
    String? error,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class TaskNotifier extends StateNotifier<TaskState> {
  final ApiService _apiService;

  TaskNotifier(this._apiService) : super(TaskState());

  Future<void> fetchTasks() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final tasks = await _apiService.getTasks();
      state = state.copyWith(tasks: tasks, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> createTask({
    required String title,
    String? description,
    int progress = 0,
    required String status,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final task = await _apiService.createTask(
        title: title,
        description: description,
        progress: progress,
        status: status,
      );
      state = state.copyWith(
        tasks: [...state.tasks, task],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateTask(
    int taskId, {
    String? title,
    String? description,
    int? progress,
    String? status,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final updatedTask = await _apiService.updateTask(
        taskId,
        title: title,
        description: description,
        progress: progress,
        status: status,
      );
      state = state.copyWith(
        tasks: state.tasks.map((task) => task.id == taskId ? updatedTask : task).toList(),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteTask(int taskId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _apiService.deleteTask(taskId);
      state = state.copyWith(
        tasks: state.tasks.where((task) => task.id != taskId).toList(),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> assignTask(int taskId, List<int> userIds) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final updatedTask = await _apiService.assignTask(taskId, userIds);
      state = state.copyWith(
        tasks: state.tasks.map((task) => task.id == taskId ? updatedTask : task).toList(),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}