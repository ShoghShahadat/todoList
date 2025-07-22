import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:todoly_flutter/providers/theme_provider.dart';
import 'package:todoly_flutter/utils/app_themes.dart';

import 'models/task.dart';
import 'providers/task_provider.dart';
import 'screens/home_screen.dart';

// The main entry point of the application.
void main() async {
  // Ensure that Flutter bindings are initialized before calling native code.
  WidgetsFlutterBinding.ensureInitialized();

  // Get the application documents directory for storing Hive database.
  final appDocumentDir = await getApplicationDocumentsDirectory();

  // Initialize Hive in the specified directory.
  await Hive.initFlutter(appDocumentDir.path);

  // Register the adapter for the Task model.
  Hive.registerAdapter(TaskAdapter());

  // Open the box where tasks will be stored.
  await Hive.openBox<Task>('tasks');

  // Open the box for theme settings.
  await Hive.openBox('theme_settings');

  // Run the Flutter application.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Using MultiProvider to provide multiple providers to the widget tree.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TaskProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      // Consumer for ThemeProvider to rebuild the MaterialApp on theme changes.
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'ToDoly Flutter',
            debugShowCheckedModeBanner: false,

            // Set the theme based on the provider's state.
            theme: themeProvider.selectedTheme.lightTheme,
            darkTheme: themeProvider.selectedTheme.darkTheme,
            themeMode: themeProvider.themeMode,

            // The home screen of the application.
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
