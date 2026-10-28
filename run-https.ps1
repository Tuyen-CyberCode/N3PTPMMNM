$ErrorActionPreference = "Stop"

# Dung cac tien trinh IIS Express cu neu dang chay ngam
Get-Process -Name iisexpress -ErrorAction SilentlyContinue | Stop-Process -Force

$iis = "C:\Program Files\IIS Express\iisexpress.exe"
$template = "C:\Program Files\IIS Express\AppServer\applicationhost.config"
$sitePath = Join-Path $PSScriptRoot "WebsiteNoiThat"
$httpsPort = 44373

if (-not (Test-Path $iis)) {
    throw "Khong tim thay IIS Express: $iis"
}
if (-not (Test-Path $template)) {
    throw "Khong tim thay file cau hinh mau: $template"
}

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
$xml.Save($config)

Write-Host "HTTPS: https://localhost:$httpsPort/"
Write-Host "Nhan Q trong cua so nay de dung IIS Express."
& $iis /config:"$config" /site:WebsiteNoiThat
