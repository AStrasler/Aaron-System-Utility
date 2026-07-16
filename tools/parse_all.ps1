$root = "c:\Users\aaron_lc3zh3u\Documents\GitHub\Aaron-System-Utility"
$fail = $false
Get-ChildItem -Path $root -Include *.ps1,*.psm1 -Recurse -File | ForEach-Object {
    $path = $_.FullName
    Write-Output "Checking: $path"
    $tokens = $null
    $errors = $null
    [System.Management.Automation.Language.Parser]::ParseFile($path,[ref]$tokens,[ref]$errors) | Out-Null
    if ($errors -and $errors.Count -gt 0) {
        Write-Output "Errors in $path"
        $errors | Format-List
        $fail = $true
    } else {
        Write-Output "OK: $path"
    }
}
if ($fail) { exit 2 } else { Write-Output 'ALL_PARSE_OK' }
