@echo off
title Aaron System Utility
color 0A

echo Starting Aaron System Utility...

powershell.exe -ExecutionPolicy Bypass -NoProfile -File "%~dp0ASU.ps1"

pause
