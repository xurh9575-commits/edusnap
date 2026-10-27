# EduSnap：第一堂練習

目前保留 Flutter 官方的計數器範例，用來確認專案可以編譯、執行及回應按鈕操作。課程的離線相片日記功能會在後續課堂加入。

出處：Itchi Flutter Session 1，第 3–5、10 頁；本專案由 `flutter create` 產生。

## 在 Cursor 開啟

選擇 File → Open Folder，開啟這份 README 所在的 `edusnap` 資料夾。在 Cursor 的終端執行：

```powershell
flutter doctor
flutter emulators
flutter emulators --launch Pixel_7_Pro
flutter devices
flutter run -d emulator-5554
```

如果模擬器使用其他裝置 ID，請將最後一行的 `emulator-5554` 換成 `flutter devices` 顯示的 ID。執行期間按 `r` 可熱重載，按 `q` 可結束。

出處：課件第 8–10 頁；本機 `flutter help`、`flutter emulators`、`flutter devices`。

## 課堂資料夾

```text
lib/
  main.dart
  Models/
  Component/
  Pages/
  Utils/
```

- `main.dart`：應用程式入口，目前仍使用官方範例。
- `Models/`：資料類別，不放 Widget 或網路請求。
- `Component/名稱/`：可重用元件，每個元件的 View 與 Controller 放在同一資料夾。
- `Pages/名稱/`：每個頁面及其 PageController 放在同一資料夾。
- `Utils/`：共用的儲存、格式轉換等工具。

四個資料夾中的 `.gitkeep` 是空白佔位檔，方便日後將空資料夾加入 Git。目前尚未將計數器範例拆成 MVC。

出處：課件第 11、18–19 頁；本專案目前的目錄與程式碼。

## 檢查專案

```powershell
flutter analyze
flutter test
```

出處：本機 Flutter 命令列工具與官方範例附帶的測試。

## GitHub

- 儲存庫：`https://github.com/xurh9575-commits/edusnap.git`
- 個人開發分支：`dev/karon`
- 課堂開發及推送使用個人分支。

出處：課件第 21–22 頁；使用者提供的儲存庫網址及確認的分支名稱。

## 第一堂驗證結果

- `flutter analyze`：沒有問題。
- `flutter test`：官方計數器測試通過。
- `flutter build apk --debug --target-platform android-x64`：編譯成功。
- App 已在 `Pixel_7_Pro` 模擬器啟動，按下「＋」後計數從 0 變成 1。

出處：2026 年 10 月 27 日本機 Flutter 命令輸出與 Android 畫面測試。
