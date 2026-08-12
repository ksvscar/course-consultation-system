# 課程諮詢數位化系統 | Course Consultation Digital System

> 🎓 高雄高工汽車科課程諮詢系統（114 學年度）
> 
> 一套完整的學生填寫、教師複核、檔案管理的數位化解決方案

## 📋 專案概述

**課程諮詢系統**是為高中課程諮詢設計的數位化平台，讓學生透過網頁表單填寫課程諮詢紀錄，教師在後端即時檢查、批准簽名，並自動生成 PDF 與上傳到 Google Drive。

### 核心功能
- ✅ **學生填寫表單** — 6份紀錄表（各學期），JSON 資料驅動
- ✅ **簽名畫布** — HTML5 Canvas，淡字底稿 + 手寫簽名
- ✅ **教師後端** — 狀態追蹤、簽名複核、PDF 生成
- ✅ **自動判定** — 規則引擎判定是否需要個別諮詢
- ✅ **Google Drive 同步** — 自動上傳正式版 PDF
- ⏳ **AI 分析報告**（未來）— 根據高三回答生成生涯建議

---

## 🚀 快速開始

### 前置需求
- **NAS**：ASUSTOR AS7004T (或相容機型)
- **Docker**：Portainer CE 2.39.4 LTS
- **Node.js**：14.x 以上（後端 API）
- **SQLite3**：資料庫
- **Python 3**：資料匯入（可選）

### 部署架構

```
學生填寫（GitHub Pages）
         ↓
    ASUSTOR DDNS
         ↓
 NAS Docker (Node.js)
         ↓
SQLite + PDF 生成 + Google Drive
```

### 立即開始（3 步）

#### 1️⃣ 前端預覽（無需伺服器）
```bash
# 用瀏覽器打開預覽表單
open frontend/student-form-preview.html
```

#### 2️⃣ 導入學生名冊到 SQLite
```bash
# 建立資料庫（需要 SQLite 3）
sqlite3 course-consultation.db < data/students/students-init-114.sql

# 驗證導入成功
sqlite3 course-consultation.db "SELECT COUNT(*) FROM students;"
# 應顯示 210 (6班共210人)
```

#### 3️⃣ 啟動後端 API（需要 Node.js）
```bash
# 未來版本——目前還在開發
# cd backend && npm install && npm start
```

---

## 📁 專案結構

```
course-consultation-system/
├── frontend/                          # 前端表單（GitHub Pages 部署）
│   ├── form-renderer-dynamic.html    # 通用表單渲染引擎
│   └── student-form-preview.html     # 高一上預覽原型
│
├── backend/                           # 後端 API（Node.js + Express）
│   ├── app.js                        # 主應用
│   ├── routes/                       # API 路由
│   ├── models/                       # 資料模型
│   └── utils/                        # 工具函式
│
├── data/                              # 資料與配置
│   ├── templates/                    # 6份紀錄表 JSON 配置
│   │   ├── form-config-high1-up.json
│   │   ├── form-config-high1-down.json
│   │   ├── form-config-high2-up.json
│   │   ├── form-config-high2-down.json
│   │   ├── form-config-high3-up.json
│   │   └── form-config-high3-down.json
│   ├── courses/                      # 課程清單
│   │   └── course-data-114.json
│   └── students/                     # 學生名冊
│       ├── students-114.json         # JSON 格式
│       └── students-init-114.sql     # SQLite 初始化腳本
│
├── docs/                              # 文檔與指南
│   ├── README.md                     # 本檔
│   ├── 課程諮詢系統開發步驟規劃.md     # 13 Phase 完整規劃
│   ├── JSON_FORM_SYSTEM_GUIDE.md     # JSON 維護指南
│   ├── REQUIRED_FORMS_CHECKLIST.md   # 各類表單清單
│   └── PROGRESS_SUMMARY_2026-08-12.md # 完成進度總結
│
├── scripts/                           # 部署與維護腳本
│   ├── init-db.sh                    # 資料庫初始化
│   ├── backup-db.sh                  # 備份資料庫
│   └── deploy.sh                     # 部署腳本
│
├── .gitignore                         # Git 忽略檔案
├── LICENSE                            # MIT 許可證
└── package.json                       # 後端相依套件
```

---

## 📊 資料統計（114 學年度）

| 項目 | 數量 |
|---|---|
| **班級** | 6 班（汽車一甲/乙、二甲/乙、三甲/乙） |
| **學生** | 210 人 |
| **紀錄表** | 6 份（各學期） |
| **課程清單** | 高一上 8 科～高三下 8 科 |
| **JSON 配置檔** | 6 份 |
| **表單步驟** | 5 步（基本資料、評估、反思、簽名） |

---

## 🔧 主要技術棧

### 前端
- **HTML5 + Canvas** — 簽名畫布
- **Vanilla JavaScript** — 輕量級交互
- **JSON 資料驅動** — 題目配置彈性化

### 後端（開發中）
- **Node.js + Express** — REST API
- **SQLite** — 輕量級資料庫
- **Puppeteer** — PDF 生成
- **Google Drive API** — 文件同步

### 基礎設施
- **NAS Docker** — 應用容器化
- **ASUSTOR DDNS** — 對外連線（無需買域名）
- **GitHub Pages** — 前端靜態託管（免費）
- **Tailscale** — 教師端私人通道（免費版支援6人）

---

## 📝 使用指南

### 給學生
1. 用手機掃 QR Code 進入表單
2. 填寫班級（下拉選）+ 座號、姓名（手動輸入）
3. 依序回答各步驟問題
4. 在簽名畫布用手指或觸控筆簽名
5. 送出 → 等待老師檢核 → 看到「完成」按鈕即可離開

### 給教師
1. 用 Tailscale VPN 連進後端管理頁
2. 查看班級學生填寫狀態（紅○未填、綠●已完成）
3. 點選各生預覽 PDF 檢查簽名品質
4. 「重置」學生重簽，或「檢核完畢」批准全班
5. 系統自動生成正式版 PDF + 上傳 Google Drive

### 給管理員
1. 每學期開始前，執行 `students-init-114.sql` 導入新名冊
2. 若課綱異動，編輯對應學期的 JSON 配置檔（無需改程式碼）
3. 定期備份 SQLite 資料庫（使用 `scripts/backup-db.sh`）
4. 監控後端 API 日誌（Portainer 面板）

---

## 📖 文檔導覽

| 文檔 | 用途 |
|---|---|
| `課程諮詢系統開發步驟規劃.md` | 📋 13 Phase 完整開發規劃，適合專案經理或規劃者閱讀 |
| `JSON_FORM_SYSTEM_GUIDE.md` | 🔧 JSON 架構細節，適合維護者學習如何修改題目 |
| `REQUIRED_FORMS_CHECKLIST.md` | ✅ 各類表單清單，快速參考需要準備什麼 |
| `PROGRESS_SUMMARY_2026-08-12.md` | 📊 本次完成進度與下一步任務 |

---

## 🎯 開發進度

### 已完成 (80%)
- ✅ UI/UX 設計（鋼藍+警示橘儀表盤風格）
- ✅ 前端表單原型（5步驟，簽名畫布）
- ✅ JSON 資料驅動架構（6份配置檔）
- ✅ 課程清單自動解析（從選課表提取）
- ✅ 學生名冊轉換（JSON + SQLite）
- ✅ 完整文檔與指南

### 進行中 (15%)
- 🏗️ Phase 1：SQLite 資料庫初始化
- 🏗️ Phase 2：後端 API 路由
- 🏗️ Phase 3：PDF 生成引擎（Puppeteer）

### 未來 (5%)
- ⏳ Phase 4：教師後端管理頁
- ⏳ Phase 5：規則引擎 + Google Drive 同步
- ⏳ Phase 11：AI 生涯分析報告

---

## 🤝 貢獻指南

本專案歡迎貢獻！請參考 `CONTRIBUTING.md`。

### 報告問題
1. 檢查是否已有相同 Issue
2. 提供詳細步驟重現問題
3. 說明你的環境（OS、Node.js 版本等）

### 提交改進
1. Fork 本倉庫
2. 建立功能分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add amazing feature'`)
4. 推送分支 (`git push origin feature/amazing-feature`)
5. 開啟 Pull Request

---

## 📞 聯絡方式

- **主要聯絡人**：高雄高工汽車科
- **問題回報**：GitHub Issues
- **建議反饋**：GitHub Discussions

---

## 📜 授權條款

本專案採用 **MIT 許可證**。詳見 `LICENSE` 檔案。

---

## 🙏 致謝

感謝：
- 高雄高工汽車科全體師生
- Claude AI 協助系統設計與代碼生成
- 開源社群提供的各項工具與框架

---

## 🎓 參考資源

- [ASUSTOR NAS 官方文檔](https://www.asustor.com/support)
- [Puppeteer 文檔](https://pptr.dev/)
- [Google Drive API](https://developers.google.com/drive)
- [SQLite 教程](https://www.sqlite.org/lang.html)
- [高級中等學校課程諮詢教師設置要點](https://www.edu.tw/)

---

**最後更新**：2026-08-12  
**版本**：0.8.0（Beta）

🚀 **下一步**：查看 `docs/PROGRESS_SUMMARY_2026-08-12.md` 了解開發路線圖
