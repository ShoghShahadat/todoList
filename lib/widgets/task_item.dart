import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

// A dedicated widget to display a single task item.
// This makes the code more modular and easier to maintain.
class TaskItem extends StatelessWidget {
  final Task task;

  const TaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    // Using a reference to the TaskProvider to perform actions.
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        // Checkbox to toggle task completion status.
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (bool? value) {
            taskProvider.toggleTaskStatus(task);
          },
          // The active color of the checkbox will match the app's theme.
          activeColor: Theme.of(context).primaryColor,
        ),
        // Task title with a strikethrough style if completed.
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: task.isCompleted ? Colors.grey : null,
            decorationColor: Theme.of(context).primaryColor.withOpacity(0.7),
            decorationThickness: 2.0,
          ),
        ),
        // Trailing icons for editing and deleting the task.
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.blueGrey),
              onPressed: () =>
                  _showTaskDialog(context, taskProvider, task: task),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () =>
                  _showDeleteConfirmationDialog(context, taskProvider, task),
            ),
          ],
        ),
        // Allow editing on long press as well.
        onLongPress: () => _showTaskDialog(context, taskProvider, task: task),
      ),
    );
  }

  // Shows a dialog to edit an existing one.
  void _showTaskDialog(BuildContext context, TaskProvider taskProvider,
      {Task? task}) {
    final textController = TextEditingController(text: task?.title ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('ویرایش وظیفه'),
          content: TextField(
            controller: textController,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'عنوان وظیفه'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('لغو'),
            ),
            TextButton(
              onPressed: () {
                final title = textController.text;
                if (title.isNotEmpty && task != null) {
                  taskProvider.updateTaskTitle(task, title);
                  Navigator.pop(context);
                }
              },
              child: const Text('ذخیره'),
            ),
          ],
        );
      },
    );
  }

  // Shows a confirmation dialog before deleting a task.
  void _showDeleteConfirmationDialog(
      BuildContext context, TaskProvider taskProvider, Task task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تایید حذف'),
          content: const Text('آیا این وظیفه حذف شود؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('خیر'),
            ),
            TextButton(
              onPressed: () {
                taskProvider.deleteTask(task);
                Navigator.pop(context);
              },
              child: const Text('بله'),
            ),
          ],
        );
      },
    );
  }
}
