// task_list_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/task_model.dart';
import '../provider/task_provider.dart';
import '../themes/app_theme.dart';
import '../widget/language_pill.dart';
import '../widget/search_textfield_widget.dart';
import '../widget/todo_item.dart';

/// Which tasks the list shows.
enum TaskFilter { all, active, done }

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late TextEditingController _searchController = TextEditingController();
  final TextEditingController _addTaskController = TextEditingController();
  TaskFilter _filter = TaskFilter.all;

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

  void _addTask() {
    if (_addTaskController.text.isNotEmpty) {
      Provider.of<TaskProvider>(
        context,
        listen: false,
      ).addTask(_addTaskController.text);
      _addTaskController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    double _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Consumer<TaskProvider>(
          builder: (context, taskProvider, child) {
            final matching = taskProvider.tasks
                .where(
                  (element) => element.title.toLowerCase().contains(
                    _searchController.text,
                  ),
                )
                .toList();
            final active = matching.where((task) => !task.isCompleted).toList();
            final done = matching.where((task) => task.isCompleted).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Text(
                            context.tr('app_name'),
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text,
                            ),
                          ),
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsetsDirectional.only(
                              start: 4,
                              top: 14,
                            ),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const Spacer(),
                          const LanguagePill(),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SearchTextFieldWidget(
                        onSearchChanged: (String value) {
                          setState(() {
                            _searchController.text = value;
                          });
                        },
                      ),
                      const SizedBox(height: 14),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _FilterChip(
                              label: context.tr('filter_all'),
                              count: matching.length,
                              selected: _filter == TaskFilter.all,
                              onTap: () =>
                                  setState(() => _filter = TaskFilter.all),
                            ),
                            const SizedBox(width: 8),
                            _FilterChip(
                              label: context.tr('filter_active'),
                              count: active.length,
                              selected: _filter == TaskFilter.active,
                              onTap: () =>
                                  setState(() => _filter = TaskFilter.active),
                            ),
                            const SizedBox(width: 8),
                            _FilterChip(
                              label: context.tr('filter_done'),
                              count: done.length,
                              selected: _filter == TaskFilter.done,
                              onTap: () =>
                                  setState(() => _filter = TaskFilter.done),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: _buildList(
                    context,
                    taskProvider,
                    _deviceWidth,
                    active: _filter == TaskFilter.done ? const [] : active,
                    done: _filter == TaskFilter.active ? const [] : done,
                  ),
                ),
                _buildAddBar(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    TaskProvider taskProvider,
    double deviceWidth, {
    required List<Task> active,
    required List<Task> done,
  }) {
    if (active.isEmpty && done.isEmpty) {
      final nothingSaved = taskProvider.tasks.isEmpty;
      return _EmptyState(
        title: context.tr(nothingSaved ? 'empty_title' : 'no_results'),
        body: nothingSaved ? context.tr('empty_body') : null,
      );
    }

    final gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      mainAxisExtent: 60,
      crossAxisCount: getCrossAxisCount(deviceWidth),
      crossAxisSpacing: 10.0,
      mainAxisSpacing: 10.0,
    );

    SliverGrid grid(List<Task> tasks) {
      return SliverGrid(
        gridDelegate: gridDelegate,
        delegate: SliverChildBuilderDelegate((context, index) {
          final task = tasks[index];
          return TodoItem(
            task: task,
            onUpdate: (completed) => taskProvider.updateTask(task, completed!),
            onDelete: () {
              taskProvider.deleteTask(task);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text(context.tr('task_deleted'))),
                );
            },
          );
        }, childCount: tasks.length),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: grid(active),
        ),
        // The completed tasks sit under their own heading when both groups show.
        if (done.isNotEmpty && active.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 10),
              child: Text(
                context.tr('completed_section'),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.muted,
                ),
              ),
            ),
          ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          sliver: grid(done),
        ),
      ],
    );
  }

  Widget _buildAddBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Container(
        padding: const EdgeInsetsDirectional.fromSTEB(18, 4, 4, 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.text.withValues(alpha: 0.06),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _addTaskController,
                onSubmitted: (_) => _addTask(),
                decoration: InputDecoration(
                  hintText: context.tr('add_hint'),
                  hintStyle: const TextStyle(color: AppColors.hint),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: AppColors.primary,
              shape: const CircleBorder(),
              child: IconButton(
                onPressed: _addTask,
                tooltip: context.tr('add'),
                color: Colors.white,
                icon: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : AppColors.surface,
      shape: StadiumBorder(
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.border,
        ),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 7, 8, 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppColors.text,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                constraints: const BoxConstraints(minWidth: 24),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white.withValues(alpha: 0.2)
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$count',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : AppColors.muted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String title;
  final String? body;
  const _EmptyState({required this.title, this.body});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 132,
              height: 132,
              decoration: const BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.checklist_rounded,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
            if (body != null) ...[
              const SizedBox(height: 6),
              Text(
                body!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: AppColors.muted),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
