<# 
.SYNOPSIS
    Utility functions for ASU
#>

# Already have Write-ASULog in main, but can extend here if needed

function Test-AdminRights {
    return ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

Export-ModuleMember -Function Test-AdminRights