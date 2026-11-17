import '../../Models/JournalEntry.dart';

class JournalCardController {
  final JournalEntry entry;
  const JournalCardController(this.entry);
  bool get hasNote => entry.note.isNotEmpty;
}
