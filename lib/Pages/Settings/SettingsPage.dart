import 'package:flutter/material.dart';

import 'SettingsPageController.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = SettingsPageController();
    return Scaffold(
      appBar: AppBar(title: Text(controller.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Icon(Icons.menu_book_outlined, size: 48),
            const SizedBox(height: 16),
            Text(
              'EduSnap',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 32),
            Text(
              'About your entries',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(controller.storageMessage),
          ],
        ),
      ),
    );
  }
}
