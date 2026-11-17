import '../../Component/DuoHost/DuoHost.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Models/JournalEntry.dart';
import '../../Component/JournalPhoto/JournalPhoto.dart';
import '../../l10n/app_localizations.dart';
import '../Add/AddPage.dart';
import 'DetailPageController.dart';

class DetailPage extends StatefulWidget {
  final JournalEntry entry;
  final Future<JournalEntry> Function(
    JournalEntry original,
    JournalEntry updated,
  )
  onSave;
  const DetailPage({super.key, required this.entry, required this.onSave});
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late final DetailPageController controller;
  @override
  void initState() {
    super.initState();
    controller = DetailPageController(widget.entry);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> edit() async {
    final original = controller.entry;
    final updated = await Navigator.push<JournalEntry>(
      context,
      MaterialPageRoute(
        builder: (_) => AddPage(
          entry: original,
          onSave: (draft) => widget.onSave(original, draft),
        ),
      ),
    );
    if (!mounted || updated == null) return;
    controller.update(updated);
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !(DuoHost.of(context)?.railActive ?? false),
        title: Text(s.entry),
        actions: [
          TextButton.icon(
            onPressed: edit,
            icon: const Icon(Icons.edit_outlined),
            label: Text(s.edit),
          ),
        ],
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) => SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.createdOn(
                    DateFormat.yMMMd(s.localeName)
                        .format(controller.entry.createdAt),
                  ),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  controller.entry.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                JournalPhoto(path: controller.entry.photoPath, height: 240),
                const SizedBox(height: 24),
                SelectableText(
                  controller.entry.note.isEmpty
                      ? s.noNote
                      : controller.entry.note,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
