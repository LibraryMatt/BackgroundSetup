# Check if running as Administrator
function Test-IsElevated {
    return ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Relaunch script with elevated permissions if not already elevated
if (-not (Test-IsElevated)) {
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

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

# Function to set wallpaper for all users
function Set-WallpaperForAllUsers {
    param (
        [string]$path
    )

    # Set the wallpaper for the current user
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

    # Set wallpaper for the current user
    $user32::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $path, $SPIF_UPDATEINIFILE -bor $SPIF_SENDCHANGE)

    # Update the registry for all users
    $regPath = "HKU\.DEFAULT\Control Panel\Desktop"
    Set-ItemProperty -Path $regPath -Name "Wallpaper" -Value $path
    Set-ItemProperty -Path $regPath -Name "TileWallpaper" -Value "0"
    Set-ItemProperty -Path $regPath -Name "WallpaperStyle" -Value "2"  # 2 for fill, 1 for stretch, etc.
}

# Call the function to set the wallpaper
Set-WallpaperForAllUsers -path $destinationPath
