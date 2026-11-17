# 課堂專案規則

出處：Itchi Flutter Session 1，第 18–19 頁。

- `lib/Models/` 只放資料類別，不放 Widget 或網路請求。
- `lib/Component/名稱/` 放可重用元件，元件的 View 與 Controller 放在同一資料夾。
- `lib/Pages/名稱/` 放頁面，頁面與其 PageController 放在同一資料夾。
- `lib/Utils/` 放共用邏輯，不放特定頁面的 UI。
- 新增功能時遵守上述 MVC 分工。Session 2 已將日記頁面拆分為 View 與 Controller；`lib/main.dart` 只設定 App 入口及主題。
