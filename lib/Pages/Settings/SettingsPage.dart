import '../../Component/DuoHost/DuoHost.dart';

import 'package:flutter/material.dart';

import '../../Utils/AppSettings.dart';
import '../../l10n/app_localizations.dart';
import '../HomePage/HomePageController.dart';
import 'SettingsPageController.dart';

class SettingsPage extends StatefulWidget {
  final HomePageController journal;
  final AppSettings settings;
  const SettingsPage({
    super.key,
    required this.journal,
    required this.settings,
  });
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final SettingsPageController controller;
  String? used;
  bool busy = false;
  bool failed = false;
  String? version;
  bool versionFailed = false;
  @override
  void initState() {
    super.initState();
    controller = SettingsPageController(widget.journal, widget.settings);
    refresh();
    loadVersion();
  }

  Future<void> loadVersion() async {
    try {
      final info = await controller.appInfo();
      if (mounted) {
        setState(() {
          version = '${info.version} (${info.buildNumber})';
          versionFailed = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => versionFailed = true);
    }
  }

  Future<void> refresh() async {
    try {
      final size = await controller.usedKB();
      if (mounted) {
        setState(() {
          used = size;
          failed = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => failed = true);
    }
  }

  Future<bool> confirm({required bool finalStep}) async {
    final s = AppLocalizations.of(context)!;
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(finalStep ? s.clearFinalTitle : s.clearTitle),
            content: Text(finalStep ? s.clearFinalBody : s.clearBody),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(s.cancel),
              ),
              FilledButton(
                key: Key(
                  finalStep ? 'confirm-clear-final' : 'confirm-clear-first',
                ),
                onPressed: () => Navigator.pop(context, true),
                child: Text(s.clear),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> clear() async {
    if (!await confirm(finalStep: false) || !mounted) return;
    if (!await confirm(finalStep: true) || !mounted) return;
    await action(() async {
      await controller.clear();
      await refresh();
    });
  }

  Future<void> action(Future<void> Function() operation) async {
    setState(() => busy = true);
    try {
      await operation();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.storageError)),
        );
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    return PopScope(
      canPop: !busy,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading:
              !(DuoHost.of(context)?.railActive ?? false),
          title: Text(s.settings),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(s.language, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                key: ValueKey(widget.settings.locale.languageCode),
                initialValue: widget.settings.locale.languageCode,
                decoration: InputDecoration(labelText: s.language),
                items: [
                  DropdownMenuItem(value: 'en', child: Text(s.english)),
                  DropdownMenuItem(value: 'zh', child: Text(s.chinese)),
                ],
                onChanged: busy
                    ? null
                    : (value) {
                        if (value != null) {
                          action(() => controller.setLanguage(value));
                        }
                      },
              ),
              const SizedBox(height: 32),
              Text(s.storage, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              if (failed)
                TextButton(onPressed: refresh, child: Text(s.retry))
              else if (used == null)
                const Center(child: CircularProgressIndicator())
              else
                Text(
                  s.storageUsed(used!),
                  key: const Key('storage-used'),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              const SizedBox(height: 12),
              Text(s.storageDescription),
              const SizedBox(height: 24),
              FilledButton.tonalIcon(
                key: const Key('clear-journals'),
                onPressed: busy || widget.journal.busy ? null : clear,
                icon: const Icon(Icons.delete_forever_outlined),
                label: Text(s.clear),
              ),
              if (busy) const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 32),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/icon.png',
                    width: 56,
                    height: 56,
                    semanticLabel: 'EduSnap',
                  ),
                ),
                title: Text(s.appTitle),
                subtitle: Text(
                  version == null
                      ? s.versionUnavailable
                      : '${s.versionLabel}: $version',
                  key: const Key('app-version'),
                ),
                trailing: versionFailed
                    ? IconButton(
                        tooltip: s.retry,
                        onPressed: loadVersion,
                        icon: const Icon(Icons.refresh),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
