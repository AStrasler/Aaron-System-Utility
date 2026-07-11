@echo off
:: Aaron System Utility Launcher
:: Launches ASU.ps1 with required execution policy and bypass

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0ASU.ps1" %*
pause