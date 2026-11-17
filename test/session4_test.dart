import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edusnap/main.dart';
import 'package:edusnap/Models/JournalEntry.dart';
import 'package:edusnap/Utils/AppSettings.dart';
import 'package:edusnap/Component/DuoHost/DuoHost.dart';

import 'widget_test.dart' show MemoryStorage, settleIO;

void main() {
  testWidgets(
    'Duo fold layout, native back, fallback and actual package metadata',
    (tester) async {
      final root = Directory('session4-memory-test');
      SharedPreferences.setMockInitialValues({});
      final settings = AppSettings(await SharedPreferences.getInstance());
      PackageInfo.setMockInitialValues(
        appName: 'EduSnap',
        packageName: 'com.example.edusnap',
        version: '2.3.4',
        buildNumber: '99',
        buildSignature: '',
      );
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
      const rail = MethodChannel('itchi_flutter_duo_layout/side_back');
      const fold = MethodChannel('itchi_flutter_duo_layout/fold');
      var available = true;
      messenger.setMockMethodCallHandler(
        rail,
        (call) async => {
          'status': available ? 'available' : 'unsupportedPlatform',
        },
      );
      messenger.setMockMethodCallHandler(fold, (call) async => null);
      addTearDown(() async {
        await tester.pumpWidget(const SizedBox());
        await tester.pumpAndSettle();
        debugDefaultTargetPlatformOverride = null;
        messenger.setMockMethodCallHandler(rail, null);
        messenger.setMockMethodCallHandler(fold, null);
        settings.dispose();
      });
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final storage = MemoryStorage(root);
      storage.data = [
        JournalEntry(title: 'Fold story', note: '', createdAt: DateTime(2026)),
      ];
      await tester.pumpWidget(MyApp(storage: storage, settings: settings));
      await settleIO(tester);
      Future<void> pose(String pose) async {
        messenger.handlePlatformMessage(
          fold.name,
          const StandardMethodCodec().encodeSuccessEnvelope({
            'version': 1,
            'availability': 'available',
            'pose': pose,
          }),
          (_) {},
        );
        await tester.pumpAndSettle();
      }

      await pose('fullyOpen');
      expect(
        DuoHost.of(tester.element(find.byType(Scaffold).first))!.fullyOpen,
        isTrue,
      );
      final openWidth = tester.getSize(find.byType(Dismissible)).width;
      await pose('halfOpen');
      expect(
        tester.getSize(find.byType(Dismissible)).width,
        greaterThan(openWidth),
      );
      await tester.tap(find.byTooltip('Settings'));
      await settleIO(tester);
      expect(find.byType(BackButton), findsNothing);
      await tester.ensureVisible(find.byKey(const Key('app-version')));
      expect(find.text('Version (build): 2.3.4 (99)'), findsOneWidget);
      messenger.handlePlatformMessage(
        rail.name,
        const StandardMethodCodec().encodeMethodCall(
          const MethodCall('onItemTap', {'id': 'edusnap-back'}),
        ),
        (_) {},
      );
      await tester.pumpAndSettle();
      expect(find.text('Fold story'), findsOneWidget);
      available = false;
      await tester.tap(find.byTooltip('Settings'));
      await settleIO(tester);
      expect(find.byType(BackButton), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
      debugDefaultTargetPlatformOverride = null;
    },
  );
}
