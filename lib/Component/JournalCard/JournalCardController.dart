import '../../Models/JournalEntry.dart';
import '../../Utils/JournalDate.dart';

class JournalCardController {
  final JournalEntry entry;
  const JournalCardController(this.entry);
  String get date => journalDate(entry.createdAt);
  String get preview => entry.note.isEmpty ? 'No note added' : entry.note;
}
