import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../Models/JournalEntry.dart';
import '../../Utils/PhotoPicker.dart';

class AddPageController extends ChangeNotifier {
  final JournalEntry? original;
  final TextEditingController title;
  final TextEditingController note;
  final PhotoPicker photos;
  String? photoPath;
  bool busy = false;
  AddPageController({this.original, PhotoPicker? photos})
    : title = TextEditingController(text: original?.title ?? ''),
      note = TextEditingController(text: original?.note ?? ''),
      photoPath = original?.photoPath,
      photos = photos ?? PhotoPicker();
  bool get isEditing => original != null;
  bool get hasTitle => title.text.trim().isNotEmpty;
  JournalEntry save() => JournalEntry(
    title: title.text.trim(),
    note: note.text.trim(),
    createdAt: original?.createdAt ?? DateTime.now(),
    photoPath: photoPath,
  );
  Future<void> pick(ImageSource source) async {
    final path = await photos.pick(source);
    if (path != null) photoPath = path;
  }

  void removePhoto() {
    photoPath = null;
    notifyListeners();
  }

  @override
  void dispose() {
    title.dispose();
    note.dispose();
    super.dispose();
  }
}
