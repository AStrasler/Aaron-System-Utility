@echo off
REM Simple double-click launcher for Aaron-System-Utility
REM Place this next to ASU.ps1 and double-click to run

SET SCRIPT_DIR=%~dp0
powershell -NoProfile -NoExit -ExecutionPolicy Bypass -File "%SCRIPT_DIR%ASU.ps1"
