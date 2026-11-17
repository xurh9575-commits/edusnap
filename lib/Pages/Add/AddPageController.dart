import 'package:flutter/material.dart';

import '../../Models/JournalEntry.dart';

class AddPageController {
  final JournalEntry? original;
  final TextEditingController title;
  final TextEditingController note;
  AddPageController({this.original})
    : title = TextEditingController(text: original?.title ?? ''),
      note = TextEditingController(text: original?.note ?? '');
  bool get isEditing => original != null;
  bool get hasTitle => title.text.trim().isNotEmpty;
  JournalEntry save() => JournalEntry(
    title: title.text.trim(),
    note: note.text.trim(),
    createdAt: original?.createdAt ?? DateTime.now(),
  );
  void dispose() {
    title.dispose();
    note.dispose();
  }
}
