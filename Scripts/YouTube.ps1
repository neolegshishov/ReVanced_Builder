# Получаем последнюю поддерживаемую версию YouTube
$Parameters = @{
    Uri             = "https://api.revanced.app/v4/patches/list"
    UseBasicParsing = $true
    Verbose         = $true
}
$Patches = (Invoke-RestMethod @Parameters | Where-Object { $_.name -eq "Video ads" })
$LatestSupportedYT = $Patches.compatiblePackages."com.google.android.youtube" |
    Sort-Object -Descending -Unique |
    Select-Object -First 1

echo "LatestSupportedYT=$LatestSupportedYT" >> $env:GITHUB_ENV

# Путь для сохранения
$OutputApk = "ReVanced_Builder\youtube.apk"
New-Item -ItemType Directory -Force -Path "ReVanced_Builder" | Out-Null

# APKCombo прямой URL (без Cloudflare)
$DownloadUrl = "https://apkcombo.com/com.google.android.youtube/download/apk?arch=arm64-v8a&dpi=nodpi&ver=$LatestSupportedYT"

Write-Host "Downloading YouTube $LatestSupportedYT from APKCombo..."
Invoke-WebRequest -Uri $DownloadUrl -OutFile $OutputApk -UserAgent "Mozilla/5.0" -Verbose

Write-Host "YouTube APK downloaded to $OutputApk"
