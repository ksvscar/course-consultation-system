# JSON 資料驅動表單系統使用指南

## 概述

課程諮詢系統採用 **JSON 資料驅動架構**，讓表單題目、選項、欄位完全透過 JSON 配置檔控制，HTML/JS 則是通用的渲染引擎。這樣的好處是：

✅ **未來課綱異動時，只需修改 JSON，不用動程式碼**
✅ **維護簡單，新人容易上手**
✅ **六份表格（各學期）共用同一套前端程式，降低維運成本**

---

## 系統檔案結構

```
/form-renderer-dynamic.html          ← 通用表單渲染引擎（JSON → HTML）
/form-config-high1-up.json           ← 高一上 JSON 配置檔
/form-config-high1-down.json         ← 高一下 JSON 配置檔（待建）
/form-config-high2-up.json           ← 高二上 JSON 配置檔（待建）
/form-config-high2-down.json         ← 高二下 JSON 配置檔（待建）
/form-config-high3-up.json           ← 高三上 JSON 配置檔（待建）
/form-config-high3-down.json         ← 高三下 JSON 配置檔（待建）
```

---

## JSON 配置檔結構說明

### 頂層結構

```json
{
  "metadata": { ... },    // 表單整體資訊（標題、學期、步驟數）
  "steps": [ ... ],       // 各步驟的題目定義
  "validationRules": {},  // 欄位驗證規則
  "autoJudgeRules": {}    // 自動判定「需個別諮詢」的規則
}
```

### metadata 欄位

```json
"metadata": {
  "grade": "高一",              // 年級
  "semester": "上學期",         // 學期
  "schoolYear": "114",          // 學年度
  "totalSteps": 5,              // 總步驟數
  "description": "團體課程諮詢紀錄表（高一上學期）"
}
```

### steps 陣列（各步驟）

每個 step 物件代表一頁問卷，結構如下：

```json
{
  "stepNum": 1,
  "title": "基本資料",
  "description": "請選擇班級，並填寫座號與姓名",
  "fields": [ ... ]             // step1 特用（基本資料欄位）
  // 或
  "questions": [ ... ]          // step2~4 用（題目群組）
}
```

### 題目物件（questions）類型

#### 1. 單選題（single_select）

```json
{
  "id": "q_learning_ability",       // 後端資料庫存儲鍵值
  "type": "single_select",
  "category": "STEP 02",            // 題目分類標籤（紅色）
  "title": "在國中時，你覺得自己的學習能力如何？",
  "options": [
    "很好，學習很快",
    "還可以，跟得上",
    "有點困難，需要多練習",
    "很困難，常常落後"
  ]
}
```

#### 2. 複選題（multi_select）

```json
{
  "id": "q_achieve_subject",
  "type": "multi_select",
  "category": "STEP 02",
  "title": "在國中時哪些科目比較讓你有成就感？",
  "subtitle": "（可複選）",        // 可選，題目下方的灰色提示
  "options": [
    "國文", "英文", "數學", "自然", "社會", "生活科技"
  ],
  "note": "課目清單待確認"          // 可選，卡片下方的灰色註釋
}
```

#### 3. 卡片嵌入連結（card_with_link）

```json
{
  "id": "q_course_map",
  "type": "card_with_link",
  "category": "STEP 03",
  "title": "我瞭解本科課程地圖",
  "linkText": "點此觀看《114課程地圖【汽車科】》說明影片（Edcafe AI）",
  "linkUrl": "https://edcafe.ai/...",  // EdcafeAI 實際連結（未來補）
  "options": ["瞭解", "不瞭解"]
}
```

#### 4. 文字區域（text_area）

```json
{
  "id": "q_next_direction",
  "type": "text_area",
  "category": "STEP 04",
  "title": "高一上學期結束後，你對未來的學習方向有什麼想法嗎？",
  "placeholder": "請填寫你的想法",
  "rows": 4,                        // 可選，默認 3
  "required": true                  // 可選，默認 true
}
```

### autoJudgeRules（自動判定「需個別諮詢」）

後端會根據這些規則自動判定是否建議個別諮詢：

```json
"autoJudgeRules": {
  "needsIndividualConsultation": [
    {
      "name": "選課流程未瞭解",
      "condition": "q_understand_process === '否，我需要協助'",
      "priority": "high"
    },
    {
      "name": "課程地圖不瞭解",
      "condition": "q_course_map === '不瞭解'",
      "priority": "high"
    },
    {
      "name": "多科困擾",
      "condition": "q_difficult_subject.length >= 2",
      "priority": "medium"
    }
  ]
}
```

---

## 如何建立新學期的配置檔

### Step 1：複製高一上的 JSON 範本

```bash
cp form-config-high1-up.json form-config-high1-down.json
```

### Step 2：修改 metadata

```json
"metadata": {
  "grade": "高一",
  "semester": "下學期",     // 改成下學期
  "schoolYear": "114",
  "totalSteps": 5,
  "description": "團體課程諮詢紀錄表（高一下學期）"
}
```

### Step 3：修改 steps 內容

根據該學期的實際紀錄表，修改 questions 陣列，包括：
- 題目文字
- 選項內容（尤其是課程名稱，需要你提供的「課目清單」）
- 新增/刪除題目

### Step 4：修改 autoJudgeRules

根據該學期的關鍵判定標準（哪些題目答案異常代表需要個諮），更新規則。

---

## 待補資料清單

以下是完成六份配置檔所需的資訊，請按優先順序補充：

### 優先級 1：課程名稱清單（必需）

每個學期選一個或多個題目需要「科目清單」，例如：

**高一上**
- 「哪些高一上課程讓你有困擾？」→ 需要高一上實際開課科目清單
- 「在國中科目有成就感」→ 用固定清單（國文英文數學等），已完成

**高一下、高二上/下、高三上/下**
- 各自的「有困擾的科目」題目 → 各自需要對應學期的課程清單

### 優先級 2：Edcafe AI 連結（可選但建議補）

課程地圖、各科目說明等連結，用於「card_with_link」類型題目：
- 高一上課程地圖說明影片連結
- 其他學期對應的課程資源連結

### 優先級 3：各學期的題目內容差異確認

高一上已有範例，後續五份表格需根據實際紙本表格確認：
- 哪些題目要新增/刪除/修改
- 題目文字是否需要調整
- 選項清單是否要更新

---

## 實際應用流程

### 開發環境

1. **編輯 JSON**：用任何文字編輯器修改配置檔
2. **即時預覽**：用 `form-renderer-dynamic.html` 載入修改後的 JSON，查看效果
3. **驗證**：確認所有題目、選項、驗證規則都符合預期

### 生產部署

1. **複數 JSON 檔案支援**：前端改成根據「年級+學期」參數，自動載入對應的 JSON
2. **後端 API**：接收學生填寫的資料，依 JSON 的 `autoJudgeRules` 判定是否需要個諮
3. **版本管理**：若日後課綱異動，更新對應的 JSON 後直接上線，無需重新編譯前端

---

## 質問 FAQ

**Q：如果題目選項非常多（例如科目名稱有50個），JSON 會不會太大？**
A：不會。JSON 也只是文字檔，再怎樣也才幾十KB，頁面載入時會被快取。

**Q：如果老師想要實時編輯題目怎麼辦？**
A：這需要建立一個「題庫編輯後台」（後端 web UI），讓老師在網頁上修改 JSON。這是 Phase 14 的擴充功能，目前不在最小可行版本範圍內。

**Q：如何確保學生看到的是最新的 JSON？**
A：前端可以在 JSON URL 後面加上版本雜湊或時間戳（例如 `?v=20260812`），防止瀏覽器快取舊版本。

---

## 下一步

目前已完成：
- ✅ 高一上 JSON 配置檔（form-config-high1-up.json）
- ✅ 通用表單渲染引擎（form-renderer-dynamic.html）
- ✅ 動態表單系統驗證測試通過

待完成（等你提供課目清單）：
- ⏳ 高一下、高二上/下、高三上/下 的 JSON 配置檔（共5份）
- ⏳ 各學期的 Edcafe AI 連結補充
- ⏳ 後端 API 的 JSON 讀取及自動判定邏輯實現
