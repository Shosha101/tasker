import 'package:flutter/material.dart';
import '../model/task_model.dart';

class TodoItem extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?> onUpdate;
  final VoidCallback onDelete;

  const TodoItem({
    Key? key,
    required this.task,
    required this.onUpdate,
    required this.onDelete,
  }) : super(key: key);

  // Method to show the full text in a dialog
  void _showFullTextDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Full Task Description"),
          content: Text(task.title), // Display the full title text
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFullTextDialog(context), // Open pop-up on card tap
      child: Card(
        color: Colors.white,
        elevation: 0.3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Checkbox(
                value: task.isCompleted,
                onChanged: onUpdate,
                activeColor: Colors.teal,
              ),
              const SizedBox(width: 30),
              Expanded(
                child: Text(
                  task.title,
                  maxLines: 1, // Limit to 1 line
                  overflow: TextOverflow.ellipsis, // Truncate with ellipsis
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                    color: const Color.fromRGBO(28, 28, 28, 1.0),
                  ),
                ),
              ),
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: IconButton(
                  iconSize: 18,
                  onPressed: onDelete,
                  icon: const Icon(color: Colors.white, Icons.delete),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
