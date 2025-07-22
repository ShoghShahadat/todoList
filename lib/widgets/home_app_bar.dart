import 'package:flutter/material.dart';

// A dedicated widget for the app bar on the home screen.
// It includes the title, search field, and action buttons.
class HomeAppBar extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback onThemePressed;
  final VoidCallback onDeleteAllPressed;

  const HomeAppBar({
    super.key,
    required this.searchController,
    required this.onThemePressed,
    required this.onDeleteAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      snap: false,
      expandedHeight: 120.0,
      title: const Text('لیست وظایف'),
      actions: [
        // Button to open the theme selection panel.
        IconButton(
          icon: const Icon(Icons.color_lens_outlined),
          onPressed: onThemePressed,
        ),
        // Button to delete all tasks.
        IconButton(
          icon: const Icon(Icons.delete_sweep_outlined),
          onPressed: onDeleteAllPressed,
        ),
      ],
      // The flexible space part contains the search bar.
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.only(
              top: 90.0, left: 16.0, right: 16.0, bottom: 8.0),
          child: _buildSearchField(context),
        ),
      ),
    );
  }

  // Helper method to build the search text field.
  Widget _buildSearchField(BuildContext context) {
    return TextField(
      controller: searchController,
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
}
