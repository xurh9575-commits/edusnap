# EduSnap：Session 2

已完成四個頁面、日記新增／詳情／左滑刪除，以及重用 AddPage 的編輯 Challenge。
出處：Itchi Flutter Session 2，第 13–37 頁。

## 執行

在這個資料夾開啟 Cursor，執行：

```powershell
flutter pub get
flutter emulators --launch Pixel_7_Pro
flutter devices
flutter run -d emulator-5554
```

裝置 ID 請以 `flutter devices` 的實際輸出為準。

## 操作與驗收

1. 首頁顯示三筆範例日記；左上開 Settings，右上加號開 Add。
2. 空白或只有空格的標題不能儲存，會顯示提示；筆記可以留空。
3. 儲存後，新日記放在列表最上方。
4. 點卡片查看詳情，再按 Edit。原有內容會填入同一個 AddPage。
5. 儲存編輯後，詳情與列表同步更新，建立時間及列表位置保留；可連續編輯。
6. 返回可取消新增或編輯，原有資料維持不變。
7. 左滑卡片顯示刪除背景，確認後刪除；取消則保留。
8. 清空列表後可從空白狀態按 Add entry 新增。

出處：Session 2 第 19、21–29、34、36–37 頁；本專案實作及自動測試。

## MVC 結構

- `lib/Models/JournalEntry.dart`：只有 title、note、createdAt 資料。
- `lib/Pages/HomePage/`：列表 View 及管理日記的 Controller。
- `lib/Pages/Add/`：新增與編輯共用表單及 Controller。
- `lib/Pages/Detail/`：詳情 View 及 Controller。
- `lib/Pages/Settings/`：設定頁 View 及 Controller。
- `lib/Component/JournalCard/`：卡片 View 及 Controller。
- `lib/Utils/JournalDate.dart`：共用日期格式。
- `lib/main.dart`：App 入口、主題與首頁。

檔名依照課件指定的 PascalCase，analysis_options.yaml 因此關閉 file_names 風格規則，其餘 Flutter lint 繼續啟用。
出處：Session 1 第 18–19 頁；Session 2 第 14、17、19 頁。

## 驗證

2026-11-17 驗證結果：

- `flutter analyze`：No issues found。
- `flutter test`：3 個測試全部通過，涵蓋導航、驗證、新增、連續編輯、取消、刪除確認及空列表。
- `flutter build apk --debug --target-platform android-x64`：成功。
- APK 已安裝並啟動於 Pixel_7_Pro Android 模擬器，首頁三筆卡片顯示正常。

出處：本次 Flutter、ADB 命令輸出及模擬器截圖。

## 目前範圍

資料只保存在記憶體；關閉 App 後重新啟動，恢復三筆範例。相片、本機持久儲存及語言切換是 Session 3 的內容。
出處：Session 2 第 19、25 頁；Session 3 第 4 頁。

GitHub：https://github.com/xurh9575-commits/edusnap
個人開發分支：`dev/karon`。
出處：本專案遠端設定；Session 1 第 21–22 頁。
