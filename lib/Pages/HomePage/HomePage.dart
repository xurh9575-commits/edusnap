import '../../Component/DuoHost/DuoHost.dart';

import 'package:flutter/material.dart';

import '../../Component/JournalCard/JournalCard.dart';
import '../../Models/JournalEntry.dart';
import '../../Utils/AppSettings.dart';
import '../../l10n/app_localizations.dart';
import '../Add/AddPage.dart';
import '../Detail/DetailPage.dart';
import '../Settings/SettingsPage.dart';
import 'HomePageController.dart';

class HomePage extends StatefulWidget {
  final HomePageController controller;
  final AppSettings settings;
  const HomePage({super.key, required this.controller, required this.settings});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageController get controller => widget.controller;
  @override
  void initState() {
    super.initState();
    controller.load();
  }

  void addEntry() => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => AddPage(onSave: (draft) => controller.saveEntry(draft)),
    ),
  );
  Future<bool> delete(JournalEntry entry) async {
    final s = AppLocalizations.of(context)!;
    final accepted =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(s.deleteTitle),
            content: Text(s.deleteBody(entry.title)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(s.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(s.delete),
              ),
            ],
          ),
        ) ??
        false;
    if (accepted) {
      try {
        await controller.delete(entry);
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(s.storageError)));
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: Text(s.appTitle),
          leading: IconButton(
            tooltip: s.settings,
            icon: const Icon(Icons.settings_outlined),
            onPressed: controller.loading
                ? null
                : () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SettingsPage(
                        journal: controller,
                        settings: widget.settings,
                      ),
                    ),
                  ),
          ),
          actions: [
            IconButton(
              tooltip: s.addEntry,
              onPressed:
                  controller.loading || controller.loadFailed || controller.busy
                  ? null
                  : addEntry,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: SafeArea(
          child: controller.loading
              ? const Center(child: CircularProgressIndicator())
              : controller.loadFailed
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(s.storageError),
                        TextButton(
                          onPressed: controller.load,
                          child: Text(s.retry),
                        ),
                      ],
                    ),
                  ),
                )
              : controller.entries.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.menu_book_outlined, size: 48),
                        const SizedBox(height: 16),
                        Text(s.emptyJournal),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: controller.busy ? null : addEntry,
                          icon: const Icon(Icons.add),
                          label: Text(s.addEntry),
                        ),
                      ],
                    ),
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) => ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      Text(
                        s.journal,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(s.entryCount('${controller.entries.length}')),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          for (final entry in controller.entries)
                            SizedBox(
                              width:
                                  (DuoHost.of(context)?.fullyOpen ?? false) &&
                                      constraints.maxWidth >= 720
                                  ? (constraints.maxWidth - 56) / 2
                                  : constraints.maxWidth - 40,
                              child: Dismissible(
                                key: ObjectKey(entry),
                                direction: controller.busy
                                    ? DismissDirection.none
                                    : DismissDirection.endToStart,
                                confirmDismiss: (_) => delete(entry),
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 24),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .errorContainer,
                                  child: Icon(
                                    Icons.delete_outline,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer,
                                  ),
                                ),
                                child: JournalCard(
                                  entry: entry,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailPage(
                                        entry: entry,
                                        onSave: (original, updated) =>
                                            controller.saveEntry(
                                              updated,
                                              original: original,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
