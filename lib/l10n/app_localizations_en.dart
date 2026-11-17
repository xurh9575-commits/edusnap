// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'EduSnap';

  @override
  String get settings => 'Settings';

  @override
  String get addEntry => 'Add entry';

  @override
  String get editEntry => 'Edit entry';

  @override
  String get entry => 'Entry';

  @override
  String get edit => 'Edit';

  @override
  String get journal => 'Your journal';

  @override
  String get emptyJournal => 'Your next story starts here.';

  @override
  String get newStory => 'What happened today?';

  @override
  String get revisitStory => 'Revisit your story';

  @override
  String get titleLabel => 'Title (required)';

  @override
  String get noteLabel => 'Note (optional)';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get delete => 'Delete';

  @override
  String get deleteTitle => 'Delete entry?';

  @override
  String get titleRequired => 'Title required';

  @override
  String get titleRequiredBody =>
      'Please enter a title before saving your entry.';

  @override
  String get noNote => 'No note added';

  @override
  String get noPhoto => 'No photo';

  @override
  String get addPhoto => 'Add photo';

  @override
  String get camera => 'Take a photo';

  @override
  String get gallery => 'Choose from gallery';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String get photoPermission => 'Photo access needed';

  @override
  String get photoPermissionBody =>
      'Allow access in app settings to use this photo source. You can continue without a photo.';

  @override
  String get openSettings => 'Open app settings';

  @override
  String get photoError => 'Could not open this photo. Please try again.';

  @override
  String get storageError =>
      'Could not save or load your journal. Please retry. Your existing files have been kept.';

  @override
  String get retry => 'Retry';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get chinese => 'Traditional Chinese';

  @override
  String get storage => 'Journal storage';

  @override
  String get storageDescription =>
      'Includes saved journal data and photos. Language preference is kept separately.';

  @override
  String get clear => 'Clear all journals';

  @override
  String get clearTitle => 'Clear journal storage?';

  @override
  String get clearBody =>
      'All journal entries and their photos will be deleted.';

  @override
  String get clearFinalTitle => 'Confirm permanent deletion';

  @override
  String get clearFinalBody =>
      'This cannot be undone. Delete all entries and photos now?';

  @override
  String get clearDone => 'Journal entries and photos cleared.';

  @override
  String get offline => 'Saved on this device';

  @override
  String get photoUnavailable => 'Photo unavailable';

  @override
  String createdOn(String date) {
    return 'Created on $date';
  }

  @override
  String storageUsed(String size) {
    return '$size KB used';
  }

  @override
  String entryCount(String count) {
    return '$count entries · Swipe left to delete';
  }

  @override
  String deleteBody(String title) {
    return 'Delete “$title”?';
  }
}
