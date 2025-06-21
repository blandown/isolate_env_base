@echo off
setlocal
set CMDCALLED=1

call enviroment.bat
if errorlevel 1 (
    echo [ERROR] Failed to set up environment.
    exit /b 1
)

call .venv\Scripts\activate.bat

python main.py

endlocal
