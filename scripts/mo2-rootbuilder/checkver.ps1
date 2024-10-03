$ProgressPreference = "SilentlyContinue"

$url = "https://api.github.com/repos/Kezyma/ModOrganizer-Plugins/releases/tags/rootbuilder"
$resp = Invoke-WebRequest -Uri "$url" -ErrorAction Stop
$obj = ConvertFrom-Json $resp.Content -ErrorAction Stop

$asset = $obj.assets |
    Where-Object { $_.name -match 'rootbuilder.([\d.]+).zip' } |
    ForEach-Object { @{ version = $matches[1]; url = $_.browser_download_url; } } |
    Select-Object -Last 1

if ($null -eq $asset) {
    throw "Could not find a suitable asset from ${url}"
}

Write-Output "$($asset.version)|$($asset.url)"
