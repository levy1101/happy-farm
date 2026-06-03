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

if "%~1"=="-run" goto main

:: Run the script with NUL input to bypass Y/N prompts on Ctrl+C
(cmd /c "%~f0" -run) <nul

:: Cleanup Godot when the script exits (e.g., if terminated by Ctrl+C)
taskkill /f /im Godot_v4.6.3-stable_win64.exe 2>nul
taskkill /f /im Godot_v4.6.3-stable_win64_console.exe 2>nul
exit /b 0

:main
echo.
echo Reimporting project assets (headless)...
"%GODOT_BIN%" --path "%PROJECT_DIR%" --headless --editor --quit

echo.
echo Starting Godot...
"%GODOT_BIN%" --path "%PROJECT_DIR%"
exit /b 0
