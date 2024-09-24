# Define variables
$repoUrl = "https://github.com/LibraryMatt/BackgroundSetup/blob/main/TAFEDesktop.png?raw=true"
$destinationPath = "C:\Windows\Web\Wallpaper\TAFEDesktop.png"

# Create the destination directory if it doesn't exist
$destinationDir = Split-Path -Path $destinationPath -Parent
if (-not (Test-Path -Path $destinationDir)) {
    New-Item -ItemType Directory -Path $destinationDir -Force
}

# Download the file with error handling
try {
    Invoke-WebRequest -Uri $repoUrl -OutFile $destinationPath -ErrorAction Stop
    Write-Host "File downloaded successfully to $destinationPath"
} catch {
    Write-Host "Failed to download file: $_"
    exit
}

# Function to set wallpaper for all users
function Set-WallpaperForAllUsers {
    param (
        [string]$path
    )

    # Load User32.dll
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

# Call the function to set the wallpaper for all users
Set-WallpaperForAllUsers -path $destinationPath

# Set the registry key for all users
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Personalization"
Set-ItemProperty -Path $registryPath -Name "DesktopWallpaper" -Value $destinationPath
