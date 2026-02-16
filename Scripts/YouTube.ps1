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

# Скачиваем YouTube через revanced-cli downloader
# revanced-cli сам найдёт нужную версию и скачает APK
$OutputApk = "ReVanced_Builder\youtube.apk"

# Убедимся, что папка существует
New-Item -ItemType Directory -Force -Path "ReVanced_Builder" | Out-Null

# Запускаем revanced-cli
# -a com.google.android.youtube — пакет
# -o путь куда сохранить
# -d — включить downloader
# -f — перезаписать файл если уже есть
& "$env:ProgramFiles\Zulu\zulu*\bin\java.exe" `
    -jar "ReVanced_Builder\revanced-cli.jar" `
    -a com.google.android.youtube `
    -o $OutputApk `
    -d `
    -f

Write-Host "YouTube APK downloaded to $OutputApk"

