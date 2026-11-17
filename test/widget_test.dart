import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edusnap/main.dart';
import 'package:edusnap/Utils/AppSettings.dart';
import 'package:edusnap/Utils/JournalStorage.dart';
import 'package:edusnap/Utils/PhotoPicker.dart';
import 'package:edusnap/Pages/Add/AddPage.dart';
import 'package:edusnap/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:edusnap/Models/JournalEntry.dart';

class MemoryStorage extends JournalStorage {
  MemoryStorage(super.root);
  List<JournalEntry> data = [];
  @override
  Future<List<JournalEntry>> load() async => [...data];
  @override
  Future<void> save(List<JournalEntry> entries) async {
    data = [...entries];
  }

  @override
  Future<String?> importPhoto(String? path) async => path;
  @override
  Future<void> removeUnusedPhotos(List<JournalEntry> entries) async {}
  @override
  Future<int> sizeBytes() async => data.isEmpty ? 0 : 1024;
  @override
  Future<void> clear() async {
    data = [];
  }
}

class DeniedPicker extends PhotoPicker {
  @override
  Future<String?> recover() async => null;
  @override
  Future<String?> pick(ImageSource source) async =>
      throw PhotoPermissionDenied();
}

Future<void> settleIO(WidgetTester tester) async {
  await tester.pump();
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 150)),
  );
  await tester.pumpAndSettle();
}

Future<void> tapSave(WidgetTester tester) async {
  await tester.ensureVisible(find.byKey(const Key('save-entry')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('save-entry')));
  await settleIO(tester);
}

void main() {
  late Directory root;
  late AppSettings settings;
  setUp(() async {
    root = await Directory.systemTemp.createTemp('edusnap-ui-');
    SharedPreferences.setMockInitialValues({});
    settings = AppSettings(await SharedPreferences.getInstance());
  });
  tearDown(() async {
    await root.delete(recursive: true);
    settings.dispose();
  });
  testWidgets(
    'add, validate, repeated edit, delete confirmation, reopen and localize',
    (tester) async {
      final storage = MemoryStorage(root);
      await tester.pumpWidget(MyApp(storage: storage, settings: settings));
      await settleIO(tester);
      await tester.tap(find.byTooltip('Add entry'));
      await settleIO(tester);
      await tester.enterText(find.byKey(const Key('entry-title')), '   ');
      await tapSave(tester);
      expect(find.text('Title required'), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('entry-title')),
        'My new story',
      );
      await tester.enterText(
        find.byKey(const Key('entry-note')),
        'A note to remember',
      );
      await tapSave(tester);
      expect(find.text('My new story'), findsOneWidget);
      await tester.tap(find.text('My new story'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Created on'), findsOneWidget);
      for (final title in ['First edit', 'Second edit']) {
        await tester.tap(find.text('Edit'));
        await settleIO(tester);
        expect(
          tester
              .widget<TextFormField>(find.byKey(const Key('entry-note')))
              .controller!
              .text,
          'A note to remember',
        );
        await tester.enterText(find.byKey(const Key('entry-title')), title);
        await tapSave(tester);
        expect(find.text(title), findsOneWidget);
      }
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
      await tester.pumpWidget(MyApp(storage: storage, settings: settings));
      await settleIO(tester);
      expect(find.text('Second edit'), findsOneWidget);
      await tester.drag(find.byType(Dismissible).first, const Offset(-650, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('Second edit'), findsOneWidget);
      await tester.drag(find.byType(Dismissible).first, const Offset(-650, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await settleIO(tester);
      expect(find.text('Second edit'), findsNothing);
      expect(find.text('Your next story starts here.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'Traditional Chinese, placeholders, clear requires both confirmations, preference survives',
    (tester) async {
      final storage = MemoryStorage(root);
      await tester.pumpWidget(MyApp(storage: storage, settings: settings));
      await settleIO(tester);
      await tester.tap(find.byTooltip('Settings'));
      await settleIO(tester);
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Traditional Chinese').last);
      await settleIO(tester);
      expect(find.text('設定'), findsOneWidget);
      expect(find.text('已使用 0 KB'), findsOneWidget);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('新增日記'));
      await settleIO(tester);
      await tester.enterText(find.byKey(const Key('entry-title')), '中文日記');
      await tapSave(tester);
      expect(find.textContaining('建立'), findsOneWidget);
      await tester.tap(find.byTooltip('設定'));
      await settleIO(tester);
      expect(find.text('已使用 0 KB'), findsNothing);
      await tester.tap(find.byKey(const Key('clear-journals')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('confirm-clear-first')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(await tester.runAsync(storage.load), isNotEmpty);
      await tester.tap(find.byKey(const Key('clear-journals')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('confirm-clear-first')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('confirm-clear-final')));
      await settleIO(tester);
      expect(find.text('已使用 0 KB'), findsOneWidget);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.text('由這裡開始記錄你的故事。'), findsOneWidget);
      expect(settings.locale.scriptCode, 'Hant');
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'denied camera and gallery show settings dialog and allow no-photo entry',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AddPage(
            onSave: (entry) async => entry,
            photoPicker: DeniedPicker(),
          ),
        ),
      );
      await settleIO(tester);
      for (final key in ['pick-camera', 'pick-gallery']) {
        await tester.ensureVisible(find.byKey(Key(key)));
        await tester.tap(find.byKey(Key(key)));
        await tester.pumpAndSettle();
        expect(find.text('Photo access needed'), findsOneWidget);
        expect(find.text('Open app settings'), findsOneWidget);
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
      }
      expect(tester.takeException(), isNull);
    },
  );
}
