
// hive_service.dart
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import '../model/task_model.dart';

class HiveService {
  static bool _isAdapterRegistered = false;
  Box<Task>? _taskBox;
  final Logger logger = Logger();

  Future<void> intitializeHive() async {
    try {
      await Hive.initFlutter();
      if (!_isAdapterRegistered) {
        Hive.registerAdapter(TaskAdapter());
        _isAdapterRegistered = true;
      }
      _taskBox = await Hive.openBox<Task>('eventsBox');
      logger.i('Hive initialized and task box opened.');
    } catch (e) {
      logger.e('Error initializing Hive: $e');
      rethrow;
    }
  }

  Future<List<Task>> getTasks() async {
    if (_taskBox == null || !_taskBox!.isOpen) {
      throw Exception('Hive box is not initialized.');
    }
    return _taskBox!.values.toList();
  }

  Future<void> addTask(Task task) async {
    if (_taskBox == null || !_taskBox!.isOpen) {
      throw Exception('Hive box is not initialized.');
    }
    await _taskBox!.add(task);
    logger.i('Task added: ${task.title}');
  }

  Future<void> updateTask(Task task, bool isCompleted) async {
    final taskIndex = _taskBox!.values.toList().indexWhere((element) => element.title == task.title);
    if (taskIndex != -1) {
      final updatedTask = Task(title: task.title, isCompleted: isCompleted);
      await _taskBox!.putAt(taskIndex, updatedTask);
      logger.i('Task updated: ${task.title}, Completed: $isCompleted');
    } else {
      logger.w('Task not found for updating: ${task.title}');
    }
  }

  Future<void> deleteTask(Task task) async {
    final taskIndex = _taskBox!.values.toList().indexWhere((element) => element.title == task.title);
    if (taskIndex != -1) {
      await _taskBox!.deleteAt(taskIndex);
      logger.i('Task deleted: ${task.title}');
    } else {
      logger.w('Task not found for deletion: ${task.title}');
    }
  }

  Future<void> closeHive() async {
    if (_taskBox != null && _taskBox!.isOpen) {
      await _taskBox!.close();
      logger.i("Hive closed.");
    }
  }
}