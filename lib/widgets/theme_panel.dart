import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../utils/app_themes.dart';

// A dedicated widget for the theme selection panel shown in a modal bottom sheet.
class ThemePanel extends StatelessWidget {
  const ThemePanel({super.key});

  @override
  Widget build(BuildContext context) {
    // Using a Consumer to listen to and rebuild upon theme changes.
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Panel Title
              Text('انتخاب تم', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),

              // Color selection section
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: AppTheme.themes.map((theme) {
                  return InkWell(
                    onTap: () => themeProvider.setTheme(theme),
                    borderRadius: BorderRadius.circular(20),
                    child: CircleAvatar(
                      backgroundColor: theme.color,
                      child: themeProvider.selectedTheme.name == theme.name
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Mode selection section (Light/Dark/System)
              Text('حالت نمایش', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              SegmentedButton<ThemeMode>(
                segments: const <ButtonSegment<ThemeMode>>[
                  ButtonSegment<ThemeMode>(
                      value: ThemeMode.light,
                      label: Text('روشن'),
                      icon: Icon(Icons.wb_sunny_outlined)),
                  ButtonSegment<ThemeMode>(
                      value: ThemeMode.dark,
                      label: Text('تاریک'),
                      icon: Icon(Icons.nightlight_round_outlined)),
                  ButtonSegment<ThemeMode>(
                      value: ThemeMode.system,
                      label: Text('سیستم'),
                      icon: Icon(Icons.settings_system_daydream_outlined)),
                ],
                selected: <ThemeMode>{themeProvider.themeMode},
                onSelectionChanged: (Set<ThemeMode> newSelection) {
                  themeProvider.setThemeMode(newSelection.first);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
