# EduSnap：Session 3

已完成 Session 2 的日記操作，以及 Session 3 的相片、本機儲存、英文／繁體中文與清除 Challenge。
出處：Itchi Flutter Session 2 第 13–37 頁；Session 3 第 4、12–34 頁。

## 執行

```powershell
flutter pub get
flutter gen-l10n
flutter emulators --launch Pixel_7_Pro
flutter devices
flutter run -d emulator-5554
```

裝置 ID 以 flutter devices 輸出為準。首次使用從空白日記開始；Session 2 的三筆記憶體範例不會自動當成使用者資料保存。
出處：本專案 main.dart、HomePageController.dart。

## 使用與驗收

1. 右上角新增日記。標題必填，筆記及照片選填；空白或只有空格的標題會提示。
2. 可拍照或從相簿選取，表單顯示預覽，也可移除照片。拒絕相機／iOS 相簿權限時顯示說明與開啟設定的入口，仍可建立沒有照片的日記。
3. 儲存時將照片複製到 App 文件資料夾；列表及詳情都顯示照片，沒有照片時顯示佔位內容。
4. 點卡片查看詳情，Edit 重用新增表單。儲存後同步更新列表及詳情；建立日期和列表位置保留。
5. 新增、編輯、刪除都先保存 JSON，再更新資料。關閉 App 後重開會載入已保存的日記與照片。
6. Settings 可切換英文／繁體中文。語言偏好另外保存，下次啟動仍保留。使用者自己輸入的日記內容不會被翻譯。
7. 日期使用 createdOn 的 date placeholder；儲存用量使用 storageUsed 的 size placeholder，中文顯示「已使用 X KB」，英文顯示「X KB used」。
8. Settings 顯示日記 JSON 及照片的實際檔案用量。清除需要兩次確認，取消任何一次都不清除。完成後清除日記及照片，顯示 0 KB，語言偏好保留。

出處：Session 3 第 15、17、20、22、24、26、28、30–34 頁；本專案實作。

## Android 與 iOS 權限

Android 使用 image_picker 的系統 Photo Picker，只授權選取的照片，不要求整個相簿的 READ_MEDIA_IMAGES／READ_EXTERNAL_STORAGE。相機按需透過 permission_handler 請求 CAMERA。這是依照目前 Android 選相器行為對課件權限示例作出的調整。

iOS 已加入 NSCameraUsageDescription、NSPhotoLibraryUsageDescription。Podfile 已啟用 PERMISSION_CAMERA 與 PERMISSION_PHOTOS；Swift Package Manager 路線由 permission_handler_apple 依 Info.plist 推導。Windows 無法執行 Xcode，因此未編譯或實機驗證 iOS。

permission_handler 使用 12.x，以配合目前 Android 編譯 SDK；13.x 的 Android 實作需要 SDK 37。Android Kotlin 增量快取已關閉，避免 C: 套件快取與 D: 專案之間的跨磁碟相對路徑錯誤。
出處：套件文件、本次 Android 原生選相器／權限對話框觀察、編譯輸出及平台設定。

## MVC 結構

- Models/JournalEntry.dart：title、note、createdAt、photoPath 及 JSON 轉換。
- Pages/HomePage/：載入、儲存、新增、編輯及刪除日記。
- Pages/Add/：新增／編輯表單及照片操作。
- Pages/Detail/：日記詳情與編輯入口。
- Pages/Settings/：語言、用量及雙重確認清除。
- Component/JournalCard/、Component/JournalPhoto/：可重用 View 與 Controller。
- Utils/JournalStorage.dart：JSON、照片匯入、清理及檔案大小。
- Utils/AppSettings.dart：語言偏好。
- Utils/PhotoPicker.dart：平台權限、選相及 Android lost-data 回收。
- l10n/：英文／繁體中文 ARB 與 Flutter 產生的本地化程式。

出處：Session 1 第 18–19 頁；Session 3 第 20、24、26 頁；本專案目錄。

## 驗證結果（2026-11-17）

- flutter analyze：No issues found。
- flutter test：7 個測試通過。實際檔案測試涵蓋照片複製、重開載入、移除舊照片、刪除、清空為 0、損壞 JSON 保留及失敗時不覆寫資料；UI 測試涵蓋連續編輯、驗證、刪除確認、繁體中文、雙重確認及拒絕權限對話框。
- flutter test integration_test/session3_test.dart -d emulator-5554：1 個 Android 整合測試通過，使用獨立測試資料夾，驗證真實檔案照片、編輯、重新建立 App 載入、語言偏好及雙重清除。
- flutter build apk --debug --target-platform android-x64：成功；一般 App 已安裝並啟動。
- Android 原生入口檢查：相簿能開啟系統 Photo Picker；相機能觸發權限請求；拒絕後顯示 App 說明與設定入口。已完成原生相簿選取、預覽、儲存，再強制關閉並重新啟動 App，確認日記及照片保留。模擬器留有一筆 Session3-verification 示範日記。未驗證真實手機拍照及 iOS 執行。

出處：本次 Flutter、Gradle、ADB 命令輸出與 UI 階層。

GitHub：https://github.com/xurh9575-commits/edusnap
開發分支：dev/karon。
出處：本專案 Git 遠端設定。

## Session 4：圖示、主題、版本與 Duo

- 原創書本＋相機 logo，代表學習與照片日記。依使用者要求採淺藍白配色：背景 #BFE4FA、白色 #FFFFFF、可讀深藍 #26628C。SVG 原稿在 assets/icon.svg，assets/icon.png 為不透明 RGB 1024×1024 PNG。
- flutter_launcher_icons 已產生 Android 一般／自適應圖示及 iOS AppIcon。修改原稿後須重新輸出 1024 PNG，再執行 dart run flutter_launcher_icons。
- Utils/AppTheme.dart 集中設定 Material 3 配色、AppBar、卡片及輸入框，按鈕沿用 ColorScheme。課件第 13 頁示範色盤已由 Challenge 自訂淺藍白色盤取代。
- pubspec.yaml 版本更新至 1.1.0+4；Settings 透過 package_info_plus 讀取安裝套件實際版本／build，英文／繁中均有標籤。讀取失敗提供重試。1.1.0 是 minor 功能版本，4 是建置編號；可修改 pubspec、重新編譯安裝後對照顯示。
- 課件指定的 Git Duo 插件固定至 821121bfc3ebe540f344880904cf41ef355b5e66。Component/DuoHost 負責共用 View／Controller。iOS 監聽原生 fold stream、原生 rail 按鍵，使用 Navigator.maybePop 保留儲存中的 PopScope 防護；只有原生回報 available 時隱藏 Flutter 返回鍵。自訂按鍵 id 避免插件同時回傳 onItemTap 和 legacy onBack 導致重複返回。離開時取消訂閱並清空 rail。
- fullyOpen 且可用寬度至少 720 時，首頁日記以兩欄使用展開畫面；半開或較窄畫面回復單欄。不支援平台保留普通 Flutter 返回及單欄。

出處：Session 4 第 6–9、13、16–20、25–28、31 頁；使用者配色要求；本專案 assets、AppTheme、Settings、DuoHost。

### 驗證與限制

- flutter analyze：No issues found；flutter test：8 個測試通過。新增 mocked channel 測試涵蓋 fullyOpen／halfOpen 欄寬切換、原生返回、unsupported fallback，以及從套件 metadata 讀到不同於 pubspec 的 2.3.4 (99)，證明 UI 沒有硬編碼版本。
- flutter test integration_test/session3_test.dart -d emulator-5554：1 個 Android 整合測試通過，實際讀到 Version (build): 1.1.0 (4)，並驗證照片、編輯、重開、語言及雙重確認清除。測試使用獨立暫存目錄。
- flutter build apk --debug --target-platform android-x64：成功。圖示來源已檢查為 1024×1024 RGB。
- Windows 無法執行 pod install、Xcode 編譯或 iPhone Duo 模擬器；iOS／Duo 原生驗收尚未完成。插件 README 聲稱需要 Xcode／iOS 27.1+；此為上游要求，未在本機驗證 SDK 或裝置可用性。上游 Swift 實際含 UINavigationController 包裝，與 README 的不包裝描述不同，因此不能僅依文件保證 Metal 顯示正常。請在有相容 SDK 的 Mac 執行 flutter pub get、cd ios、pod install，再於 Duo 目標檢查側欄、單次返回、展開／收合及照片顯示。
- package_info_plus 9.x 建置有未來 Flutter KGP 相容性提示，目前建置成功。
- 課件第 33 頁最終提交表單：https://forms.gle/B33SMbt1SdqNH45eA 。未代填或提交。

出處：本次 Flutter／Android 測試與建置輸出；插件固定版本 README、Dart 及 Swift 原始碼；Session 4 第 33 頁。

Android 一般 App 已重新安裝並啟動；ADB 顯示 versionName=1.1.0、versionCode=4。已目視檢查桌面圓形啟動圖示及 App 淺藍白首頁，截圖位於工作資料夾 edusnap-session4.png、edusnap-session4-icon-check.png。模擬器整合測試的 Flutter 安裝流程會重建測試 App，現時一般 App 從空白日記開始；先前測試示範資料不屬於提交內容。
出處：本次 ADB 套件資訊及實際截圖。
