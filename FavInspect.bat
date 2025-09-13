@echo off
setlocal EnableExtensions EnableDelayedExpansion
set VERSION=2.1
set OUTDIR=%~dp0Temp
if not exist "%OUTDIR%" md "%OUTDIR%"
set TXTFILE=%OUTDIR%\%COMPUTERNAME%_report.txt
set JSONFILE=%OUTDIR%\%COMPUTERNAME%_report.json
set MDFILE=%OUTDIR%\%COMPUTERNAME%_report.md
set WEBHOOK_FILE=%~dp0webhook.url

net session >nul 2>&1
if %errorLevel% equ 0 (set ADMIN_MODE=1) else (set ADMIN_MODE=0)

echo FavInspect v%VERSION% - System Information Collector
echo ========================================
if %ADMIN_MODE% equ 0 echo [INFO] Running without admin privileges
echo Gathering system information...
echo.

set PS_CMD=powershell -NoProfile -ExecutionPolicy Bypass -Command

%PS_CMD% "systeminfo" > "%OUTDIR%\systeminfo.txt"
%PS_CMD% "Get-CimInstance Win32_Processor | Select-Object Name,NumberOfCores,NumberOfLogicalProcessors,MaxClockSpeed | Format-List" > "%OUTDIR%\cpu.txt"
%PS_CMD% "Get-CimInstance Win32_ComputerSystem | Select-Object Manufacturer,Model,TotalPhysicalMemory,UserName | Format-List" > "%OUTDIR%\computersystem.txt"
%PS_CMD% "Get-CimInstance Win32_PhysicalMemory | Select-Object Manufacturer,DeviceLocator,Capacity,Speed | Format-List" > "%OUTDIR%\memory.txt"
%PS_CMD% "Get-PhysicalDisk | Select-Object FriendlyName,MediaType,Size,BusType | Format-List" > "%OUTDIR%\diskdrive.txt"
%PS_CMD% "Get-CimInstance Win32_LogicalDisk | Select-Object DeviceID,FileSystem,Size,FreeSpace,VolumeName | Format-List" > "%OUTDIR%\logicaldisk.txt"
%PS_CMD% "Get-NetAdapter | Select-Object Name,MacAddress,LinkSpeed,Status | Format-List" > "%OUTDIR%\netadapter.txt"
%PS_CMD% "Get-NetIPConfiguration | Format-List" > "%OUTDIR%\ipconfig.txt"
%PS_CMD% "netsh wlan show interfaces" > "%OUTDIR%\wlan.txt"
%PS_CMD% "Get-CimInstance Win32_VideoController | Select-Object Name,DriverVersion,CurrentHorizontalResolution,CurrentVerticalResolution,CurrentRefreshRate | Format-List" > "%OUTDIR%\video.txt"
%PS_CMD% "Get-CimInstance Win32_DesktopMonitor | Select-Object ScreenHeight,ScreenWidth,MonitorType | Format-List" > "%OUTDIR%\monitor.txt"
%PS_CMD% "Get-TimeZone | Format-List" > "%OUTDIR%\timezone.txt"
%PS_CMD% "Get-Service | Select-Object Name,Status,StartType | Format-List" > "%OUTDIR%\services.txt"
%PS_CMD% "Get-CimInstance Win32_BIOS | Select-Object Manufacturer,SMBIOSBIOSVersion,ReleaseDate,SerialNumber | Format-List" > "%OUTDIR%\bios.txt"
%PS_CMD% "Get-CimInstance Win32_ComputerSystemProduct | Select-Object UUID,Version,Name | Format-List" > "%OUTDIR%\csproduct.txt"

(
 echo ===== FAVINSPECT SYSTEM REPORT =====
 echo Generated on: %date% %time%
 echo Computer: %COMPUTERNAME%
 echo User: %USERNAME%
 echo Admin Mode: %ADMIN_MODE%
 echo ====================================
 echo.
 echo ==== SYSTEM INFO ====
 type "%OUTDIR%\systeminfo.txt"
 echo.
 echo ==== CPU ====
 type "%OUTDIR%\cpu.txt"
 echo.
 echo ==== COMPUTER SYSTEM ====
 type "%OUTDIR%\computersystem.txt"
 echo.
 echo ==== MEMORY ====
 type "%OUTDIR%\memory.txt"
 echo.
 echo ==== DISK DRIVES ====
 type "%OUTDIR%\diskdrive.txt"
 echo.
 echo ==== LOGICAL DISKS ====
 type "%OUTDIR%\logicaldisk.txt"
 echo.
 echo ==== NETWORK ADAPTERS ====
 type "%OUTDIR%\netadapter.txt"
 echo.
 echo ==== IP CONFIGURATION ====
 type "%OUTDIR%\ipconfig.txt"
 echo.
 echo ==== WIRELESS NETWORK ====
 type "%OUTDIR%\wlan.txt"
 echo.
 echo ==== VIDEO ====
 type "%OUTDIR%\video.txt"
 echo.
 echo ==== MONITOR ====
 type "%OUTDIR%\monitor.txt"
 echo.
 echo ==== TIMEZONE ====
 type "%OUTDIR%\timezone.txt"
 echo.
 echo ==== SERVICES ====
 type "%OUTDIR%\services.txt"
 echo.
 echo ==== BIOS ====
 type "%OUTDIR%\bios.txt"
 echo.
 echo ==== PRODUCT ====
 type "%OUTDIR%\csproduct.txt"
) > "%TXTFILE%"

%PS_CMD% "$obj = @{systeminfo=Get-Content '%OUTDIR%\systeminfo.txt' -Raw;cpu=Get-Content '%OUTDIR%\cpu.txt' -Raw;computersystem=Get-Content '%OUTDIR%\computersystem.txt' -Raw;memory=Get-Content '%OUTDIR%\memory.txt' -Raw;diskdrive=Get-Content '%OUTDIR%\diskdrive.txt' -Raw;logicaldisk=Get-Content '%OUTDIR%\logicaldisk.txt' -Raw;netadapter=Get-Content '%OUTDIR%\netadapter.txt' -Raw;ipconfig=Get-Content '%OUTDIR%\ipconfig.txt' -Raw;wlan=Get-Content '%OUTDIR%\wlan.txt' -Raw;video=Get-Content '%OUTDIR%\video.txt' -Raw;monitor=Get-Content '%OUTDIR%\monitor.txt' -Raw;timezone=Get-Content '%OUTDIR%\timezone.txt' -Raw;services=Get-Content '%OUTDIR%\services.txt' -Raw;bios=Get-Content '%OUTDIR%\bios.txt' -Raw;product=Get-Content '%OUTDIR%\csproduct.txt' -Raw};$obj|ConvertTo-Json -Depth 5|Set-Content '%JSONFILE%' -Encoding UTF8"

(
 echo # FavInspect System Report
 echo ## Computer: %COMPUTERNAME%
 echo ## Generated: %date% %time%
 echo.
 echo ```text
 type "%TXTFILE%"
 echo ```
) > "%MDFILE%"

:CHOICE_MENU
cls
echo FavInspect v%VERSION% - Report Generated
echo ========================================
echo Files saved to: %OUTDIR%
echo.
echo [1] View TXT Report
echo [2] View JSON Report
echo [3] View MD Report
echo [4] Upload to Discord Webhook
echo [5] Open Output Folder
echo [6] Exit
echo.
set /p CHOICE="Select option (1-6): "

if "%CHOICE%"=="1" (
    notepad "%TXTFILE%"
    goto CHOICE_MENU
) else if "%CHOICE%"=="2" (
    notepad "%JSONFILE%"
    goto CHOICE_MENU
) else if "%CHOICE%"=="3" (
    notepad "%MDFILE%"
    goto CHOICE_MENU
) else if "%CHOICE%"=="4" (
    call :WEBHOOK_UPLOAD
    goto CHOICE_MENU
) else if "%CHOICE%"=="5" (
    explorer "%OUTDIR%"
    goto CHOICE_MENU
) else if "%CHOICE%"=="6" (
    exit
) else (
    echo Invalid choice. Please try again.
    timeout /t 2 >nul
    goto CHOICE_MENU
)

:WEBHOOK_UPLOAD
if exist "%WEBHOOK_FILE%" (
    set /p WEBHOOK_URL=<"%WEBHOOK_FILE%"
) else (
    echo Enter your Discord Webhook URL:
    set /p WEBHOOK_URL="URL: "
    echo %WEBHOOK_URL% > "%WEBHOOK_FILE%"
)

echo Uploading to Discord webhook...
%PS_CMD% "$webhook='%WEBHOOK_URL%';$content=Get-Content '%TXTFILE%' -Raw;$boundary=[System.Guid]::NewGuid().ToString();$bodyLines=@();$bodyLines+='--'+$boundary;$bodyLines+='Content-Disposition: form-data; name=\"file\"; filename=\"report.txt\"';$bodyLines+='Content-Type: text/plain';$bodyLines+='';$bodyLines+=$content;$bodyLines+='--'+$boundary+'--';$body=[System.Text.Encoding]::UTF8.GetBytes($bodyLines -join \"`r`n\");Invoke-RestMethod -Uri $webhook -Method Post -ContentType \"multipart/form-data; boundary=$boundary\" -Body $body"

if errorlevel 1 (
    echo Failed to upload to webhook
) else (
    echo Report successfully uploaded to Discord
)
timeout /t 3 >nul
exit /b 0
