@echo off
setlocal

:: Define the path to the image
set "wallpaperPath=C:\mbm\TAFEDesktop.png"

:: Check if the file exists
if not exist "%wallpaperPath%" (
    echo Wallpaper file does not exist: %wallpaperPath%
    exit /b
)

:: Set the wallpaper using the registry
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "%wallpaperPath%" /f

:: Update the desktop with the new wallpaper
RUNDLL32.EXE USER32.DLL,UpdatePerUserSystemParameters

echo Wallpaper has been set to %wallpaperPath%
endlocal
