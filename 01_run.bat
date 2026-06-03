@echo off
setlocal

:: Path to Godot binary on Windows
set "GODOT_BIN=C:\Godot\Godot_v4.6.3-stable_win64.exe"
if not exist "%GODOT_BIN%" (
    set "GODOT_BIN=C:\Godot\Godot_v4.6.3-stable_win64_console.exe"
)

if not exist "%GODOT_BIN%" (
    echo Error: Godot binary not found in C:\Godot. Please verify the folder contents.
    pause
    exit /b 1
)

set "PROJECT_DIR=%~dp0"
if "%PROJECT_DIR:~-1%"=="\" set "PROJECT_DIR=%PROJECT_DIR:~0,-1%"

echo Using Godot binary: %GODOT_BIN%
echo Project: %PROJECT_DIR%

:loop
echo.
echo Reimporting project assets (headless)...
"%GODOT_BIN%" --path "%PROJECT_DIR%" --headless --editor --quit

echo.
echo Starting Godot...
"%GODOT_BIN%" --path "%PROJECT_DIR%"

echo.
echo Godot exited. Restarting in 2 seconds (Press Ctrl+C to stop)...
timeout /t 2 >nul
goto loop

endlocal
