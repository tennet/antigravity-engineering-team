@echo off
rem ==============================================================================
rem run_hook.cmd - Windows Native Polymorphic Python Hook Runner
rem DevOps & Infrastructure Sage (v3.0.0)
rem Avoids Microsoft Store stubs (WindowsApps) and IDE freezing
rem ==============================================================================
setlocal EnableDelayedExpansion

set "SCRIPT_DIR=%~dp0"
set "PROJECT_ROOT=%SCRIPT_DIR%.."

rem 1. Check local virtual environment (.venv or venv)
if exist "%PROJECT_ROOT%\.venv\Scripts\python.exe" (
    "%PROJECT_ROOT%\.venv\Scripts\python.exe" %*
    exit /b !ERRORLEVEL!
)
if exist "%PROJECT_ROOT%\venv\Scripts\python.exe" (
    "%PROJECT_ROOT%\venv\Scripts\python.exe" %*
    exit /b !ERRORLEVEL!
)

rem 2. Check Windows Python Launcher (py.exe -3) - Official standard PEP 397
where py.exe >nul 2>&1
if %ERRORLEVEL% equ 0 (
    py.exe -3 -c "import sys; sys.exit(0)" >nul 2>&1
    if !ERRORLEVEL! equ 0 (
        py.exe -3 %*
        exit /b !ERRORLEVEL!
    )
)

rem 3. Probe python.exe, ensuring it's not the dummy WindowsApps stub
for /f "tokens=*" %%I in ('where python.exe 2^>nul') do (
    set "CANDIDATE=%%I"
    echo !CANDIDATE! | findstr /I /C:"WindowsApps" >nul
    if !ERRORLEVEL! neq 0 (
        rem Valid physical Python binary found outside WindowsApps
        "!CANDIDATE!" -c "import sys; sys.exit(0 if sys.version_info[0] == 3 else 1)" >nul 2>&1
        if !ERRORLEVEL! equ 0 (
            "!CANDIDATE!" %*
            exit /b !ERRORLEVEL!
        )
    )
)

rem 4. Probe python3.exe
for /f "tokens=*" %%I in ('where python3.exe 2^>nul') do (
    set "CANDIDATE=%%I"
    echo !CANDIDATE! | findstr /I /C:"WindowsApps" >nul
    if !ERRORLEVEL! neq 0 (
        "!CANDIDATE!" -c "import sys; sys.exit(0)" >nul 2>&1
        if !ERRORLEVEL! equ 0 (
            "!CANDIDATE!" %*
            exit /b !ERRORLEVEL!
        )
    )
)

echo [ERROR] No suitable Python 3 interpreter found on Windows! Please install Python or use py launcher. >&2
exit /b 1
