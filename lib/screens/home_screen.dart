import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
// We will create the widget for the task item and dialogs in the next steps.

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      final query = _searchController.text;
      setState(() {
        _isSearching = query.isNotEmpty;
      });
      taskProvider.searchTasks(query);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Using a Consumer to listen to changes in TaskProvider
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final tasks = _isSearching ? taskProvider.searchResults : taskProvider.tasks;

        return Scaffold(
          // Using a CustomScrollView for a more flexible and custom UI
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(context, taskProvider),
              // A little space between app bar and the list
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
              
              // Show a message if the list is empty
              if (tasks.isEmpty)
                _buildEmptyState(),
              
              // Show the list of tasks
              if (tasks.isNotEmpty)
                _buildTasksList(tasks, taskProvider),
            ],
          ),
          // Floating Action Button to add new tasks
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showTaskDialog(context),
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context, TaskProvider taskProvider) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      snap: false,
      expandedHeight: 120.0,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      iconTheme: const IconThemeData(color: Colors.white),
      title: const Text('لیست وظایف'),
      actions: [
        // Button to delete all tasks
        IconButton(
          icon: const Icon(Icons.delete_sweep_outlined),
          onPressed: () => _showDeleteAllConfirmationDialog(context, taskProvider),
        ),
      ],
      // The flexible space part contains the search bar
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.only(top: 90.0, left: 16.0, right: 16.0, bottom: 8.0),
          child: _buildSearchField(),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'جستجو در وظایف...',
        prefixIcon: const Icon(Icons.search, size: 20),
        filled: true,
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'هیچ وظیفه‌ای برای نمایش وجود ندارد!',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            Text(
              'یک وظیفه جدید اضافه کنید',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksList(List<Task> tasks, TaskProvider taskProvider) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final task = tasks[index];
          // This is a temporary representation of a task item.
          // We will create a dedicated `TaskItem` widget in the next step.
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              // Checkbox to toggle task completion
              leading: Checkbox(
                value: task.isCompleted,
                onChanged: (bool? value) {
                  taskProvider.toggleTaskStatus(task);
                },
              ),
              // Task title with a strikethrough if completed
              title: Text(
                task.title,
                style: TextStyle(
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  color: task.isCompleted ? Colors.grey : null,
                ),
              ),
              // Trailing icons for editing and deleting
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.blueGrey),
                    onPressed: () => _showTaskDialog(context, task: task),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () => _showDeleteConfirmationDialog(context, taskProvider, task: task),
                  ),
                ],
              ),
              onLongPress: () => _showTaskDialog(context, task: task),
            ),
          );
        },
        childCount: tasks.length,
      ),
    );
  }

  // Shows a dialog to add a new task or edit an existing one.
  void _showTaskDialog(BuildContext context, {Task? task}) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final textController = TextEditingController(text: task?.title ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(task == null ? 'افزودن وظیفه جدید' : 'ویرایش وظیفه'),
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
                if (title.isNotEmpty) {
                  if (task == null) {
                    taskProvider.addTask(title);
                  } else {
                    taskProvider.updateTaskTitle(task, title);
                  }
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
  void _showDeleteConfirmationDialog(BuildContext context, TaskProvider taskProvider, {Task? task}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تایید حذف'),
          content: Text(task == null ? 'آیا از حذف تمام وظایف مطمئن هستید؟' : 'آیا این وظیفه حذف شود؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('خیر'),
            ),
            TextButton(
              onPressed: () {
                if (task == null) {
                  taskProvider.deleteAllTasks();
                } else {
                  taskProvider.deleteTask(task);
                }
                Navigator.pop(context);
              },
              child: const Text('بله'),
            ),
          ],
        );
      },
    );
  }
  
  // A wrapper for the delete confirmation dialog for the "delete all" button.
  void _showDeleteAllConfirmationDialog(BuildContext context, TaskProvider taskProvider) {
      _showDeleteConfirmationDialog(context, taskProvider);
  }
}
