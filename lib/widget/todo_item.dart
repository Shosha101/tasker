import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import '../model/task_model.dart';
import '../themes/app_theme.dart';

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

  // Shows the full task text in a bottom sheet, with its actions.
  void _showDetailsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        sheetContext.tr('task_details'),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.muted,
                        ),
                      ),
                    ),
                    _StatusChip(done: task.isCompleted),
                  ],
                ),
                const SizedBox(height: 10),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(sheetContext).size.height * 0.4,
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      task.title, // Display the full title text
                      style: const TextStyle(
                        fontSize: 20,
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    onUpdate(!task.isCompleted);
                  },
                  icon: Icon(
                    task.isCompleted ? Icons.replay : Icons.check_circle_outline,
                    size: 20,
                  ),
                  label: Text(
                    sheetContext.tr(
                      task.isCompleted ? 'mark_active' : 'mark_done',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(sheetContext).pop();
                          onDelete();
                        },
                        icon: const Icon(Icons.delete_outline, size: 20),
                        label: Text(sheetContext.tr('delete')),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.danger,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(sheetContext).pop(),
                        child: Text(sheetContext.tr('close')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final done = task.isCompleted;

    // Swipe a task to either side to delete it.
    return Dismissible(
      key: ObjectKey(task),
      onDismissed: (_) => onDelete(),
      background: const _DeleteBackground(
        alignment: AlignmentDirectional.centerStart,
      ),
      secondaryBackground: const _DeleteBackground(
        alignment: AlignmentDirectional.centerEnd,
      ),
      child: Material(
        color: done ? AppColors.background : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _showDetailsSheet(context), // Open the sheet on card tap
          child: Container(
            // Fills the height the list gives each task.
            constraints: const BoxConstraints(minHeight: 60),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => onUpdate(!done),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: done ? AppColors.primary : AppColors.surface,
                        border: Border.all(
                          color: done ? AppColors.primary : AppColors.hint,
                          width: 2,
                        ),
                      ),
                      child: done
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    task.title,
                    maxLines: 1, // Limit to 1 line
                    overflow: TextOverflow.ellipsis, // Truncate with ellipsis
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      decoration: done ? TextDecoration.lineThrough : null,
                      decorationColor: AppColors.hint,
                      color: done ? AppColors.hint : AppColors.text,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? Icons.chevron_left
                      : Icons.chevron_right,
                  color: AppColors.hint,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DeleteBackground extends StatelessWidget {
  final AlignmentGeometry alignment;
  const _DeleteBackground({required this.alignment});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
        color: AppColors.dangerSoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(Icons.delete_outline, color: AppColors.danger),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final bool done;
  const _StatusChip({required this.done});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: done ? AppColors.primarySoft : AppColors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        context.tr(done ? 'status_done' : 'status_active'),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: done ? AppColors.primary : AppColors.muted,
        ),
      ),
    );
  }
}
