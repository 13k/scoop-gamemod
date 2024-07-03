. "$PSScriptRoot\defs.ps1"

$wevtutil = Get-Command -ErrorAction Ignore "wevtutil.exe"

if ($null -eq $wevtutil) {
    throw "error: missing dependency: wevtutil.exe"
}

& "$wevtutil" um "$($provider.Manifest)"

if ($LASTEXITCODE -ne 0) {
    throw "error: failed to uninstall manifest"
}

Stop-Service -Name "$($service.Name)"
Remove-Service -Name "$($service.Name)"
