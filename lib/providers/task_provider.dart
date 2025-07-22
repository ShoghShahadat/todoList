import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  // A reference to the Hive box where tasks are stored.
  final Box<Task> _taskBox = Hive.box<Task>('tasks');

  // A private list to hold the tasks for searching purposes.
  List<Task> _tasks = [];

  // Public getter to access the list of tasks.
  // It returns the tasks sorted by completion status (incomplete tasks first).
  List<Task> get tasks {
    // Load all tasks from the box.
    _tasks = _taskBox.values.toList();
    // Sort tasks: incomplete tasks first, then complete tasks.
    _tasks.sort((a, b) => a.isCompleted == b.isCompleted ? 0 : (a.isCompleted ? 1 : -1));
    return _tasks;
  }
  
  // A list to hold the results of a search.
  List<Task> _searchResults = [];
  
  // Public getter for search results.
  List<Task> get searchResults => _searchResults;


  // Adds a new task to the database.
  Future<void> addTask(String title) async {
    // Create a new task with a unique ID based on the current timestamp.
    final newTask = Task(
      id: DateTime.now().toIso8601String(),
      title: title,
      isCompleted: false,
    );
    // Add the new task to the Hive box using its ID as the key.
    await _taskBox.put(newTask.id, newTask);
    // Notify all listening widgets that the data has changed.
    notifyListeners();
  }

  // Toggles the completion status of a task.
  Future<void> toggleTaskStatus(Task task) async {
    // Invert the completion status.
    task.isCompleted = !task.isCompleted;
    // Save the updated task back to the Hive box.
    await task.save();
    // Notify listeners to rebuild the UI.
    notifyListeners();
  }
  
  // Updates the title of an existing task.
  Future<void> updateTaskTitle(Task task, String newTitle) async {
    task.title = newTitle;
    await task.save();
    notifyListeners();
  }

  // Deletes a task from the database.
  Future<void> deleteTask(Task task) async {
    // Delete the task from the Hive box.
    await task.delete();
    // Notify listeners to update the UI.
    notifyListeners();
  }
  
  // Deletes all tasks from the database.
  Future<void> deleteAllTasks() async {
      await _taskBox.clear();
      notifyListeners();
  }
  
  // Searches for tasks containing the query string.
  void searchTasks(String query) {
      if (query.isEmpty) {
          _searchResults = [];
      } else {
          _searchResults = _tasks
              .where((task) => task.title.toLowerCase().contains(query.toLowerCase()))
              .toList();
      }
      notifyListeners();
  }
}
