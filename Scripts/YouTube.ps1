# Получаем последнюю поддерживаемую версию YouTube
$Parameters = @{
    Uri             = "https://api.revanced.app/v4/patches/list"
    UseBasicParsing = $true
}
$Patches = (Invoke-RestMethod @Parameters | Where-Object { $_.name -eq "Video ads" })
$LatestSupportedYT = $Patches.compatiblePackages."com.google.android.youtube" |
    Sort-Object -Descending -Unique |
    Select-Object -First 1

echo "LatestSupportedYT=$LatestSupportedYT" >> $env:GITHUB_ENV

# Папка
$OutputApk = "ReVanced_Builder\youtube.apk"
New-Item -ItemType Directory -Force -Path "ReVanced_Builder" | Out-Null

# Официальный ReVanced CDN (НЕ Cloudflare)
$DownloadUrl = "https://releases.revanced.app/youtube/$LatestSupportedYT/apk"

Write-Host "Downloading YouTube $LatestSupportedYT from ReVanced CDN..."
Invoke-WebRequest -Uri $DownloadUrl -OutFile $OutputApk -UserAgent "Mozilla/5.0" -Verbose

Write-Host "YouTube APK downloaded to $OutputApk"
