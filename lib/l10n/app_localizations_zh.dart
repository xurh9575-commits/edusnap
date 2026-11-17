// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'EduSnap';

  @override
  String get settings => '設定';

  @override
  String get addEntry => '新增日記';

  @override
  String get editEntry => '編輯日記';

  @override
  String get entry => '日記詳情';

  @override
  String get edit => '編輯';

  @override
  String get journal => '我的日記';

  @override
  String get emptyJournal => '由這裡開始記錄你的故事。';

  @override
  String get newStory => '今天發生了甚麼？';

  @override
  String get revisitStory => '重溫你的故事';

  @override
  String get titleLabel => '標題（必填）';

  @override
  String get noteLabel => '筆記（選填）';

  @override
  String get save => '儲存';

  @override
  String get cancel => '取消';

  @override
  String get ok => '確定';

  @override
  String get delete => '刪除';

  @override
  String get deleteTitle => '刪除這篇日記？';

  @override
  String get titleRequired => '請填寫標題';

  @override
  String get titleRequiredBody => '請先輸入標題，再儲存日記。';

  @override
  String get noNote => '未填寫筆記';

  @override
  String get noPhoto => '尚未加入照片';

  @override
  String get addPhoto => '加入照片';

  @override
  String get camera => '拍照';

  @override
  String get gallery => '從相簿選取';

  @override
  String get removePhoto => '移除照片';

  @override
  String get photoPermission => '需要照片存取權限';

  @override
  String get photoPermissionBody => '請在應用程式設定允許存取，以使用此照片來源。你也可以繼續建立沒有照片的日記。';

  @override
  String get openSettings => '開啟應用程式設定';

  @override
  String get photoError => '無法開啟照片，請重試。';

  @override
  String get storageError => '無法儲存或讀取日記，請重試。原有檔案已保留。';

  @override
  String get retry => '重試';

  @override
  String get language => '語言';

  @override
  String get english => 'English';

  @override
  String get chinese => '繁體中文';

  @override
  String get storage => '日記儲存空間';

  @override
  String get storageDescription => '包含已儲存的日記資料及照片；語言偏好另外保存。';

  @override
  String get clear => '清除全部日記';

  @override
  String get clearTitle => '清除日記儲存空間？';

  @override
  String get clearBody => '將刪除全部日記及其照片。';

  @override
  String get clearFinalTitle => '再次確認永久刪除';

  @override
  String get clearFinalBody => '此操作無法復原。確定立即刪除全部日記及照片？';

  @override
  String get clearDone => '已清除全部日記及照片。';

  @override
  String get offline => '儲存在此裝置';

  @override
  String get photoUnavailable => '照片無法顯示';

  @override
  String createdOn(String date) {
    return '$date 建立';
  }

  @override
  String storageUsed(String size) {
    return '已使用 $size KB';
  }

  @override
  String entryCount(String count) {
    return '$count 篇日記・左滑刪除';
  }

  @override
  String deleteBody(String title) {
    return '確定刪除「$title」？';
  }
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get appTitle => 'EduSnap';

  @override
  String get settings => '設定';

  @override
  String get addEntry => '新增日記';

  @override
  String get editEntry => '編輯日記';

  @override
  String get entry => '日記詳情';

  @override
  String get edit => '編輯';

  @override
  String get journal => '我的日記';

  @override
  String get emptyJournal => '由這裡開始記錄你的故事。';

  @override
  String get newStory => '今天發生了甚麼？';

  @override
  String get revisitStory => '重溫你的故事';

  @override
  String get titleLabel => '標題（必填）';

  @override
  String get noteLabel => '筆記（選填）';

  @override
  String get save => '儲存';

  @override
  String get cancel => '取消';

  @override
  String get ok => '確定';

  @override
  String get delete => '刪除';

  @override
  String get deleteTitle => '刪除這篇日記？';

  @override
  String get titleRequired => '請填寫標題';

  @override
  String get titleRequiredBody => '請先輸入標題，再儲存日記。';

  @override
  String get noNote => '未填寫筆記';

  @override
  String get noPhoto => '尚未加入照片';

  @override
  String get addPhoto => '加入照片';

  @override
  String get camera => '拍照';

  @override
  String get gallery => '從相簿選取';

  @override
  String get removePhoto => '移除照片';

  @override
  String get photoPermission => '需要照片存取權限';

  @override
  String get photoPermissionBody => '請在應用程式設定允許存取，以使用此照片來源。你也可以繼續建立沒有照片的日記。';

  @override
  String get openSettings => '開啟應用程式設定';

  @override
  String get photoError => '無法開啟照片，請重試。';

  @override
  String get storageError => '無法儲存或讀取日記，請重試。原有檔案已保留。';

  @override
  String get retry => '重試';

  @override
  String get language => '語言';

  @override
  String get english => 'English';

  @override
  String get chinese => '繁體中文';

  @override
  String get storage => '日記儲存空間';

  @override
  String get storageDescription => '包含已儲存的日記資料及照片；語言偏好另外保存。';

  @override
  String get clear => '清除全部日記';

  @override
  String get clearTitle => '清除日記儲存空間？';

  @override
  String get clearBody => '將刪除全部日記及其照片。';

  @override
  String get clearFinalTitle => '再次確認永久刪除';

  @override
  String get clearFinalBody => '此操作無法復原。確定立即刪除全部日記及照片？';

  @override
  String get clearDone => '已清除全部日記及照片。';

  @override
  String get offline => '儲存在此裝置';

  @override
  String get photoUnavailable => '照片無法顯示';

  @override
  String createdOn(String date) {
    return '$date 建立';
  }

  @override
  String storageUsed(String size) {
    return '已使用 $size KB';
  }

  @override
  String entryCount(String count) {
    return '$count 篇日記・左滑刪除';
  }

  @override
  String deleteBody(String title) {
    return '確定刪除「$title」？';
  }
}
