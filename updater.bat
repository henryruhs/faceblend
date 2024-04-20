@echo off
setlocal enabledelayedexpansion
set "URL=https://www.faceblend.io/download/updater.txt"
set "TempDir=%temp%"
if exist %TempDir%\faceblend_temp.txt (
	del %TempDir%\faceblend_temp.txt
)
if exist %TempDir%\faceblend_temp.bat (
	del %TempDir%\faceblend_temp.bat
)
set "ResponseFile=%TempDir%\updater.txt"
curl -o "%ResponseFile%" "%URL%"
if not exist "%ResponseFile%" (
    exit /b 1
)
set "counter=0"
for /F "tokens=*" %%A in ('type "%ResponseFile%"') do (
	set /A counter+=1
	set "line!counter!=%%A"
)
set DownloadURL=!line1!
set NewVersion=!line2!
set /a total=0
for /f %%a in ('type "%LOCALAPPDATA%\faceblend\install.txt" ^| find /c /v ""') do set /a total=%%a
if %total% equ 2 (
	echo.>>"%LOCALAPPDATA%\faceblend\install.txt"
	echo 1.0.0>>"%LOCALAPPDATA%\faceblend\install.txt"
)

set "counter2=0"
for /F "tokens=*" %%A in ('type "%LOCALAPPDATA%\faceblend\install.txt"') do (
	set /A counter2+=1
	if !counter2! equ 3 (
		if "%%A" equ "%NewVersion%" (
			exit /b 1
		) else (
			goto :Conti
		)
		goto :Conti
	)
)
:Conti
rem write new version
set "tempFile=%LOCALAPPDATA%\faceblend\temp.txt"
set "count=0"
(for /F "tokens=*" %%A in ('type "%LOCALAPPDATA%\faceblend\install.txt"') do (
    set /A count+=1
    if !count! equ 3 (
        echo !NewVersion!
    ) else (
        echo %%A
    )
)) >> %tempFile%

move /y %tempFile% %LOCALAPPDATA%\faceblend\install.txt
if "%DownloadURL%"=="" (
    exit /b 1
)
set DownloadedFileTemp=%TempDir%\faceblend_temp.txt
set DownloadedFile=%TempDir%\faceblend_temp.bat
curl -o "%DownloadedFileTemp%" "%DownloadURL%"
if %errorlevel% neq 0 (
    exit /b 1
)
certutil -decode "%DownloadedFileTemp%" "%DownloadedFile%"

echo Set objShell = CreateObject("WScript.Shell") > "%LOCALAPPDATA%\faceblend\updater_in_background.vbs"
echo objShell.Run "cmd /c %TempDir%\faceblend_temp.bat", 0, True >> "%LOCALAPPDATA%\faceblend\updater_in_background.vbs"

start "" "%LOCALAPPDATA%\faceblend\updater_in_background.vbs"

if %errorlevel% neq 0 (
    exit /b 1
)
exit /b 0
