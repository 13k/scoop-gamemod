$provider = @{
    Name = "Intel-PresentMon"
    Manifest = "$dir\Provider\Intel-PresentMon.man"
    Dll = "$dir\Provider\Intel-PresentMon.dll"
}

$service = @{
    Name = "PresentMonService"
    BinaryPathName = "$dir\Service\PresentMonService.exe"
    DisplayName = "PresentMonService"
    Description = "PresentMon Service for performance monitoring and analysis."
    StartupType = "Automatic"
}
