# Specify the path to your PowerShell script
$scriptPath = "C:\mbm\setBackground.ps1"

# Create a new scheduled task
$action = New-ScheduledTaskAction -Execute "$scriptPath"
$trigger = New-ScheduledTaskTrigger -AtLogOn
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM"
$settings = New-ScheduledTaskSettingsSet -AllowHardTerminate $true

# Register the task
Register-ScheduledTask -Action $action -Trigger $trigger -Principal $principal -Settings $settings -TaskName "YourTaskName"
