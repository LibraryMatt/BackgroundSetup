# Define variables
$repoUrl = "https://github.com/LibraryMatt/BackgroundSetup/blob/main/TAFEDesktop.png?raw=true"
$destinationPath1 = "C:\mbm\TAFEDesktop.png"

# Create the destination directory if it doesn't exist
$destinationDir = Split-Path -Path $destinationPath1 -Parent
if (-not (Test-Path -Path $destinationDir)) {
    New-Item -ItemType Directory -Path $destinationDir -Force
}

# Download the file
Invoke-WebRequest -Uri $repoUrl -OutFile $destinationPath1

# Confirm download
if (Test-Path -Path $destinationPath1) {
    Write-Host "File downloaded successfully to $destinationPath1"
} else {
    Write-Host "Failed to download file."
}

# Wait for 5 seconds
Start-Sleep -Seconds 5

# Define variables
$batFileUrl = "https://raw.githubusercontent.com/LibraryMatt/BackgroundSetup/refs/heads/main/SetWallpaper.bat"  # Replace with the actual URL of your .bat file
$destinationPath = "C:\mbm\SetWallpaper.bat"

# Create the destination directory if it doesn't exist
$destinationDir = Split-Path -Path $destinationPath -Parent
if (-not (Test-Path -Path $destinationDir)) {
    New-Item -ItemType Directory -Path $destinationDir -Force
}

# Download the batch file with error handling
try {
    Invoke-WebRequest -Uri $batFileUrl -OutFile $destinationPath
    Write-Host "Batch file downloaded successfully to $destinationPath"
} catch {
    Write-Error "Error downloading batch file: $_"
    exit
}

# Execute the downloaded batch file
try {
    Start-Process -FilePath $destinationPath -Wait
    Write-Host "Batch file executed successfully."
} catch {
    Write-Error "Error executing batch file: $_"
}
