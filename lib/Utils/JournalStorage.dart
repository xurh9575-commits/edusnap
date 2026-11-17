import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../Models/JournalEntry.dart';

/// Owns only the app's journal directory; preferences live separately.
class JournalStorage {
  final Directory root;
  JournalStorage(this.root);
  File get journal => File('${root.path}/journal.json');
  Directory get photos => Directory('${root.path}/photos');

  Future<List<JournalEntry>> load() async {
    if (!await journal.exists()) return [];
    final data = jsonDecode(await journal.readAsString()) as List<dynamic>;
    return data
        .map((value) => JournalEntry.fromJson(value as Map<String, dynamic>))
        .toList();
  }

  Future<void> save(List<JournalEntry> entries) async {
    await root.create(recursive: true);
    final temporary = File('${journal.path}.tmp');
    await temporary.writeAsString(
      jsonEncode(entries.map((entry) => entry.toJson()).toList()),
      flush: true,
    );
    await temporary.rename(journal.path);
  }

  Future<String?> importPhoto(String? path) async {
    if (path == null) return null;
    if (p.equals(File(path).parent.absolute.path, photos.absolute.path)) {
      if (!await File(path).exists()) {
        throw FileSystemException('Photo is missing', path);
      }
      return path;
    }
    await photos.create(recursive: true);
    // Keep the actual extension; Flutter decodes the file's bytes.
    final suffix = path.split('.').last.toLowerCase();
    final extension = RegExp(r'^[a-z0-9]{1,8}$').hasMatch(suffix)
        ? suffix
        : 'jpg';
    final target =
        '${photos.path}/${DateTime.now().microsecondsSinceEpoch}.$extension';
    await File(path).copy(target);
    return target;
  }

  Future<void> removeUnusedPhotos(List<JournalEntry> entries) async {
    if (!await photos.exists()) return;
    final kept = entries.map((entry) => entry.photoPath).toSet();
    await for (final file in photos.list(followLinks: false)) {
      if (file is File &&
          !kept.any((path) => path != null && p.equals(path, file.path))) {
        await file.delete();
      }
    }
  }

  Future<int> sizeBytes() async {
    if (!await root.exists()) return 0;
    var size = 0;
    await for (final file in root.list(recursive: true, followLinks: false)) {
      if (file is File) size += await file.length();
    }
    return size;
  }

  Future<void> clear() async {
    // Remove the index first so interrupted clearing cannot revive old entries.
    if (await journal.exists()) await journal.delete();
    if (await root.exists()) await root.delete(recursive: true);
  }
}
