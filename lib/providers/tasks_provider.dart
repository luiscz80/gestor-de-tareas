import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tareas/utils/notification_service.dart';
import '../models/task.dart';
import '../utils/database_helper.dart';

class TasksProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  Timer? _timer;

  TasksProvider() {
    _initProvider();
  }

  Future<void> _initProvider() async {
    await NotificationService.init();
    await _requestNotificationPermission();
    await _fetchTasks();
    _startPeriodicCheck();
  }

  Future<void> _requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> _fetchTasks() async {
    _tasks = await _dbHelper.getTasks();
    _checkPendingTasks();
    notifyListeners();
  }

  void _startPeriodicCheck() {
    _timer = Timer.periodic(Duration(minutes: 30), (timer) async {
      await _checkPendingTasks();
    });
  }

  Future<void> _checkPendingTasks() async {
    DateTime now = DateTime.now();

    for (var task in _tasks) {
      if (task.status != 'Completado') {
        DateTime taskDate = task.date;

        if (task.status == 'Pendiente') {
          await NotificationService.showNotification(
            'Tarea Pendiente',
            'La tarea "${task.title}" está pendiente.',
          );
        } else if (taskDate.isAfter(now) &&
            taskDate.difference(now).inHours <= 24) {
          await NotificationService.showNotification(
            'Tarea por Expirar',
            'La tarea "${task.title}" vence el ${taskDate.toLocal()}.',
          );
        } else if (taskDate.isBefore(now)) {
          await NotificationService.showNotification(
            'Tarea Vencida',
            'La tarea "${task.title}" ha vencido.',
          );
        }
      }
    }

    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _dbHelper.insertTask(task);
    await _fetchTasks();
  }

  Future<void> updateTask(Task task) async {
    await _dbHelper.updateTask(task);
    await _fetchTasks();
  }

  Future<void> deleteTask(int id) async {
    await _dbHelper.deleteTask(id);
    await _fetchTasks();
  }

  Future<void> deleteAllTasks() async {
    await _dbHelper.deleteAllTasks();
    await _fetchTasks();
  }

  Future<void> loadPendingTasks() async {
    _tasks = await _dbHelper.getPendingTasks();
    notifyListeners();
  }

  Future<void> markTaskAsCompleted(int taskId) async {
    await _dbHelper.updateTaskStatus(taskId, 'Completado');
    await _fetchTasks();
  }

  Future<void> searchTasks(String query) async {
    _tasks = await _dbHelper.searchExpenses(query);
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
