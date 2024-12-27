// task_model.dart
import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final bool isCompleted;

  Task({required this.title, required this.isCompleted});
}
