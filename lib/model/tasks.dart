import 'package:jisort/model/user.dart';

class Task {
  final int id;
  final String title;
  final String? description;
  final bool isAssigned;
  final int progress;
  final String status;
  final User createdBy;
  final List<User> assignedTo;
  final List<Activity> activities;
  final String createdAt;
  final String updatedAt;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.isAssigned,
    required this.progress,
    required this.status,
    required this.createdBy,
    required this.assignedTo,
    required this.activities,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      isAssigned: json['is_assigned'] as bool,
      progress: json['progress'] as int,
      status: json['status'] as String,
      createdBy: User.fromJson(json['created_by'] as Map<String, dynamic>),
      assignedTo: (json['assigned_to'] as List<dynamic>)
          .map((user) => User.fromJson(user as Map<String, dynamic>))
          .toList(),
      activities: (json['activities'] as List<dynamic>)
          .map((activity) => Activity.fromJson(activity as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'is_assigned': isAssigned,
      'progress': progress,
      'status': status,
      'created_by': createdBy.toJson(),
      'assigned_to': assignedTo.map((user) => user.toJson()).toList(),
      'activities': activities.map((activity) => activity.toJson()).toList(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Activity {
  final int id;
  final int taskId;
  final String description;
  final User createdBy;
  final String createdAt;
  final String updatedAt;

  Activity({
    required this.id,
    required this.taskId,
    required this.description,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as int,
      taskId: json['task_id'] as int,
      description: json['description'] as String,
      createdBy: User.fromJson(json['created_by'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task_id': taskId,
      'description': description,
      'created_by': createdBy.toJson(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}