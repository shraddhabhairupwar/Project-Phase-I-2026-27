@echo off
setlocal
cd /d "%~dp0"
echo ================================================
echo LingoSpark - First-time setup
echo ================================================
where python >nul 2>nul
if errorlevel 1 (
  echo Python was not found. Install Python 3.10 or newer, then run this file again.
  pause
  exit /b 1
)
where node >nul 2>nul
if errorlevel 1 (
  echo Node.js was not found. Install Node.js 18 or newer, then run this file again.
  pause
  exit /b 1
)
if not exist "backend\.env" (
  copy "backend\.env.example" "backend\.env" >nul
  echo Created backend\.env. Edit it and enter your PostgreSQL password before starting the app.
)
if not exist "backend\.venv\Scripts\python.exe" (
  python -m venv backend\.venv
  if errorlevel 1 goto fail
)
call "backend\.venv\Scripts\activate.bat"
python -m pip install --upgrade pip
if errorlevel 1 goto fail
python -m pip install -r backend\requirements.txt
if errorlevel 1 goto fail
cd frontend
call npm install
if errorlevel 1 goto fail
cd ..
echo.
echo Setup completed. IMPORTANT: confirm backend\.env points to YOUR existing PostgreSQL database.
echo Do not overwrite or delete your old database. Keep its original DATABASE_URL and SECRET_KEY.
echo Then start START_BACKEND.bat and START_FRONTEND.bat in two separate windows.
pause
exit /b 0
:fail
echo Setup did not finish. Read the error above, correct it, and run this file again.
pause
exit /b 1
