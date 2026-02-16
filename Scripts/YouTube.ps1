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

# Папка
$OutputApk = "ReVanced_Builder\youtube.apk"
New-Item -ItemType Directory -Force -Path "ReVanced_Builder" | Out-Null

# APKCombo API (НЕ Cloudflare)
$ApiUrl = "https://apkcombo.com/api/v1/apk-download?id=com.google.android.youtube&arch=arm64-v8a&dpi=nodpi&version=$LatestSupportedYT"

Write-Host "Requesting download info from APKCombo API..."
$Json = Invoke-RestMethod -Uri $ApiUrl -Method GET -UserAgent "Mozilla/5.0"

# Прямая ссылка на APK
$DirectUrl = $Json.url

Write-Host "Downloading YouTube $LatestSupportedYT..."
Invoke-WebRequest -Uri $DirectUrl -OutFile $OutputApk -UserAgent "Mozilla/5.0" -Verbose

Write-Host "YouTube APK downloaded to $OutputApk"
