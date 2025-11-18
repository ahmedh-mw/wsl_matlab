# matlab_batch.ps1

param(
    [Parameter(Mandatory=$true)]
    [Alias('b')]
    [string]$Batch
)

$INTERVAL = 0.2

# Set up paths
$homePath = $env:USERPROFILE
$loopRootPath = Join-Path $homePath ".matlab"
$inboundPath = Join-Path $loopRootPath ".inbound"
$outboundPath = Join-Path $loopRootPath ".outbound"
$archivePath = Join-Path $loopRootPath ".archive"
$processId = $PID
$inboundFilePath = Join-Path $inboundPath "$processId.in"
$outboundFilePath = Join-Path $outboundPath "$processId.out"
$archiveFilePath = Join-Path $archivePath "$processId.out"

# Write batch command to inbound file
Set-Content -Path $inboundFilePath -Value $Batch -NoNewline

# Wait for outbound file to appear
while (-not (Test-Path $outboundFilePath)) {
    Start-Sleep -Seconds $INTERVAL
}

# Read outbound file line by line, stopping at EOF marker
$EOF_MARKER = "###############--EOF_EXECUTION--###############"
$fs = $null
$reader = $null

try {
    # Open the file with shared read/write access
    $fs = [System.IO.File]::Open($outboundFilePath,
                                [System.IO.FileMode]::Open,
                                [System.IO.FileAccess]::Read,
                                [System.IO.FileShare]::ReadWrite)
    $reader = New-Object System.IO.StreamReader($fs)
    while ($true) {
        $line = $reader.ReadLine()
        if ($null -ne $line) {
            if ($line.Trim() -eq $EOF_MARKER) {
                break
            }
            Write-Host $line
        } else {
            Start-Sleep -Seconds $INTERVAL
        }
    }
}
finally {
    if ($reader) { $reader.Close() }
    elseif ($fs) { $fs.Close() }

}
Move-Item -Path $outboundFilePath -Destination $archiveFilePath -Force