import 'package:flutter/foundation.dart';

import '../../Models/JournalEntry.dart';
import '../../Utils/JournalStorage.dart';

class HomePageController extends ChangeNotifier {
  final JournalStorage storage;
  HomePageController(this.storage);
  List<JournalEntry> _entries = [];
  bool loading = true;
  bool busy = false;
  bool loadFailed = false;
  List<JournalEntry> get entries => List.unmodifiable(_entries);

  Future<void> load() async {
    loading = true;
    notifyListeners();
    try {
      _entries = await storage.load();
      loadFailed = false;
    } catch (_) {
      loadFailed = true;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<JournalEntry> saveEntry(
    JournalEntry draft, {
    JournalEntry? original,
  }) async {
    if (busy || loading || loadFailed) throw StateError('Journal not ready');
    busy = true;
    notifyListeners();
    String? imported;
    try {
      imported = await storage.importPhoto(draft.photoPath);
      final saved = JournalEntry(
        title: draft.title,
        note: draft.note,
        createdAt: draft.createdAt,
        photoPath: imported,
      );
      final next = [..._entries];
      if (original == null) {
        next.insert(0, saved);
      } else {
        final index = next.indexOf(original);
        if (index < 0) throw StateError('Entry not found');
        next[index] = saved;
      }
      await storage.save(next);
      _entries = next;
      // A cleanup failure must not turn a successful save into a duplicate retry.
      try {
        await storage.removeUnusedPhotos(_entries);
      } catch (_) {}
      return saved;
    } catch (_) {
      try {
        await storage.removeUnusedPhotos(_entries);
      } catch (_) {}
      rethrow;
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  Future<void> delete(JournalEntry entry) async {
    if (busy) throw StateError('Journal busy');
    busy = true;
    notifyListeners();
    try {
      final next = [..._entries]..remove(entry);
      await storage.save(next);
      _entries = next;
      try {
        await storage.removeUnusedPhotos(_entries);
      } catch (_) {}
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  Future<void> clear() async {
    if (busy || loading) throw StateError('Journal busy');
    busy = true;
    notifyListeners();
    try {
      await storage.clear();
      _entries = [];
      loadFailed = false;
    } finally {
      busy = false;
      notifyListeners();
    }
  }
}
