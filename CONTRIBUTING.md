# 貢獻指南 | Contributing Guidelines

感謝你有興趣貢獻本專案！以下是貢獻流程與規範。

## 📋 流程

### 1. 報告 Issue

如果你發現 bug 或有功能建議，請先檢查是否已有相同的 Issue。

**新增 Issue 時請提供**：
- 清楚的標題
- 問題描述（what、where、when）
- 重現步驟（若是 bug）
- 期望行為 vs 實際行為
- 環境資訊（作業系統、瀏覽器、Node.js 版本等）

### 2. Fork 並建立分支

```bash
# Fork 此倉庫到你的 GitHub 帳號
# 複製你的 fork
git clone https://github.com/your-username/course-consultation-system.git
cd course-consultation-system

# 建立功能分支
git checkout -b feature/your-feature-name
```

### 3. 開發與測試

```bash
# 安裝依賴
npm install

# 開發模式（自動重啟）
npm run dev

# 執行測試
npm test

# Lint 檢查
npm run lint
```

### 4. 提交更改

```bash
# 檢查變更
git status

# 新增檔案
git add .

# 提交（請使用有意義的提交訊息）
git commit -m "Fix: 簽名畫布在 Safari 上無法正常繪製"
```

**提交訊息規範**：
- `feat:` 新功能
- `fix:` 修正 bug
- `docs:` 文檔更新
- `style:` 代碼風格調整（不涉及邏輯）
- `refactor:` 重構
- `test:` 新增或修改測試
- `chore:` 維護工作（依賴更新等）

### 5. 推送並提交 Pull Request

```bash
# 推送到你的 fork
git push origin feature/your-feature-name
```

在 GitHub 上提交 PR，並：
- 清楚描述你的改動內容
- 關聯相關的 Issue（若有）
- 說明測試方式
- 附上螢幕截圖或影片（如適用）

### 6. 等待審查

維護者會審查你的 PR，可能會要求調整。請耐心等候，保持溝通。

---

## 🎯 優先貢獻領域

我們特別歡迎以下領域的貢獻：

### 前端
- 改進簽名畫布的觸控體驗（特別是 iPad）
- 優化移動裝置上的表單排版
- 添加國英文切換功能
- 改進無障礙使用（ARIA 標籤等）

### 後端
- 實現 Phase 2 的 API 路由
- 優化 PDF 生成速度
- 改進錯誤處理與日誌
- 添加資料驗證

### 文檔
- 修正錯別字或不清楚的地方
- 補充使用範例
- 翻譯文檔為其他語言

### 測試
- 編寫單元測試（Jest）
- 編寫集成測試
- 測試跨瀏覽器相容性

---

## 📋 代碼規範

### JavaScript/Node.js
- 使用 ES6+ 語法
- 變數名稱用 camelCase（例：`formConfig`）
- 常數用 UPPER_CASE（例：`API_TIMEOUT`）
- 使用 2 格空白縮進
- 字符串用單引號 `'` 或反引號`` ` ``，盡量避免雙引號

### 範例
```javascript
// ✅ 好
const getUserProfile = (userId) => {
  return fetch(`/api/users/${userId}`)
    .then(res => res.json());
};

// ❌ 不好
const GetUserProfile = (user_id) => {
  var result = fetch("/api/users/" + user_id);
  return result;
};
```

### HTML/CSS
- 使用 BEM 命名法命名 CSS 類別（例：`form__field--error`）
- CSS 用 2 格空白縮進
- 優先使用 CSS 變數而非硬編碼顏色

---

## 🧪 測試規範

### 單元測試
```javascript
// 使用 Jest
describe('FormRenderer', () => {
  it('should load JSON configuration', () => {
    const renderer = new FormRenderer(testConfig);
    expect(renderer.config).toEqual(testConfig);
  });
});
```

### 手動測試檢查清單
- [ ] 在 Chrome / Firefox / Safari 測試
- [ ] 在 iOS / Android 測試簽名畫布
- [ ] 測試表單驗證（缺少必要欄位）
- [ ] 測試 PDF 生成
- [ ] 測試資料庫查詢

---

## 📖 文檔更新

若你修改功能或添加新功能，請同時更新相關文檔：

1. `README.md` — 若影響使用流程
2. `JSON_FORM_SYSTEM_GUIDE.md` — 若涉及 JSON 結構
3. 代碼註解 — 複雜邏輯的說明

---

## 💬 溝通禮儀

- 保持友善與尊重
- 假設他人的善意
- 接受批評並虛心聽取
- 如遇分歧，優先討論而非爭執

---

## 🐛 安全性考量

若你發現安全漏洞，**請勿公開提交 Issue**。改為：
1. 寄信至 [維護者信箱]
2. 說明漏洞詳情與重現步驟
3. 建議修補方案（若有）

我們會盡快回應並協調修補時間。

---

## 📚 額外資源

- [GitHub Pull Request 官方指南](https://docs.github.com/en/pull-requests)
- [Git 提交訊息最佳實踐](https://www.conventionalcommits.org/)
- [Jest 測試框架文檔](https://jestjs.io/)
- [SQLite 文檔](https://www.sqlite.org/docs.html)

---

感謝你的貢獻！🎉
