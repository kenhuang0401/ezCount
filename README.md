<div align="center">

# Expense Count App

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![SQLite](https://img.shields.io/badge/sqlite-%2307405e.svg?style=for-the-badge&logo=sqlite&logoColor=white)
![Material_Design](https://img.shields.io/badge/Material--Design-757575?style=for-the-badge&logo=material-design&logoColor=white)

### 極簡的個人記帳應用程式
偏向學生使用的個人記帳系統，能精確計算每週開銷及剩餘金額

---

</div>

<!-- * **🗓️ 計算**：根據每日支出金額自動著色，一眼看出你的消費高峰期。 -->

## 核心特色

* **快速記帳**：極簡的 UI 架構，確保在快速完成一筆收支記錄。
* **週度統計**：自動匯總週一至週日的總支出，顯示本週剩餘預算。
* **支出色階**：針對支出數值自動調整日歷背景色（紅底深淺對應支出高低）。
* **資料私隱**：100% 本地存儲，不上傳任何財務資料至雲端。

---

## 專案組成

```
lib/
├── components/             # UI 複用組件
│   ├── income/             # 收入相關組件
│   │   ├── income_page.dart
│   │   └── my_income_list.dart
│   ├── list/               # 列表呈現組件
│   │   ├── my_list.dart
│   │   ├── my_list_group.dart
│   │   └── my_week_list.dart
│   ├── tag/                # 標籤管理組件
│   │   ├── tag_dialog.dart
│   │   ├── tag_list.dart
│   │   └── tags_page.dart
│   ├── bottom_sheet.dart   # 底部彈窗邏輯
│   └── type_page.dart      # 預輸入設定頁面
├── database/              
│   └── db_helper.dart      # SQLite 操作封裝
├── models/                 # 資料模型定義
│   └── transaction.dart    # 交易記錄模型 (Item/Day)
├── pages/                  # 主要功能頁面 (Scaffold 級別)
│   ├── calendar_page.dart  # 日曆頁面
│   ├── home_page.dart      # 應用程式主頁
│   ├── settings_page.dart  # 設定頁面
│   └── tmp.dart            # 臨時測試檔案
├── providers/              # 狀態管理 (ChangeNotifier)
│   ├── color.dart          # 顏色與主題管理
│   ├── expense.dart        # 核心收支資料邏輯
│   ├── page.dart           # 頁面索引切換管理
│   └── settings.dart       # App 全域設定
├── utils/                  # 工具類與擴充
│   └── extension.dart      # BuildContext 擴充 (Provider 簡化)
└── main.dart               # 程式執行起點
```

---

<!--
## 🛠️ 開發環境要求

受限於各平台的不可抗力因素，開發建議環境如下：

* **Flutter SDK**: `^3.9.2` 或更高版本
* **Dart SDK**: `^3.x`
* **適配平台**: Android (API 21+) / iOS (12.0+)

---

## 聯絡支援

如果有任何問題、建議或 Bug 回報，歡迎透過以下方式聯繫：

[GitHub Issues](https://github.com/你的帳號/exp02/issues) · [Personal Discord] -->
