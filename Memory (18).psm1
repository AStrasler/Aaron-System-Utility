<# 
.SYNOPSIS
    Cleanup module for ASU
#>

function Show-CleanupMenu {
    Clear-Host
    Write-Host "=== System Cleanup ===" -ForegroundColor Cyan
    Write-Host "Cleaning temporary files..." -ForegroundColor Yellow
    
    # Basic cleanup
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Temp files cleaned." -ForegroundColor Green
    
    Write-ASULog "System cleanup performed" -Level "Info"
    Pause
    Show-MainMenu
}

Export-ModuleMember -Function Show-CleanupMenu