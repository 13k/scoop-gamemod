. "$PSScriptRoot\defs.ps1"

$wevtutil = Get-Command -ErrorAction Ignore "wevtutil.exe"

if ($null -eq $wevtutil) {
    throw "error: missing dependency: wevtutil.exe"
}

& "$wevtutil" im "$($provider.Manifest)" /rf:"$($provider.Dll)" /mf:"$($provider.Dll)"

if ($LASTEXITCODE -ne 0) {
    throw "error: failed to install manifest"
}

& "$wevtutil" gp "$($provider.Name)" | Out-Null

if ($LASTEXITCODE -ne 0) {
    throw "error: failed to install manifest"
}

New-Service @service
Start-Service -Name "$($service.Name)"
