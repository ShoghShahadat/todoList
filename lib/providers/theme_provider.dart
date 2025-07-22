import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../utils/app_themes.dart';

class ThemeProvider extends ChangeNotifier {
  // A reference to the Hive box where theme settings are stored.
  late Box _settingsBox;

  // Private fields for the current theme mode and selected theme.
  ThemeMode _themeMode = ThemeMode.system;
  AppTheme _selectedTheme =
      AppTheme.themes.first; // Default to the first theme (Blue)

  // Public getters to access the current theme state.
  ThemeMode get themeMode => _themeMode;
  AppTheme get selectedTheme => _selectedTheme;

  // Constructor: Initializes the provider by loading saved settings.
  ThemeProvider() {
    _init();
  }

  // Initializes the provider and loads settings from Hive.
  Future<void> _init() async {
    // Open the settings box. We will do this in main.dart as well.
    _settingsBox = await Hive.openBox('theme_settings');
    _loadThemeSettings();
  }

  // Loads the saved theme and mode from Hive.
  void _loadThemeSettings() {
    // Load the saved theme mode. Default to system if not found.
    final savedModeIndex = _settingsBox.get('theme_mode',
        defaultValue: ThemeMode.system.index) as int;
    _themeMode = ThemeMode.values[savedModeIndex];

    // Load the saved theme color name. Default to the first theme's name if not found.
    final savedThemeName = _settingsBox.get('theme_name',
        defaultValue: AppTheme.themes.first.name) as String;

    // Find the theme with the saved name.
    _selectedTheme = AppTheme.themes.firstWhere(
      (theme) => theme.name == savedThemeName,
      orElse: () => AppTheme.themes.first, // Fallback to the first theme
    );

    // Notify listeners that the initial theme has been loaded.
    notifyListeners();
  }

  // Updates the application's theme mode (Light, Dark, System).
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    // Save the new mode to Hive.
    _settingsBox.put('theme_mode', mode.index);
    // Notify all listening widgets to rebuild with the new mode.
    notifyListeners();
  }

  // Updates the application's primary color theme.
  void setTheme(AppTheme theme) {
    _selectedTheme = theme;
    // Save the new theme's name to Hive.
    _settingsBox.put('theme_name', theme.name);
    // Notify all listening widgets to rebuild with the new theme.
    notifyListeners();
  }
}
