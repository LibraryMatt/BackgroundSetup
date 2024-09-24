# Define variables
$repoUrl = "https://github.com/LibraryMatt/BackgroundSetup/blob/main/TAFEDesktop.png?raw=true"
$destinationPath = "C:\mbm\TAFEDesktop.png"

# Create the destination directory if it doesn't exist
$destinationDir = Split-Path -Path $destinationPath -Parent
if (-not (Test-Path -Path $destinationDir)) {
    New-Item -ItemType Directory -Path $destinationDir -Force
}

# Download the file with error handling
try {
    Invoke-WebRequest -Uri $repoUrl -OutFile $destinationPath
} catch {
    Write-Error "Error downloading file: $_"
    exit
}

# Confirm download
if (Test-Path -Path $destinationPath) {
    Write-Host "File downloaded successfully to $destinationPath"
} else {
    Write-Host "Failed to download file."
    exit
}

# Get the current user's profile path
$currentUserProfilePath = [System.Environment]::GetFolderPath('UserProfile')
$wallpaperPath = Join-Path -Path $currentUserProfilePath -ChildPath "Pictures\TAFEDesktop.png"

# Move the downloaded file to the current user's Pictures directory
Move-Item -Path $destinationPath -Destination $wallpaperPath -Force

# Function to set wallpaper for the currently logged-in user
function Set-WallpaperForCurrentUser {
    param (
        [string]$path
    )

    # Define the User32 class for setting the wallpaper
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
}

# Call the function to set the wallpaper for the currently logged-in user
Set-WallpaperForCurrentUser -path $wallpaperPath
