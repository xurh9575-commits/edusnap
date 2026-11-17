class JournalEntry {
  final String title;
  final String note;
  final DateTime createdAt;
  final String? photoPath;
  const JournalEntry({
    required this.title,
    required this.note,
    required this.createdAt,
    this.photoPath,
  });
  Map<String, dynamic> toJson() => {
    'title': title,
    'note': note,
    'createdAt': createdAt.toIso8601String(),
    'photoPath': photoPath,
  };
  factory JournalEntry.fromJson(Map<String, dynamic> json) => JournalEntry(
    title: json['title'] as String,
    note: json['note'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    photoPath: json['photoPath'] as String?,
  );
}
