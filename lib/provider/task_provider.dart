// task_provider.dart
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../model/task_model.dart';
import '../services/hive_service.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  final HiveService _hiveService = HiveService();
  final Logger logger = Logger();

  List<Task> get tasks => _tasks;

  Future<void> initialize() async {
    try {
      await _hiveService.intitializeHive();
      _tasks = await _hiveService.getTasks(); // Load tasks from Hive
      notifyListeners();
    } catch (e) {
      logger.e("Error initializing or fetching tasks: $e");
    }
  }

  Future<void> addTask(String title) async {
    try {
      final newTask = Task(title: title, isCompleted: false);
      await _hiveService.addTask(newTask);
      _tasks.add(newTask);
      notifyListeners();
    } catch (e) {
      logger.e('Error adding task: $e');
    }
  }

  Future<void> updateTask(Task task, bool isCompleted) async {
    try {
      final index = _tasks.indexWhere((t) => t.title == task.title);
      if (index != -1) {
        final updatedTask = Task(title: task.title, isCompleted: isCompleted);
        await _hiveService.updateTask(task, isCompleted);
        _tasks[index] = updatedTask;
        notifyListeners();
      } else {
        logger.w('Task not found for updating: ${task.title}');
      }
    } catch (e) {
      logger.e('Error updating task: $e');
    }
  }

  Future<void> deleteTask(Task task) async {
    try {
      final index = _tasks.indexWhere((t) => t.title == task.title);
      if (index != -1) {
        await _hiveService.deleteTask(task);
        _tasks.removeAt(index);
        notifyListeners();
      } else {
        logger.w('Task not found for deletion: ${task.title}');
      }
    } catch (e) {
      logger.e('Error deleting task: $e');
    }
  }
}
