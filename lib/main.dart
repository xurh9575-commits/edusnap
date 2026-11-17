import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Pages/HomePage/HomePage.dart';
import 'Pages/HomePage/HomePageController.dart';
import 'Utils/JournalStorage.dart';
import 'Utils/AppSettings.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();
  final preferences = await SharedPreferences.getInstance();
  runApp(
    MyApp(
      storage: JournalStorage(Directory('${directory.path}/edusnap_journal')),
      settings: AppSettings(preferences),
    ),
  );
}

class MyApp extends StatefulWidget {
  final JournalStorage storage;
  final AppSettings settings;
  const MyApp({super.key, required this.storage, required this.settings});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final HomePageController journal;
  @override
  void initState() {
    super.initState();
    journal = HomePageController(widget.storage);
  }

  @override
  void dispose() {
    journal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.settings,
    builder: (context, _) => MaterialApp(
      title: 'EduSnap',
      debugShowCheckedModeBanner: false,
      locale: widget.settings.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [
        Locale('en'),
        Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF246B61)),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: HomePage(controller: journal, settings: widget.settings),
    ),
  );
}
