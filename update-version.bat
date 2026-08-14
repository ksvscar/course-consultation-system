@echo off
setlocal enabledelayedexpansion

echo.
echo ============================================
echo   Course Consultation System - Update Tool
echo ============================================
echo.

REM Detect where the html file actually lives:
REM   - current directory, OR
REM   - frontend subfolder
set HTML_PATH=

if exist "signature-improved-preview.html" (
    set HTML_PATH=signature-improved-preview.html
) else if exist "frontend\signature-improved-preview.html" (
    set HTML_PATH=frontend\signature-improved-preview.html
)

if "%HTML_PATH%"=="" (
    echo [ERROR] Cannot find signature-improved-preview.html
    echo Checked: current folder and frontend\ subfolder
    echo Please run this script from C:\course-consultation-system
    pause
    exit /b 1
)

echo [INFO] Found file at: %HTML_PATH%
echo.

for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c%%a%%b)
for /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set mytime=%%a%%b)

set VERSION_TAG=%mydate%_%mytime%
set COMMIT_MSG=Update: v%VERSION_TAG%

echo [1/4] Checking git status...
git status --short

echo.
echo [2/4] Adding changes...
git add -A

echo.
echo [3/4] Committing changes (%COMMIT_MSG%)...
git commit -m "%COMMIT_MSG%"

if errorlevel 1 (
    echo [WARN] Nothing to commit, or git error occurred
) else (
    echo [OK] Commit successful
)

echo.
echo [4/4] Pushing to GitHub...
git push origin main

if errorlevel 1 (
    echo [ERROR] Push failed. Check network connection or git config.
    pause
    exit /b 1
) else (
    echo [OK] Push successful!
    echo.
    echo Update complete!
    echo View at: https://ksvscar.github.io/course-consultation-system/
)

echo.
pause
endlocal
