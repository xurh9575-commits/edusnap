import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'EduSnap'**
  String get appTitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @addEntry.
  ///
  /// In en, this message translates to:
  /// **'Add entry'**
  String get addEntry;

  /// No description provided for @editEntry.
  ///
  /// In en, this message translates to:
  /// **'Edit entry'**
  String get editEntry;

  /// No description provided for @entry.
  ///
  /// In en, this message translates to:
  /// **'Entry'**
  String get entry;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @journal.
  ///
  /// In en, this message translates to:
  /// **'Your journal'**
  String get journal;

  /// No description provided for @emptyJournal.
  ///
  /// In en, this message translates to:
  /// **'Your next story starts here.'**
  String get emptyJournal;

  /// No description provided for @newStory.
  ///
  /// In en, this message translates to:
  /// **'What happened today?'**
  String get newStory;

  /// No description provided for @revisitStory.
  ///
  /// In en, this message translates to:
  /// **'Revisit your story'**
  String get revisitStory;

  /// No description provided for @titleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title (required)'**
  String get titleLabel;

  /// No description provided for @noteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get noteLabel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete entry?'**
  String get deleteTitle;

  /// No description provided for @titleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title required'**
  String get titleRequired;

  /// No description provided for @titleRequiredBody.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title before saving your entry.'**
  String get titleRequiredBody;

  /// No description provided for @noNote.
  ///
  /// In en, this message translates to:
  /// **'No note added'**
  String get noNote;

  /// No description provided for @noPhoto.
  ///
  /// In en, this message translates to:
  /// **'No photo'**
  String get noPhoto;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get addPhoto;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get gallery;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhoto;

  /// No description provided for @photoPermission.
  ///
  /// In en, this message translates to:
  /// **'Photo access needed'**
  String get photoPermission;

  /// No description provided for @photoPermissionBody.
  ///
  /// In en, this message translates to:
  /// **'Allow access in app settings to use this photo source. You can continue without a photo.'**
  String get photoPermissionBody;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open app settings'**
  String get openSettings;

  /// No description provided for @photoError.
  ///
  /// In en, this message translates to:
  /// **'Could not open this photo. Please try again.'**
  String get photoError;

  /// No description provided for @storageError.
  ///
  /// In en, this message translates to:
  /// **'Could not save or load your journal. Please retry. Your existing files have been kept.'**
  String get storageError;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @chinese.
  ///
  /// In en, this message translates to:
  /// **'Traditional Chinese'**
  String get chinese;

  /// No description provided for @storage.
  ///
  /// In en, this message translates to:
  /// **'Journal storage'**
  String get storage;

  /// No description provided for @storageDescription.
  ///
  /// In en, this message translates to:
  /// **'Includes saved journal data and photos. Language preference is kept separately.'**
  String get storageDescription;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear all journals'**
  String get clear;

  /// No description provided for @clearTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear journal storage?'**
  String get clearTitle;

  /// No description provided for @clearBody.
  ///
  /// In en, this message translates to:
  /// **'All journal entries and their photos will be deleted.'**
  String get clearBody;

  /// No description provided for @clearFinalTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm permanent deletion'**
  String get clearFinalTitle;

  /// No description provided for @clearFinalBody.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone. Delete all entries and photos now?'**
  String get clearFinalBody;

  /// No description provided for @clearDone.
  ///
  /// In en, this message translates to:
  /// **'Journal entries and photos cleared.'**
  String get clearDone;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Saved on this device'**
  String get offline;

  /// No description provided for @photoUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Photo unavailable'**
  String get photoUnavailable;

  /// No description provided for @createdOn.
  ///
  /// In en, this message translates to:
  /// **'Created on {date}'**
  String createdOn(String date);

  /// No description provided for @storageUsed.
  ///
  /// In en, this message translates to:
  /// **'{size} KB used'**
  String storageUsed(String size);

  /// No description provided for @entryCount.
  ///
  /// In en, this message translates to:
  /// **'{count} entries · Swipe left to delete'**
  String entryCount(String count);

  /// No description provided for @deleteBody.
  ///
  /// In en, this message translates to:
  /// **'Delete “{title}”?'**
  String deleteBody(String title);

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version (build)'**
  String get versionLabel;

  /// No description provided for @versionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Version unavailable'**
  String get versionUnavailable;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
