# Gzip compression script for Flutter Web assets
# Usage: .\compress.ps1

Add-Type -AssemblyName System.IO.Compression.FileSystem

$files = @("main.dart.js", "flutter.js", "flutter_service_worker.js")

foreach ($file in $files) {
    if (Test-Path $file) {
        $source = $file
        $target = "$file.gz"
        
        Write-Host "Compressing $source -> $target"
        
        [System.IO.Compression.GZipStream]::new(
            [System.IO.File]::Create($target),
            [System.IO.Compression.CompressionMode]::Compress
        ) | ForEach-Object {
            $_ | Out-Null
            [System.IO.File]::ReadAllBytes($source) | $_.Write($_, 0, $_)
        }
        
        $originalSize = (Get-Item $source).Length / 1KB
        $compressedSize = (Get-Item $target).Length / 1KB
        $ratio = [math]::Round((1 - ($compressedSize / $originalSize)) * 100, 1)
        
        Write-Host "  $source: $('{0:N0}' -f $originalSize) KB → $('{0:N0}' -f $compressedSize) KB ($ratio% kleiner)"
    }
}

Write-Host "Done!"
