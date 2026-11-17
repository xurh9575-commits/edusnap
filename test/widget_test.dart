import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edusnap/main.dart';
import 'package:edusnap/Component/JournalCard/JournalCard.dart';
import 'package:edusnap/Pages/HomePage/HomePageController.dart';
import 'package:edusnap/Pages/Add/AddPageController.dart';

void main() {
  testWidgets(
    'Session 2 navigation, validation, add, repeated edit and delete',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.byType(JournalCard), findsNWidgets(3));
      await tester.tap(find.byTooltip('Settings'));
      await tester.pumpAndSettle();
      expect(find.text('About your entries'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Add entry'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('entry-title')), '   ');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
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
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<JournalCard>(find.byType(JournalCard).first).entry.title,
        'My new story',
      );
      await tester.tap(find.text('My new story'));
      await tester.pumpAndSettle();
      expect(find.text('A note to remember'), findsOneWidget);

      for (final title in ['First edit', 'Second edit']) {
        await tester.tap(find.text('Edit'));
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<TextFormField>(find.byKey(const Key('entry-note')))
              .controller!
              .text,
          'A note to remember',
        );
        await tester.enterText(find.byKey(const Key('entry-title')), title);
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();
        expect(find.text(title), findsOneWidget);
      }
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('Second edit'), findsOneWidget);
      expect(
        tester.widget<JournalCard>(find.byType(JournalCard).first).entry.title,
        'Second edit',
      );

      await tester.drag(find.byType(Dismissible).first, const Offset(-650, 0));
      await tester.pumpAndSettle();
      expect(find.text('Delete entry?'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('Second edit'), findsOneWidget);
      await tester.drag(find.byType(Dismissible).first, const Offset(-650, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      expect(find.text('Second edit'), findsNothing);
      expect(find.text('3 entries · Swipe left to delete'), findsOneWidget);

      for (var i = 0; i < 3; i++) {
        await tester.drag(
          find.byType(Dismissible).first,
          const Offset(-650, 0),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();
      }
      expect(find.text('Your next story starts here.'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Add entry'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('entry-title')),
        'Title only',
      );
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.text('Title only'), findsOneWidget);
      expect(find.text('No note added'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Back cancels new and edited entries; narrow screen supports large text',
    (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
          child: const MyApp(),
        ),
      );
      await tester.tap(find.byTooltip('Add entry'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('entry-title')),
        'Discard me',
      );
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('Discard me'), findsNothing);
      await tester.tap(find.text('A fresh start'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('entry-title')),
        'Unsaved edit',
      );
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('A fresh start'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('A fresh start'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  test('Editing preserves creation time and list position', () {
    final home = HomePageController();
    final original = home.entries[1];
    final editor = AddPageController(original: original);
    editor.title.text = '  Updated  ';
    editor.note.text = '';
    final updated = editor.save();
    expect(updated.createdAt, original.createdAt);
    expect(updated.title, 'Updated');
    expect(updated.note, isEmpty);
    home.update(original, updated);
    expect(home.entries[1], same(updated));
    expect(home.entries.length, 3);
    editor.dispose();
    home.dispose();
  });
}
