import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edusnap/Models/JournalEntry.dart';
import 'package:edusnap/Pages/HomePage/HomePageController.dart';
import 'package:edusnap/Utils/JournalStorage.dart';
import 'package:edusnap/Utils/AppSettings.dart';

void main() {
  late Directory root;
  late JournalStorage storage;
  setUp(() async {
    root = await Directory.systemTemp.createTemp('edusnap-test-');
    storage = JournalStorage(Directory('${root.path}/journal'));
  });
  tearDown(() async {
    await root.delete(recursive: true);
  });
  test(
    'save, reopen, edit photo, delete, and clear without reviving entries',
    () async {
      final source = File('${root.path}/source.png');
      await source.writeAsBytes(
        base64Decode(
          'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+jRZkAAAAASUVORK5CYII=',
        ),
      );
      final home = HomePageController(storage);
      await home.load();
      expect(home.entries, isEmpty);
      final created = DateTime(2026, 11, 17);
      final saved = await home.saveEntry(
        JournalEntry(
          title: 'Photo journal',
          note: 'Note',
          createdAt: created,
          photoPath: source.path,
        ),
      );
      expect(saved.photoPath, isNot(source.path));
      expect(await File(saved.photoPath!).exists(), isTrue);
      await source.delete();
      final reopened = HomePageController(storage);
      await reopened.load();
      expect(reopened.entries.single.title, 'Photo journal');
      expect(
        await File(reopened.entries.single.photoPath!).readAsBytes(),
        isNotEmpty,
      );
      final original = reopened.entries.single;
      final updated = await reopened.saveEntry(
        JournalEntry(title: 'Edited', note: '', createdAt: original.createdAt),
        original: original,
      );
      expect(updated.createdAt, created);
      expect(await File(saved.photoPath!).exists(), isFalse);
      expect((await storage.load()).single.title, 'Edited');
      await reopened.delete(updated);
      expect(await storage.load(), isEmpty);
      await reopened.clear();
      expect(await storage.sizeBytes(), 0);
      expect(await storage.load(), isEmpty);
      home.dispose();
      reopened.dispose();
    },
  );
  test('corrupt journal is kept, and writes remain blocked', () async {
    await storage.root.create(recursive: true);
    await storage.journal.writeAsString('{broken');
    final home = HomePageController(storage);
    await home.load();
    expect(home.loadFailed, isTrue);
    await expectLater(
      home.saveEntry(
        JournalEntry(title: 'New', note: '', createdAt: DateTime.now()),
      ),
      throwsStateError,
    );
    expect(await storage.journal.readAsString(), '{broken');
    home.dispose();
  });
  test('photo import failure preserves existing journal', () async {
    final home = HomePageController(storage);
    await home.load();
    await home.saveEntry(
      JournalEntry(title: 'Keep me', note: '', createdAt: DateTime.now()),
    );
    await expectLater(
      home.saveEntry(
        JournalEntry(
          title: 'Missing',
          note: '',
          createdAt: DateTime.now(),
          photoPath: '${root.path}/missing.jpg',
        ),
      ),
      throwsA(isA<FileSystemException>()),
    );
    expect((await storage.load()).single.title, 'Keep me');
    expect(home.busy, isFalse);
    home.dispose();
  });
  test('language persists independently of journal clear', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await AppSettings(prefs).setLanguage('zh');
    final settings = AppSettings(prefs);
    expect(settings.locale.languageCode, 'zh');
    expect(settings.locale.scriptCode, 'Hant');
    await storage.clear();
    expect(AppSettings(prefs).locale.languageCode, 'zh');
    expect(await storage.sizeBytes(), 0);
  });
}
