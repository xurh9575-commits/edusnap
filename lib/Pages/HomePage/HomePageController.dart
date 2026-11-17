import 'package:flutter/foundation.dart';

import '../../Models/JournalEntry.dart';

class HomePageController extends ChangeNotifier {
  final List<JournalEntry> _entries = [
    JournalEntry(
      title: 'A fresh start',
      note: 'Today I started my Flutter journal. One small step at a time.',
      createdAt: DateTime(2026, 10, 27),
    ),
    JournalEntry(
      title: 'A quiet afternoon',
      note: 'A short walk and a cup of tea helped me clear my head.',
      createdAt: DateTime(2026, 10, 26),
    ),
    JournalEntry(
      title: 'Something I learned',
      note: 'Every page has a purpose. Keeping the code organised makes it easier to learn.',
      createdAt: DateTime(2026, 10, 25),
    ),
  ];
  List<JournalEntry> get entries => List.unmodifiable(_entries);
  void add(JournalEntry entry) {
    _entries.insert(0, entry);
    notifyListeners();
  }

  void update(JournalEntry original, JournalEntry updated) {
    final index = _entries.indexOf(original);
    if (index < 0) return;
    _entries[index] = updated;
    notifyListeners();
  }

  void delete(JournalEntry entry) {
    _entries.remove(entry);
    notifyListeners();
  }
}
