class JournalPhotoController {
  final String? path;
  const JournalPhotoController(this.path);
  bool get hasPhoto => path != null && path!.isNotEmpty;
}
