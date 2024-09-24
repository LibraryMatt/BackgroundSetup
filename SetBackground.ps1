# Define variables
$batFileUrl = "https://github.com/LibraryMatt/BackgroundSetup/blob/main"  # Replace with the actual URL of your .bat file
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
