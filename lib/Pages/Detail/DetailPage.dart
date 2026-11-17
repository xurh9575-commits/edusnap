import 'package:flutter/material.dart';

import '../../Models/JournalEntry.dart';
import '../../Utils/JournalDate.dart';
import '../Add/AddPage.dart';
import 'DetailPageController.dart';

class DetailPage extends StatefulWidget {
  final JournalEntry entry;
  final void Function(JournalEntry original, JournalEntry updated) onChanged;
  const DetailPage({super.key, required this.entry, required this.onChanged});
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
      MaterialPageRoute(builder: (_) => AddPage(entry: original)),
    );
    if (!mounted || updated == null) return;
    widget.onChanged(original, updated);
    controller.update(updated);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Entry'),
      actions: [
        TextButton.icon(
          onPressed: edit,
          icon: const Icon(Icons.edit_outlined),
          label: const Text('Edit'),
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
                journalDate(controller.entry.createdAt),
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 16),
              Text(
                controller.entry.title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              SelectableText(
                controller.entry.note.isEmpty
                    ? 'No note added'
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
