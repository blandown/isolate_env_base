@echo off
setlocal

:: ================================================
:: AI / Python Environment Variables
:: ================================================

:: Root paths
set "SCRIPT_ROOT=%~dp0"
set "MODELS_PATH=%SCRIPT_ROOT%models\"

:: Hugging Face cache
if not defined HF_HOME (
    set "HF_HOME=%MODELS_PATH%huggingface"
)

:: UV configuration
set "UV_EXTRA_INDEX_URL=https://download.pytorch.org/whl/cu124"
set "UV_CACHE_DIR=%SCRIPT_ROOT%uv\cache"
set "UV_LINK_MODE=symlink"
set "UV_NO_BUILD_ISOLATION=1"
set "UV_NO_CACHE=0"

:: Pip optimization
set "PIP_DISABLE_PIP_VERSION_CHECK=1"
set "PIP_NO_CACHE_DIR=1"

:: Git LFS optimization
set "GIT_LFS_SKIP_SMUDGE=1"

:: CUDA path (if available in system)
if defined CUDA_PATH (
    set "CUDA_HOME=%CUDA_PATH%"
)

:: ================================================
:: Skip Setup If Already Completed
:: ================================================

if exist ".venv\.setup_complete" (
    echo [INFO] Environment already set up. Skipping...
    goto :end
)

:: ================================================
:: Environment Setup
:: ================================================

:: Install uv if missing
where uv >nul 2>nul
if errorlevel 1 (
    echo [INFO] 'uv' not found. Installing via PowerShell...
    powershell -ExecutionPolicy Bypass -NoProfile -Command "irm https://astral.sh/uv/install.ps1 | iex"
    where uv >nul 2>nul
    if errorlevel 1 (
        echo [ERROR] Failed to install uv.
        exit /b 1
    )
)

:: Create virtual environment
if not exist ".venv" (
    echo [INFO] Creating virtual environment...
    
    uv venv
    @REM uv venv -p 3.10

    if errorlevel 1 (
        echo [ERROR] Failed to create .venv.
        exit /b 1
    )
)

:: Activate venv
call .venv\Scripts\activate.bat
if errorlevel 1 (
    echo [ERROR] Failed to activate virtual environment.
    exit /b 1
)

:: ================================================
:: CUSTOM PROJECT SETUP SECTION
:: Add any extra setup steps below
:: ================================================
@REM uv pip install setuptools
@REM uv pip install -r requirements.txt

:: ================================================
:: Mark Setup as Complete
:: ================================================
echo setup complete > .venv\.setup_complete
echo [INFO] Environment setup complete.

:end
:: Only pause if script was run directly
if not defined CMDCALLED (
    echo.
    pause
)
endlocal & exit /b 0