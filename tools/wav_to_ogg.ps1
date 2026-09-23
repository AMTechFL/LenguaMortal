$lang = "es"
$dir = "tts\$lang"

Write-Host "Converting WAVs to OGG..."

Get-ChildItem "$dir\*.wav" | ForEach-Object {
    $ogg = $_.FullName -replace '\.wav$', '.ogg'
    ffmpeg -y -i $_.FullName -c:a libvorbis -b:a 32k $ogg
    if ($LASTEXITCODE -eq 0) {
        Remove-Item $_.FullName
    }
}

Write-Host "Done"