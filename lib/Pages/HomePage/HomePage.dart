import 'package:flutter/material.dart';

import '../../Component/JournalCard/JournalCard.dart';
import '../../Models/JournalEntry.dart';
import '../Add/AddPage.dart';
import '../Detail/DetailPage.dart';
import '../Settings/SettingsPage.dart';
import 'HomePageController.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomePageController controller;
  @override
  void initState() {
    super.initState();
    controller = HomePageController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> addEntry() async {
    final entry = await Navigator.push<JournalEntry>(
      context,
      MaterialPageRoute(builder: (_) => const AddPage()),
    );
    if (!mounted || entry == null) return;
    controller.add(entry);
  }

  Future<bool> confirmDelete(JournalEntry entry) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete entry?'),
          content: Text('Delete “${entry.title}”?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        ),
      ) ??
      false;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('EduSnap'),
      leading: IconButton(
        tooltip: 'Settings',
        icon: const Icon(Icons.settings_outlined),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsPage()),
        ),
      ),
      actions: [
        IconButton(
          tooltip: 'Add entry',
          onPressed: addEntry,
          icon: const Icon(Icons.add),
        ),
      ],
    ),
    body: SafeArea(
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          final entries = controller.entries;
          if (entries.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.menu_book_outlined, size: 48),
                    const SizedBox(height: 16),
                    const Text('Your next story starts here.'),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: addEntry,
                      icon: const Icon(Icons.add),
                      label: const Text('Add entry'),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Your journal',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text('${entries.length} entries · Swipe left to delete'),
              const SizedBox(height: 20),
              for (final entry in entries)
                Dismissible(
                  key: ObjectKey(entry),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) => confirmDelete(entry),
                  onDismissed: (_) => controller.delete(entry),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    color: Theme.of(context).colorScheme.errorContainer,
                    child: Icon(
                      Icons.delete_outline,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                  child: JournalCard(
                    entry: entry,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailPage(
                          entry: entry,
                          onChanged: controller.update,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    ),
  );
}
