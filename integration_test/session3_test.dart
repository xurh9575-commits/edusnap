import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edusnap/main.dart';
import 'package:edusnap/Models/JournalEntry.dart';
import 'package:edusnap/Pages/HomePage/HomePageController.dart';
import 'package:edusnap/Utils/AppSettings.dart';
import 'package:edusnap/Utils/JournalStorage.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Android: durable photo, edit, language preference, double clear', (
    tester,
  ) async {
    final base = await getTemporaryDirectory();
    final root = await Directory(
      '${base.path}/session4-verification-${DateTime.now().microsecondsSinceEpoch}',
    ).create(recursive: true);
    final storage = JournalStorage(Directory('${root.path}/journal'));
    final prefs = await SharedPreferences.getInstance();
    final oldLanguage = prefs.getString('language');
    final settings = AppSettings(prefs);
    await settings.setLanguage('en');
    final source = File('${root.path}/source.png');
    await source.writeAsBytes(
      base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+jRZkAAAAASUVORK5CYII=',
      ),
    );
    final controller = HomePageController(storage);
    await controller.load();
    final entry = await controller.saveEntry(
      JournalEntry(
        title: 'Android photo test',
        note: 'Saved on device',
        createdAt: DateTime(2026, 11, 17),
        photoPath: source.path,
      ),
    );
    await source.delete();
    controller.dispose();
    await tester.pumpWidget(MyApp(storage: storage, settings: settings));
    await tester.pumpAndSettle();
    expect(find.text('Android photo test'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(await File(entry.photoPath!).exists(), isTrue);
    await tester.tap(find.text('Android photo test'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('entry-title')),
      'Edited on Android',
    );
    await Future<void>.delayed(const Duration(milliseconds: 800));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const Key('save-entry')),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-entry')));
    await tester.pumpAndSettle();
    expect(find.text('Edited on Android'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('app-version')));
    await tester.pumpAndSettle();
    expect(find.text('Version (build): 1.1.0 (4)'), findsOneWidget);
    await tester.ensureVisible(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Traditional Chinese').last);
    await tester.pumpAndSettle();
    expect(find.text('設定'), findsOneWidget);
    expect(
      AppSettings(await SharedPreferences.getInstance()).locale.scriptCode,
      'Hant',
    );
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    await tester.pumpWidget(
      MyApp(
        storage: storage,
        settings: AppSettings(await SharedPreferences.getInstance()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Edited on Android'), findsOneWidget);
    expect(find.textContaining('建立'), findsOneWidget);
    await tester.tap(find.byTooltip('設定'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('clear-journals')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirm-clear-first')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    expect(await storage.load(), isNotEmpty);
    await tester.tap(find.byKey(const Key('clear-journals')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirm-clear-first')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirm-clear-final')));
    await tester.pumpAndSettle();
    expect(find.text('已使用 0 KB'), findsOneWidget);
    expect(await storage.sizeBytes(), 0);
    expect(await File(entry.photoPath!).exists(), isFalse);
    expect(await storage.load(), isEmpty);
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    if (oldLanguage == null) {
      await prefs.remove('language');
    } else {
      await prefs.setString('language', oldLanguage);
    }
    settings.dispose();
    await root.delete(recursive: true);
  });
}
