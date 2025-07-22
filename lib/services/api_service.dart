import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jisort/model/user.dart';
import 'package:jisort/model/tasks.dart';

class ApiService {
  final String baseUrl = dotenv.env['BASE_URL'] ?? 'http://127.0.0.1:8000';
  String? _token;

  void setToken(String token) {
    _token = token;
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  Future<User> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'login': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['token']; // Assuming the login response includes a token
      return User.fromJson(data['user']);
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<User> signUp({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'email': email,
        'phone': phone,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      _token = data['token']; // Assuming the signup response includes a token
      return User.fromJson(data['user']);
    } else {
      throw Exception('Failed to sign up: ${response.body}');
    }
  }

  Future<List<User>> getUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/users'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to fetch users: ${response.body}');
    }
  }

  Future<List<Task>> getTasks() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/tasks'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((task) => Task.fromJson(task)).toList();
    } else {
      throw Exception('Failed to fetch tasks: ${response.body}');
    }
  }

  Future<Task> createTask({
    required String title,
    String? description,
    int progress = 0,
    required String status,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/tasks/create'),
      headers: _headers,
      body: jsonEncode({
        'title': title,
        'description': description,
        'progress': progress,
        'status': status,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Task.fromJson(data);
    } else {
      throw Exception('Failed to create task: ${response.body}');
    }
  }

  Future<Task> updateTask(
    int taskId, {
    String? title,
    String? description,
    int? progress,
    String? status,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/tasks/$taskId'),
      headers: _headers,
      body: jsonEncode({
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (progress != null) 'progress': progress,
        if (status != null) 'status': status,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Task.fromJson(data);
    } else {
      throw Exception('Failed to update task: ${response.body}');
    }
  }

  Future<void> deleteTask(int taskId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/tasks/$taskId'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete task: ${response.body}');
    }
  }

  Future<Task> assignTask(int taskId, List<int> userIds) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/tasks/$taskId/assign'),
      headers: _headers,
      body: jsonEncode({
        'user_ids': userIds,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Task.fromJson(data);
    } else {
      throw Exception('Failed to assign task: ${response.body}');
    }
  }
}
