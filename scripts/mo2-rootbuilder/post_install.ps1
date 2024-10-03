$app = $args[0]
$appDir = appdir "$app"

if ($null -eq $appDir) {
    exit
}

if (-not (Test-Path "$appDir")) {
    exit
}

$pluginDir = "$appDir\\current\\plugins\\rootbuilder"

if (Test-Path "$pluginDir") {
  Remove-Item -Force "$pluginDir"
}

New-Item -Type Junction -Target "$dir" -Path "$pluginDir"
