import 'package:flutter/foundation.dart';

import '../../Models/JournalEntry.dart';

class DetailPageController extends ChangeNotifier {
  JournalEntry _entry;
  DetailPageController(this._entry);
  JournalEntry get entry => _entry;
  void update(JournalEntry entry) {
    _entry = entry;
    notifyListeners();
  }
}
