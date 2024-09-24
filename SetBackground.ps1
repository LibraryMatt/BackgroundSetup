# Define variables
$repoUrl = "https://github.com/LibraryMatt/BackgroundSetup/blob/main/TAFEDesktop.png?raw=true"
$destinationPath = "C:\mbm\TAFEDesktop.png"

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

# Wait for 15 seconds
Start-Sleep -Seconds 15

# Path to the image file
$imagePath = $destinationPath

# Function to set wallpaper
function Set-Wallpaper {
    param (
        [string]$path
    )
    $user32 = Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    public class User32 {
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
    }
"@ -PassThru

    # Constants
    $SPI_SETDESKWALLPAPER = 20
    $SPIF_UPDATEINIFILE = 1
    $SPIF_SENDCHANGE = 2

    # Set wallpaper
    $user32::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $path, $SPIF_UPDATEINIFILE -bor $SPIF_SENDCHANGE)
}

# Call the function to set the wallpaper
Set-Wallpaper -path $imagePath
