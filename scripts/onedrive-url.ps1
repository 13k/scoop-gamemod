###
### ./onedrive-url.ps1 'https://1drv.ms/u/s!AkrMN5rEchI3iahuBHq_AvR6BGF3Dg?e=fRTPM5'
###

$USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:131.0) Gecko/20100101 Firefox/131.0"

# 'https://1drv.ms/u/s!AkrMN5rEchI3iahuBHq_AvR6BGF3Dg?e=fRTPM5'
$one_drive_uri = $args[0]

Write-Host "GET '${one_drive_uri}'"

try {
  $res = Invoke-WebRequest -Uri "$one_drive_uri" `
    -UserAgent "$USER_AGENT" `
    -MaximumRedirection 0
} catch {
  $res = $_.Exception.Response
}

# "?resid=371272C49A37CC4A!152686&authkey=!AAR6vwL0egRhdw4&e=fRTPM5"
$query_str = $res.Headers.Location.Query
$query = [System.Web.HttpUtility]::ParseQueryString($query_str)
# "371272C49A37CC4A!152686"
$resource_id = $query["resid"] 
# "!AAR6vwL0egRhdw4"
$auth_key = $query["authkey"] 
# "fRTPM5"
$e = $query["e"] 

if (-not ($resource_id -match "^(?<drive_id>.+)!.+$")) {
  throw "could not extract drive_id from resource_id: '${resource_id}'"
}

# "371272C49A37CC4A"
$drive_id = $matches.drive_id

Write-Host "
query = '${query_str}'
resource_id = '${resource_id}'
auth_key = '${auth_key}'
e = '${e}'
drive_id = '${drive_id}'
"

$api_uri = New-Object System.UriBuilder("https", "api.onedrive.com")
$api_uri.Path = "/v1.0/drives/${drive_id}/items/${resource_id}"
$api_uri.Query = "?authKey=${auth_key}" 
$api_uri.Query += "&`$select=*,sharepointIds,webDavUrl,containingDrivePolicyScenarioViewpoint"
$api_uri.Query += "&`$expand=thumbnails"
$api_uri.Query += "&ump=1"

Write-Host "GET '${api_uri}'"

$res = Invoke-WebRequest -Uri "$api_uri" `
  -UserAgent "$USER_AGENT" `
  -Headers @{
    "Accept" = "*/*"
    "Accept-Language" = "en-US,en;q=1.0"
    "Accept-Encoding" = "gzip, deflate, br, zstd"
    "Origin" = "https://onedrive.live.com"
    "Referer" = "https://onedrive.live.com/"
    "Sec-Fetch-Dest" = "empty"
    "Sec-Fetch-Mode" = "cors"
    "Sec-Fetch-Site" = "cross-site"
  } `
  -ErrorAction Stop

$obj = ConvertFrom-Json -InputObject $res.Content -ErrorAction Stop
$json_pretty = ConvertTo-Json -Depth 100 -InputObject $obj -ErrorAction Stop

New-Item -Type File -Path "onedrive-res.json" -Value "$json_pretty" -Force -ErrorAction Stop

$download_url = $obj."@content.downloadUrl"
$filename = $obj.name
$hash_sha256 = $obj.file.hashes.sha256Hash

Write-Host ""
Write-Host "url = '${download_url}'"
Write-Host "filename = '${filename}'"
Write-Host "sha256 = '${hash_sha256}'"
Write-Host ""
