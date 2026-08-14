@echo off
REM update-version.bat - 自動化版本更新與GitHub推送
REM 用法：在 C:\course-consultation-system 目錄執行此批次檔

setlocal enabledelayedexpansion

REM 設定顏色輸出
for /F %%A in ('echo prompt $H ^| cmd') do set "BS=%%A"

echo.
echo ============================================
echo     課程諮詢記錄系統 - 版本更新工具
echo ============================================
echo.

REM 檢查是否在正確目錄
if not exist "signature-improved-preview.html" (
    echo [ERROR] 未找到 signature-improved-preview.html
    echo 請在 C:\course-consultation-system 目錄執行此檔案
    pause
    exit /b 1
)

REM 獲取當前日期和時間
for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c%%a%%b)
for /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set mytime=%%a%%b)

set VERSION_TAG=%mydate%_%mytime%
set COMMIT_MSG=Update: v%VERSION_TAG%

echo [1/4] 檢查 Git 狀態...
git status --short

echo.
echo [2/4] 添加變更...
git add -A

echo.
echo [3/4] 提交變更 (%COMMIT_MSG%)...
git commit -m "%COMMIT_MSG%"

if errorlevel 1 (
    echo [WARN] 無變更要提交或 git 錯誤
) else (
    echo [OK] 提交成功
)

echo.
echo [4/4] 推送至 GitHub...
git push origin main

if errorlevel 1 (
    echo [ERROR] 推送失敗，請檢查網路連線或 Git 設定
    pause
    exit /b 1
) else (
    echo [OK] 推送成功！
    echo.
    echo ✅ 版本更新完成！
    echo 可訪問: https://ksvscar.github.io/course-consultation-system/
)

echo.
pause
endlocal
