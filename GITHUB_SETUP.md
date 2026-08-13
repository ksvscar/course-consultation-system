# 上傳到 GitHub 指南

本文檔提供完整的上傳步驟，讓你輕鬆將課程諮詢系統推送到 GitHub。

## 📋 準備工作

### 1. 建立 GitHub 帳號（若未有）
- 訪問 https://github.com/join
- 填寫帳號資訊
- 驗證郵箱

### 2. 建立新倉庫
在 GitHub 首頁點擊 **New repository**

**填入以下資訊**：
- **Repository name**: `course-consultation-system`
- **Description**: `高雄高工課程諮詢數位化系統 - Course Consultation Digital System`
- **Public** / **Private**: 選擇 Public（方便團隊協作；若涉及敏感資訊可選 Private）
- **Add a README.md**: ❌ 不勾（本地已有）
- **Add .gitignore**: ❌ 不勾（本地已有）
- **Choose a license**: ❌ 不勾（本地已有 MIT）

點擊 **Create repository**

---

## 🚀 上傳步驟

### Step 1：設定 Git 全局配置（若未設定過）

**Windows/Mac/Linux**：
```bash
git config --global user.name "你的名字"
git config --global user.email "你的Gmail"
git config --global core.safecrlf false  # 避免換行符轉換問題
```

查看設定是否成功：
```bash
git config --global --list
```

### Step 2：新增 GitHub 遠端倉庫

假設你已在本機有 `/tmp/course-consultation-system` 目錄（含 `.git` 資料夾）

```bash
cd /tmp/course-consultation-system

# 查看目前遠端設定
git remote -v

# 新增 GitHub 作為遠端倉庫
git remote add origin https://github.com/你的GitHub用戶名/course-consultation-system.git

# 驗證設定成功
git remote -v
# 應該看到 origin 指向你的 GitHub 倉庫
```

### Step 3：推送到 GitHub

#### 方式 A：使用 HTTPS（簡單，但每次推送需輸入密碼）

```bash
git branch -M main  # 重命名主分支為 main
git push -u origin main
```

系統會要求輸入 GitHub 帳號密碼。  
**注意**：GitHub 已不接受純密碼認証，需使用 Personal Access Token。

#### 方式 B：使用 SSH（推薦，免密推送）

**Step 1：生成 SSH Key**
```bash
ssh-keygen -t ed25519 -C "你的Gmail"
# 或（若不支援 ed25519）
ssh-keygen -t rsa -b 4096 -C "你的Gmail"

# 提示 "Enter file" 時，直接按 Enter（使用預設位置）
# 提示 "Enter passphrase" 時，可留空或設密碼
```

**Step 2：複製公鑰**
```bash
# Mac / Linux
cat ~/.ssh/id_ed25519.pub

# Windows (PowerShell)
Get-Content $env:USERPROFILE\.ssh\id_ed25519.pub

# 複製輸出的內容（以 ssh-ed25519 開頭）
```

**Step 3：在 GitHub 上新增 SSH Key**
1. 登入 GitHub
2. 點擊右上角頭像 → **Settings** → **SSH and GPG keys**
3. 點擊 **New SSH key**
4. **Title**：輸入裝置名稱（例如「我的筆電」）
5. **Key**：貼上剛複製的公鑰內容
6. 點擊 **Add SSH key**

**Step 4：測試 SSH 連線**
```bash
ssh -T git@github.com
# 若成功會看到
# Hi 你的用戶名! You've successfully authenticated...
```

**Step 5：更新遠端 URL（改用 SSH）**
```bash
git remote set-url origin git@github.com:你的GitHub用戶名/course-consultation-system.git

# 驗證
git remote -v
# 應該看到 ssh:// 或 git@github.com 開頭
```

### Step 4：推送代碼

```bash
# 設定主分支並推送
git branch -M main
git push -u origin main

# 之後的推送只需
git push
```

---

## ✅ 驗證上傳成功

### 方法 1：網頁檢查
訪問 `https://github.com/你的GitHub用戶名/course-consultation-system`

應該看到：
- 📁 所有目錄結構（frontend, backend, data, docs 等）
- 📄 README.md 內容正確顯示
- 📊 提交紀錄（Commits 分頁）

### 方法 2：命令行檢查
```bash
# 查看遠端狀態
git remote -v

# 查看推送歷史
git log --oneline

# 檢查所有分支
git branch -a
# 應該看到 main 和 origin/main
```

---

## 📝 初次推送後常見操作

### 修改代碼後推送
```bash
git add .
git commit -m "Fix: 簽名畫布在 Safari 不正常"
git push
```

### 從 GitHub 拉最新代碼
```bash
git pull origin main
```

### 建立功能分支
```bash
git checkout -b feature/add-ai-report
# ... 修改代碼
git add .
git commit -m "feat: 添加 AI 生涯分析報告功能"
git push -u origin feature/add-ai-report
```

然後在 GitHub 上提交 Pull Request (PR) 合併回 main。

---

## 🔧 故障排除

### 問題 1：Permission denied (publickey)
**症狀**：推送時出現 `Permission denied` 錯誤

**解決**：
```bash
# 檢查 SSH 連線
ssh -vT git@github.com

# 若無法連線，檢查 SSH 公鑰是否正確添加到 GitHub
# 或改用 HTTPS 方式
git remote set-url origin https://github.com/你的GitHub用戶名/course-consultation-system.git
```

### 問題 2：fatal: not a git repository
**症狀**：執行 git 命令時出現此錯誤

**解決**：
```bash
# 確認已進入專案目錄
cd /tmp/course-consultation-system

# 確認存在 .git 資料夾
ls -la | grep .git
```

### 問題 3：Authentication failed
**症狀**：輸入 GitHub 密碼後仍失敗

**解決**：使用 Personal Access Token
1. GitHub Settings → Developer settings → Personal access tokens
2. 點擊 **Generate new token**
3. 勾選 `repo` 和 `workflow` 權限
4. 複製 token（務必保存，之後無法再看到）
5. 推送時用 token 代替密碼

---

## 🎯 建議設置

### 保護主分支（可選）
1. GitHub 倉庫 → Settings → Branches
2. 點擊 **Add rule**
3. 設定 Branch name pattern：`main`
4. 勾選：
   - ✅ Require a pull request before merging
   - ✅ Require status checks to pass before merging
   - ✅ Require branches to be up to date before merging

### 建立議題範本（可選）
在倉庫根目錄建立 `.github/ISSUE_TEMPLATE/` 資料夾，存放 bug report 或 feature request 範本。

---

## 📊 監控倉庫

### GitHub Actions（CI/CD）
若未來想設定自動化測試或部署，可在 `.github/workflows/` 目錄新增 YAML 檔案。

**範例**：自動測試
```yaml
# .github/workflows/test.yml
name: Run Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: npm install
      - run: npm test
```

---

## 📞 後續協作

### 邀請團隊成員
1. 倉庫 Settings → Collaborators
2. 點擊 **Add people**
3. 輸入成員的 GitHub 用戶名
4. 選擇權限等級（Maintainer / Developer / Triager）

### 管理 Issue 和 PR
- **Issues**：追蹤 bug、功能需求、討論
- **Pull Requests**：代碼審查與合併
- **Projects**（可選）：用看板式管理任務

---

## ✨ 完成！

恭喜！你已成功建立 GitHub 倉庫並推送課程諮詢系統。

**接下來可以**：
1. 分享倉庫連結給團隊 (`https://github.com/你的用戶名/course-consultation-system`)
2. 在 README 中新增團隊成員致謝
3. 邀請其他開發者開始貢獻
4. 建立 Release 版本（Releases 分頁）

**資源**：
- [GitHub 官方文檔](https://docs.github.com)
- [Git 教學](https://git-scm.com/book/zh-tw/v2)
- [Git 流程指南](https://www.atlassian.com/git/tutorials/comparing-workflows)

---

**有任何問題？** 查看本倉庫的 Issues 分頁或聯絡維護者。

---

祝部署順利！🚀
