import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoly_flutter/widgets/home_app_bar.dart';
import 'package:todoly_flutter/widgets/task_item.dart';
import 'package:todoly_flutter/widgets/theme_panel.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

// The home screen, now refactored to be a clean and modular widget.
// It acts as a conductor, orchestrating the other widgets.
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
    // Listener for the search controller to update the UI state.
    _searchController.addListener(() {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      final query = _searchController.text;
      if (query.isNotEmpty && !_isSearching) {
        setState(() => _isSearching = true);
      } else if (query.isEmpty && _isSearching) {
        setState(() => _isSearching = false);
      }
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
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final tasks =
            _isSearching ? taskProvider.searchResults : taskProvider.tasks;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // The new, modular AppBar.
              HomeAppBar(
                searchController: _searchController,
                onThemePressed: () => _showThemePanel(context),
                onDeleteAllPressed: () =>
                    _showDeleteAllConfirmationDialog(context, taskProvider),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),

              // Conditional UI for empty or no-result states.
              if (tasks.isEmpty && !_isSearching) _buildEmptyState(),
              if (tasks.isEmpty && _isSearching) _buildNoResultsState(),

              // The new, modular task list.
              if (tasks.isNotEmpty) _buildTasksList(tasks),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddTaskDialog(context, taskProvider),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  // Builds the list of tasks using the new TaskItem widget.
  Widget _buildTasksList(List<Task> tasks) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final task = tasks[index];
          // Using the dedicated TaskItem widget for each task.
          return TaskItem(task: task);
        },
        childCount: tasks.length,
      ),
    );
  }

  // Shows the panel for theme selection.
  void _showThemePanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      // Using the dedicated ThemePanel widget.
      builder: (context) => const ThemePanel(),
    );
  }

  // Shows a dialog to add a new task.
  void _showAddTaskDialog(BuildContext context, TaskProvider taskProvider) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('افزودن وظیفه جدید'),
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
                  taskProvider.addTask(title);
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

  // Shows a confirmation dialog before deleting all tasks.
  void _showDeleteAllConfirmationDialog(
      BuildContext context, TaskProvider taskProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تایید حذف'),
          content: const Text('آیا از حذف تمام وظایف مطمئن هستید؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('خیر'),
            ),
            TextButton(
              onPressed: () {
                taskProvider.deleteAllTasks();
                Navigator.pop(context);
              },
              child: const Text('بله'),
            ),
          ],
        );
      },
    );
  }

  // Helper widget for the empty state.
  Widget _buildEmptyState() {
    return const SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text('هیچ وظیفه‌ای برای نمایش وجود ندارد!',
                style: TextStyle(fontSize: 18, color: Colors.grey)),
            Text('یک وظیفه جدید اضافه کنید',
                style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  // Helper widget for the no search results state.
  Widget _buildNoResultsState() {
    return const SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text('هیچ نتیجه‌ای یافت نشد!',
                style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
