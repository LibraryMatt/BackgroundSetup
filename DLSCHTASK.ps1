# Define variables
$repoUrl = "https://github.com/LibraryMatt/BackgroundSetup/blob/main/schtask.ps1?raw=true"
$destinationPath = "C:\mbm\schtask.ps1"

# Create the destination directory if it doesn't exist
$destinationDir = Split-Path -Path $destinationPath -Parent
if (-not (Test-Path -Path $destinationDir)) {
    New-Item -ItemType Directory -Path $destinationDir -Force
}

# Download the file
Invoke-WebRequest -Uri $repoUrl -OutFile $destinationPath

# Confirm download
if (Test-Path -Path $destinationPath) {
    Write-Host "File downloaded successfully to $destinationPath"
} else {
    Write-Host "Failed to download file."
}
