<# 
.SYNOPSIS
    Windows repair tools module for ASU
#>

function Show-WindowsRepairMenu {
    Clear-Host
    Write-Host "=== Windows Repair Tools ===" -ForegroundColor Cyan
    Write-Host "1. Run SFC /ScanNow" -ForegroundColor White
    Write-Host "2. Run DISM CheckHealth" -ForegroundColor White
    Write-Host "3. Run Full Repair Sequence" -ForegroundColor White
    Write-Host "0. Back" -ForegroundColor White
    
    $Choice = Read-Host "Select repair option"
    switch ($Choice) {
        "1" { 
            Write-Host "Running SFC..." 
            sfc /scannow 
        }
        "2" { 
            Write-Host "Running DISM..." 
            DISM /Online /Cleanup-Image /CheckHealth 
        }
        "3" { 
            Write-Host "Running full repair..." 
            sfc /scannow
            DISM /Online /Cleanup-Image /RestoreHealth
        }
    }
    Write-ASULog "Windows repair action performed" -Level "Info"
    Pause
    Show-MainMenu
}

Export-ModuleMember -Function Show-WindowsRepairMenu