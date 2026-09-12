@echo off
setlocal
cd /d "%~dp0"
for /f "delims=" %%i in ('git rev-parse --show-toplevel 2^>nul') do set "REPO=%%i"
if not defined REPO (
  echo Not a git repo: %cd%
  pause
  exit /b 1
)
cd /d "%REPO%"
echo Repo: %REPO%
git add -A
git diff --cached --quiet
if %errorlevel%==0 (
  echo No changes to commit.
) else (
  git commit -m "Update %date% %time%"
)
for /f "delims=" %%b in ('git branch --show-current') do set "BR=%%b"
git rev-parse --abbrev-ref --symbolic-full-name @{u} ^>nul 2^>^&1
if %errorlevel%==0 (
  git push
) else (
  git push -u origin %BR%
)
pause
