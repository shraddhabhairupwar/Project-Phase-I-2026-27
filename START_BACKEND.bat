@echo off
cd /d "%~dp0backend"
if not exist ".env" (
  echo Missing backend\.env. Run FIRST_TIME_SETUP.bat and configure your database password first.
  pause
  exit /b 1
)
if exist ".venv\Scripts\activate.bat" call ".venv\Scripts\activate.bat"
if exist ".\.venv\Scripts\activate.bat" call ".\.venv\Scripts\activate.bat"
python -m uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
pause
