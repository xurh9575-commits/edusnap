import 'package:flutter/material.dart';

import '../../Models/JournalEntry.dart';
import 'AddPageController.dart';

class AddPage extends StatefulWidget {
  final JournalEntry? entry;
  const AddPage({super.key, this.entry});
  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  late final AddPageController controller;
  @override
  void initState() {
    super.initState();
    controller = AddPageController(original: widget.entry);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void save() {
    if (!controller.hasTitle) {
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Title required'),
          content: const Text('Please enter a title before saving your entry.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
    Navigator.pop(context, controller.save());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(controller.isEditing ? 'Edit entry' : 'Add entry'),
    ),
    body: SafeArea(
      child: Form(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              controller.isEditing
                  ? 'Revisit your story'
                  : 'What happened today?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            TextFormField(
              key: const Key('entry-title'),
              controller: controller.title,
              decoration: const InputDecoration(labelText: 'Title (required)'),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 20),
            TextFormField(
              key: const Key('entry-note'),
              controller: controller.note,
              decoration: const InputDecoration(
                labelText: 'Note (optional)',
                alignLabelWithHint: true,
              ),
              minLines: 5,
              maxLines: 10,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: save,
              icon: const Icon(Icons.check),
              label: const Text('Save'),
            ),
          ],
        ),
      ),
    ),
  );
}
