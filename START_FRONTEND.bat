@echo off
cd /d "%~dp0frontend"
if not exist "node_modules" (
  echo Frontend dependencies are missing. Run FIRST_TIME_SETUP.bat first.
  pause
  exit /b 1
)
call npm run dev
pause
