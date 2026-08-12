# 部署指南 | Deployment Guide

本文檔說明如何在 ASUSTOR NAS 上部署課程諮詢系統。

## 🚀 前置準備

### 1. NAS 需求
- **型號**：ASUSTOR AS7004T（或相容機型）
- **記憶體**：16GB 以上
- **儲存空間**：50GB 以上
- **Docker**：已安裝 Portainer CE 2.39.4 LTS 或更新版本

### 2. 確認 ASUSTOR DDNS
```bash
# 在 NAS 管理介面確認 DDNS 設定
# 應該有類似 "xxxxxx.myasustor.com" 的網址
```

### 3. GitHub 倉庫
```bash
# 在 NAS 上 Clone 此倉庫
cd /volume1/docker  # 或你的 Docker 路徑
git clone https://github.com/yourusername/course-consultation-system.git
cd course-consultation-system
```

---

## 📦 方案 A：使用 Docker Compose（推薦）

### Step 1：準備環境變數
```bash
# 複製範例檔案
cp .env.example .env

# 編輯 .env，填入你的設定
nano .env
```

### .env 範例
```env
NODE_ENV=production
PORT=3000
DATABASE_PATH=/data/course-consultation.db

# Google Drive API（可選，後期補充）
GOOGLE_DRIVE_FOLDER_ID=your-folder-id-here
GOOGLE_APPLICATION_CREDENTIALS=/app/credentials.json

# API 授權（建議設定強密碼）
API_SECRET_KEY=your-secret-key-here
```

### Step 2：啟動容器
```bash
# 啟動所有服務
docker-compose up -d

# 檢查容器狀態
docker-compose ps

# 查看日誌
docker-compose logs -f api
```

### Step 3：初始化資料庫
```bash
# 方法1：透過 Docker
docker-compose exec api npm run init-db

# 方法2：手動執行 SQL
docker-compose exec db sqlite3 /root/db/course-consultation.db < data/students/students-init-114.sql
```

### Step 4：驗證服務
```bash
# 檢查 API 是否正常運作
curl http://localhost:3000/health

# 應該會看到
# {"status":"ok"}
```

---

## 📋 方案 B：手動部署（無 Docker）

### Step 1：安裝 Node.js
```bash
# 在 NAS 上安裝 Node.js（若未安裝）
# 從 ASUSTOR App Central 搜尋並安裝
# 或使用包管理器
npm --version  # 確認已安裝
```

### Step 2：安裝相依套件
```bash
npm install
```

### Step 3：初始化資料庫
```bash
# 確保已安裝 SQLite
npm run init-db
```

### Step 4：啟動後端
```bash
# 開發環境
npm run dev

# 生產環境
npm start
```

---

## 🔗 設定 ASUSTOR DDNS 路由

### 在 Portainer 中設定

1. **進入 Portainer** → Networks → 確認 `course-net` 存在
2. **設定 cloudflared Tunnel**（若已有）
   - 在 Tunnel 的 Public Hostname 新增路由
   - Domain: `你的DDNS網址.myasustor.com`
   - Service: `http://api:3000`

3. **若使用 Nginx 代理**
   - 配置 `nginx.conf`
   - 設定 upstream 指向 `api:3000`
   - 配置 SSL 憑證（可選但建議）

---

## 📊 資料庫備份與還原

### 備份
```bash
# 使用提供的備份腳本
bash scripts/backup-db.sh

# 或手動備份
sqlite3 data/database/course-consultation.db ".dump" > backup_`date +%Y%m%d_%H%M%S`.sql
```

### 還原
```bash
# 還原備份檔案
sqlite3 data/database/course-consultation.db < backup_20260812_120000.sql
```

---

## 🔍 故障排除

### 問題 1：容器無法啟動
```bash
# 檢查日誌
docker-compose logs api

# 常見原因：
# - 端口 3000 已被佔用
# - 缺少 node_modules
# 解決：修改 docker-compose.yml 中的 PORT 或清除舊容器
```

### 問題 2：資料庫初始化失敗
```bash
# 確保 SQLite 已正確安裝
which sqlite3

# 檢查 SQL 檔案語法
sqlite3 < data/students/students-init-114.sql

# 若有錯誤，檢查檔案編碼（應為 UTF-8）
file data/students/students-init-114.sql
```

### 問題 3：API 無回應
```bash
# 檢查 API 健康狀態
curl http://localhost:3000/health

# 檢查網路連線
docker-compose exec api ping google.com

# 查看詳細日誌
docker-compose logs api | tail -100
```

---

## 📈 效能調整

### CPU 限制（AS7004T 雙核）
```yaml
# 在 docker-compose.yml 中加入
services:
  api:
    cpus: '1.0'  # 限制最多使用 1 核
    mem_limit: 2g  # 限制 2GB 記憶體
```

### PDF 生成並發限制
在 `backend/config.js` 設定：
```javascript
const PUPPETEER_CONCURRENCY = 2;  // AS7004T 建議值
```

---

## 🔐 安全建議

### 1. 設定防火牆
```bash
# 只允許 NAS 內部存取管理介面
# 在 Portainer 中設定限制
```

### 2. 啟用 HTTPS
```bash
# 使用 Let's Encrypt 自簽憑證
# 或在 Cloudflare 配置 SSL/TLS
```

### 3. 定期更新
```bash
# 更新 Node.js 套件
npm update

# 更新 Docker 映像
docker-compose pull
docker-compose up -d
```

### 4. 備份敏感資訊
```bash
# 定期備份 .env 和 credentials.json
# 存放在安全位置（非 Docker volume）
```

---

## 📞 監控與日誌

### 使用 Portainer 監控
- 進入 Portainer 後台
- 檢視容器狀態、資源使用
- 查看即時日誌

### 保存日誌（可選）
```bash
# 將日誌輸出到檔案
docker-compose logs --tail=1000 api > logs/api.log

# 定期輪換日誌（使用 logrotate）
```

---

## 🚀 升級步驟

### 升級到新版本
```bash
# 1. 備份資料庫
npm run backup-db

# 2. 停止服務
docker-compose down

# 3. 更新代碼
git pull origin main

# 4. 重新啟動
docker-compose up -d

# 5. 驗證
curl http://localhost:3000/health
```

---

## 📋 部署檢查清單

部署前，確保已完成以下項目：

- [ ] NAS 已安裝 Docker + Portainer
- [ ] ASUSTOR DDNS 已設定
- [ ] GitHub 倉庫已 Clone 到 NAS
- [ ] .env 檔案已配置
- [ ] 資料庫已初始化（`npm run init-db`）
- [ ] API 健康檢查通過（`curl /health`）
- [ ] 前端可透過 DDNS 網址存取
- [ ] 教師端可透過 Tailscale 連接管理頁
- [ ] 備份腳本已測試
- [ ] 日誌存儲已設定

---

## 📞 遇到問題？

1. 查看 `TROUBLESHOOTING.md`（若有）
2. 檢查 GitHub Issues
3. 查看 Docker / NAS 官方文檔
4. 聯絡專案維護者

---

**最後更新**：2026-08-12  
**適用版本**：0.8.0 Beta
