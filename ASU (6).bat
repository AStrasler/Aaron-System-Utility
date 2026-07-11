<# 
.SYNOPSIS
    Aaron System Utility (ASU) - Windows Maintenance and Diagnostics Tool
.DESCRIPTION
    Modular PowerShell utility for Windows system maintenance, diagnostics, and reporting.
    Compatible with PowerShell 5.1 on Windows 11.
.NOTES
    Version: 1.0.0
    Author: Grok (built with xAI assistance)
    License: MIT
#>

# Set strict mode and error handling
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Define root path
$script:ASURoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$script:ModulePath = Join-Path $script:ASURoot "Modules"

# Import configuration
$ConfigPath = Join-Path $script:ASURoot "Config/settings.json"
if (Test-Path $ConfigPath) {
    $script:Config = Get-Content $ConfigPath -Raw | ConvertFrom-Json
} else {
    $script:Config = @{
        LoggingLevel = "Info"
        ReportPath = "Reports"
        HealthThresholds = @{
            MemoryWarning = 80
            StorageWarning = 20
            BatteryWarning = 70
        }
    }
    # Create default config
    $ConfigDir = Join-Path $script:ASURoot "Config"
    if (-not (Test-Path $ConfigDir)) { New-Item -Path $ConfigDir -ItemType Directory -Force | Out-Null }
    $script:Config | ConvertTo-Json -Depth 5 | Out-File $ConfigPath -Encoding UTF8
}

# Logging setup
$script:LogPath = Join-Path $script:ASURoot "Logs"
if (-not (Test-Path $script:LogPath)) { New-Item -Path $script:LogPath -ItemType Directory -Force | Out-Null }

function Write-ASULog {
    param(
        [string]$Message,
        [string]$Level = "Info"
    )
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogFile = Join-Path $script:LogPath "ASU_$(Get-Date -Format 'yyyy-MM-dd').log"
    "$Timestamp [$Level] $Message" | Add-Content -Path $LogFile -Encoding UTF8
    if ($script:Config.LoggingLevel -eq "Debug" -or $Level -in @("Error", "Warning")) {
        Write-Host "[$Level] $Message" -ForegroundColor $(if ($Level -eq "Error") { "Red" } elseif ($Level -eq "Warning") { "Yellow" } else { "White" })
    }
}

Write-ASULog "ASU starting up" -Level "Info"

# Import all modules
$Modules = Get-ChildItem -Path $script:ModulePath -Filter "*.psm1" -ErrorAction SilentlyContinue
foreach ($Module in $Modules) {
    try {
        Import-Module $Module.FullName -Force -ErrorAction Stop
        Write-ASULog "Imported module: $($Module.BaseName)" -Level "Info"
    } catch {
        Write-ASULog "Failed to import $($Module.BaseName): $_" -Level "Error"
    }
}

# ASCII Banner
function Show-Banner {
    Clear-Host
    Write-Host @"
    ==================================================
          Aaron System Utility (ASU) v1.0.0
    ==================================================
    Professional Windows Maintenance & Diagnostics
    ==================================================
"@ -ForegroundColor Cyan
}

# Main Menu
function Show-MainMenu {
    Show-Banner
    Write-Host "Main Dashboard" -ForegroundColor Green
    Write-Host "===============================================" -ForegroundColor DarkGray
    
    # Basic system info - will be expanded with modules
    $ComputerName = $env:COMPUTERNAME
    $OS = Get-CimInstance Win32_OperatingSystem
    Write-Host "Computer Name: $ComputerName" -ForegroundColor White
    Write-Host "Windows Version: $($OS.Caption) Build $($OS.BuildNumber)" -ForegroundColor White
    
    # Health Score placeholder
    $HealthScore = Get-OverallHealthScore
    $Color = if ($HealthScore -ge 90) { "Green" } elseif ($HealthScore -ge 70) { "Yellow" } else { "Red" }
    Write-Host "Overall Health Score: $HealthScore / 100" -ForegroundColor $Color
    
    Write-Host "`nOptions:" -ForegroundColor Cyan
    Write-Host "1. Hardware Diagnostics" -ForegroundColor White
    Write-Host "2. Memory Analysis" -ForegroundColor White
    Write-Host "3. Storage Health" -ForegroundColor White
    Write-Host "4. Startup Management" -ForegroundColor White
    Write-Host "5. Network Diagnostics" -ForegroundColor White
    Write-Host "6. Battery Analysis" -ForegroundColor White
    Write-Host "7. Windows Repair Tools" -ForegroundColor White
    Write-Host "8. System Cleanup" -ForegroundColor White
    Write-Host "9. Check for Updates" -ForegroundColor White
    Write-Host "10. Generate Reports" -ForegroundColor White
    Write-Host "11. Settings" -ForegroundColor White
    Write-Host "0. Exit" -ForegroundColor White
    
    $Choice = Read-Host "`nSelect an option (0-11)"
    Process-MenuChoice $Choice
}

function Process-MenuChoice {
    param([string]$Choice)
    switch ($Choice) {
        "1" { Show-HardwareMenu }
        "2" { Show-MemoryMenu }
        "3" { Show-StorageMenu }
        "4" { Show-StartupMenu }
        "5" { Show-NetworkMenu }
        "6" { Show-BatteryMenu }
        "7" { Show-WindowsRepairMenu }
        "8" { Show-CleanupMenu }
        "9" { Show-UpdatesMenu }
        "10" { Show-ReportsMenu }
        "11" { Show-SettingsMenu }
        "0" { 
            Write-ASULog "ASU shutting down" -Level "Info"
            Write-Host "Thank you for using Aaron System Utility. Goodbye!" -ForegroundColor Green
            exit 
        }
        default { 
            Write-Host "Invalid option. Please try again." -ForegroundColor Red
            Start-Sleep -Seconds 2
            Show-MainMenu 
        }
    }
}

# Placeholder for Health Score - will be implemented in modules
function Get-OverallHealthScore {
    # Basic calculation placeholder
    $Score = 85  # Default for now
    return $Score
}

# Menu functions are provided by imported modules

function Show-SettingsMenu {
    Clear-Host
    Write-Host "=== Settings ===" -ForegroundColor Cyan
    Write-Host "Current Logging Level: $($script:Config.LoggingLevel)" -ForegroundColor White
    Write-Host "`nSettings management coming in future versions." -ForegroundColor Yellow
    Pause
    Show-MainMenu
}

function Pause {
    Write-Host "`nPress any key to continue..." -ForegroundColor DarkGray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

# Start the application
try {
    Show-MainMenu
} catch {
    Write-ASULog "Critical error: $_" -Level "Error"
    Write-Host "An error occurred. Check logs for details." -ForegroundColor Red
    Pause
}