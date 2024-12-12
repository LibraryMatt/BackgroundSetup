# Define variables
$repoUrl = "https://github.com/LibraryMatt/BackgroundSetup/blob/main/schtask.ps1?raw=true"
$destinationPath = "C:\mbm\schtask.ps1"
$repoUrl1 = "https://github.com/LibraryMatt/BackgroundSetup/blob/main/setBackground.ps1?raw=true"
$destinationPath1 = "C:\mbm\setBackground.ps1"


# Create the destination directory if it doesn't exist
$destinationDir = Split-Path -Path $destinationPath -Parent
if (-not (Test-Path -Path $destinationDir)) {
    New-Item -ItemType Directory -Path $destinationDir -Force
}

# Create the destination directory if it doesn't exist
$destinationDir = Split-Path -Path $destinationPath1 -Parent
if (-not (Test-Path -Path $destinationDir)) {
    New-Item -ItemType Directory -Path $destinationDir -Force
}

# Download the file
Invoke-WebRequest -Uri $repoUrl -OutFile $destinationPath

# Download the file
Invoke-WebRequest -Uri $repoUrl1 -OutFile $destinationPath1


# Confirm download
if (Test-Path -Path $destinationPath) {
    Write-Host "File downloaded successfully to $destinationPath"
} else {
    Write-Host "Failed to download file."
}
