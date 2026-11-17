import 'package:package_info_plus/package_info_plus.dart';

import '../../Utils/AppSettings.dart';
import '../HomePage/HomePageController.dart';

class SettingsPageController {
  final HomePageController journal;
  final AppSettings settings;
  SettingsPageController(this.journal, this.settings);
  Future<PackageInfo> appInfo() => PackageInfo.fromPlatform();
  Future<String> usedKB() async {
    final bytes = await journal.storage.sizeBytes();
    return bytes == 0 ? '0' : (bytes / 1024).toStringAsFixed(2);
  }

  Future<void> clear() => journal.clear();
  Future<void> setLanguage(String value) => settings.setLanguage(value);
}
