$ErrorActionPreference = "Stop"

# Dung cac tien trinh IIS Express cu neu dang chay ngam
Get-Process -Name iisexpress -ErrorAction SilentlyContinue | Stop-Process -Force

$iis = "C:\Program Files\IIS Express\iisexpress.exe"
$sitePath = Join-Path $PSScriptRoot "WebsiteNoiThat"
$httpsPort = 44373
$httpPort = 58473
$vsConfig = Join-Path $PSScriptRoot ".vs\WebsiteNoiThat\config\applicationhost.config"

if (-not (Test-Path $iis)) {
    throw "Khong tim thay IIS Express tai: $iis"
}

# Uu tien dung file config chuan cua project (.vs)
if (Test-Path $vsConfig) {
    $config = $vsConfig
} else {
    $template = "C:\Program Files\IIS Express\AppServer\applicationhost.config"
    $configDir = Join-Path $env:TEMP "WebsiteNoiThat-IISExpress"
    $config = Join-Path $configDir "applicationhost.config"
    New-Item -ItemType Directory -Force -Path $configDir | Out-Null
    Copy-Item $template $config -Force

    [xml]$xml = Get-Content -Path $config
    $site = $xml.SelectSingleNode("//site")
    $site.SetAttribute("name", "WebsiteNoiThat")

    $vd = $xml.SelectSingleNode("//virtualDirectory")
    $vd.SetAttribute("physicalPath", $sitePath)

    $bindings = $xml.SelectSingleNode("//bindings")
    $bindings.RemoveAll()

    $https = $xml.CreateElement("binding")
    $https.SetAttribute("protocol", "https")
    $https.SetAttribute("bindingInformation", "*:${httpsPort}:localhost")
    [void]$bindings.AppendChild($https)

    $http = $xml.CreateElement("binding")
    $http.SetAttribute("protocol", "http")
    $http.SetAttribute("bindingInformation", "*:${httpPort}:localhost")
    [void]$bindings.AppendChild($http)

    $xml.Save($config)
}

$url = "https://localhost:$httpsPort/"
Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "  DANG KHOI CHAY SERVER HTTPS CHO WEB" -ForegroundColor Cyan
Write-Host "  URL: $url" -ForegroundColor Yellow
Write-Host "  Nhan phim Q trong terminal nay de dung server." -ForegroundColor Gray
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""

# Tu dong bat trinh duyet sau 2 giay
Start-Job -ScriptBlock {
    param($targetUrl)
    Start-Sleep -Seconds 2
    Start-Process $targetUrl
} -ArgumentList $url | Out-Null

& $iis /config:"$config" /site:WebsiteNoiThat
