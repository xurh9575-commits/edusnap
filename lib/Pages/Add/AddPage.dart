import '../../Component/DuoHost/DuoHost.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Models/JournalEntry.dart';
import '../../Utils/PhotoPicker.dart';
import '../../Component/JournalPhoto/JournalPhoto.dart';
import '../../l10n/app_localizations.dart';
import 'AddPageController.dart';

class AddPage extends StatefulWidget {
  final JournalEntry? entry;
  final Future<JournalEntry> Function(JournalEntry) onSave;
  final PhotoPicker? photoPicker;
  const AddPage({
    super.key,
    this.entry,
    required this.onSave,
    this.photoPicker,
  });
  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  late final AddPageController controller;
  @override
  void initState() {
    super.initState();
    controller = AddPageController(
      original: widget.entry,
      photos: widget.photoPicker,
    );
    recoverPhoto();
  }

  Future<void> recoverPhoto() async {
    controller.busy = true;
    try {
      final path = await controller.photos.recover();
      if (mounted && path != null) controller.photoPath = path;
    } catch (_) {
      if (mounted) message(AppLocalizations.of(context)!.photoError);
    } finally {
      if (mounted) setState(() => controller.busy = false);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void message(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  Future<void> pick(ImageSource source) async {
    setState(() => controller.busy = true);
    try {
      await controller.pick(source);
    } on PhotoPermissionDenied {
      if (!mounted) return;
      setState(() => controller.busy = false);
      final s = AppLocalizations.of(context)!;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(s.photoPermission),
          content: Text(s.photoPermissionBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(s.cancel),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await openAppSettings();
              },
              child: Text(s.openSettings),
            ),
          ],
        ),
      );
    } catch (_) {
      if (mounted) message(AppLocalizations.of(context)!.photoError);
    } finally {
      if (mounted) setState(() => controller.busy = false);
    }
  }

  Future<void> save() async {
    final s = AppLocalizations.of(context)!;
    if (!controller.hasTitle) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(s.titleRequired),
          content: Text(s.titleRequiredBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(s.ok),
            ),
          ],
        ),
      );
      return;
    }
    setState(() => controller.busy = true);
    try {
      final entry = await widget.onSave(controller.save());
      if (!mounted) return;
      setState(() => controller.busy = false);
      Navigator.pop(context, entry);
    } catch (_) {
      if (mounted) message(AppLocalizations.of(context)!.storageError);
    } finally {
      if (mounted && controller.busy) setState(() => controller.busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    return PopScope(
      canPop: !controller.busy,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading:
              !(DuoHost.of(context)?.railActive ?? false),
          title: Text(controller.isEditing ? s.editEntry : s.addEntry),
        ),
        body: SafeArea(
          child: AbsorbPointer(
            absorbing: controller.busy,
            child: Form(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text(
                    controller.isEditing ? s.revisitStory : s.newStory,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    key: const Key('entry-title'),
                    controller: controller.title,
                    decoration: InputDecoration(labelText: s.titleLabel),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    key: const Key('entry-note'),
                    controller: controller.note,
                    decoration: InputDecoration(
                      labelText: s.noteLabel,
                      alignLabelWithHint: true,
                    ),
                    minLines: 3,
                    maxLines: 10,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 20),
                  JournalPhoto(path: controller.photoPath),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    children: [
                      TextButton.icon(
                        key: const Key('pick-camera'),
                        onPressed: () => pick(ImageSource.camera),
                        icon: const Icon(Icons.camera_alt_outlined),
                        label: Text(s.camera),
                      ),
                      TextButton.icon(
                        key: const Key('pick-gallery'),
                        onPressed: () => pick(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library_outlined),
                        label: Text(s.gallery),
                      ),
                      if (controller.photoPath != null)
                        TextButton(
                          onPressed: () => setState(controller.removePhoto),
                          child: Text(s.removePhoto),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (controller.busy)
                    const Center(child: CircularProgressIndicator())
                  else
                    FilledButton.icon(
                      key: const Key('save-entry'),
                      onPressed: save,
                      icon: const Icon(Icons.check),
                      label: Text(s.save),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
