<# 
.SYNOPSIS
    Updates module for ASU
#>

function Show-UpdatesMenu {
    Clear-Host
    Write-Host "=== System Updates ===" -ForegroundColor Cyan
    Write-Host "Checking for updates (winget and Windows)..." -ForegroundColor Yellow
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget upgrade --all
    } else {
        Write-Host "winget not available." -ForegroundColor Yellow
    }
    Write-ASULog "Updates checked" -Level "Info"
    Pause
    Show-MainMenu
}

Export-ModuleMember -Function Show-UpdatesMenu