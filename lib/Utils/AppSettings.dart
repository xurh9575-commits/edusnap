import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  final SharedPreferences preferences;
  AppSettings(this.preferences);
  Locale get locale => preferences.getString('language') == 'zh'
      ? const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')
      : const Locale('en');
  Future<void> setLanguage(String language) async {
    final saved = await preferences.setString('language', language);
    if (!saved) throw StateError('Language could not be saved');
    notifyListeners();
  }
}
