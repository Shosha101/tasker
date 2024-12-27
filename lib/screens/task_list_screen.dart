// task_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/task_provider.dart';
import '../widget/search_textfield_widget.dart';
import '../widget/todo_item.dart';

// ... other imports

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late TextEditingController _searchController = TextEditingController();
  final TextEditingController _addTaskController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _addTaskController.dispose();
    super.dispose();
  }

  int getCrossAxisCount(double screenWidth) {
    if (screenWidth > 1200) {
      return 3;
    } else if (screenWidth > 800) {
      return 2;
    } else {
      return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    double _deviceHeight = MediaQuery.of(context).size.height;
    double _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text("Tasker")),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchTextFieldWidget(
              onSearchChanged: (String value) {
                setState(() {
                  _searchController.text = value;
                });
              },
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: Text(
                'All ToDos',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
              ),
            ),
            Expanded(
              child: Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  final filteredTasks = taskProvider.tasks
                      .where((element) => element.title
                          .toLowerCase()
                          .contains(_searchController.text))
                      .toList();
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 80,
                      crossAxisCount: getCrossAxisCount(_deviceWidth),
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return TodoItem(
                        task: task,
                        onUpdate: (completed) =>
                            Provider.of<TaskProvider>(context, listen: false)
                                .updateTask(task, completed!),
                        onDelete: () =>
                            Provider.of<TaskProvider>(context, listen: false)
                                .deleteTask(task),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 10.0,
                            spreadRadius: 0.0,
                          )
                        ],
                      ),
                      child: TextField(
                        controller: _addTaskController,
                        decoration: const InputDecoration(
                          hintText: 'Add a new Todo item',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      onPressed: () {
                        if (_addTaskController.text.isNotEmpty) {
                          Provider.of<TaskProvider>(context, listen: false)
                              .addTask(_addTaskController.text);
                          _addTaskController.clear();
                        }
                      },
                      color: Colors.white,
                      icon: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
