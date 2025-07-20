@echo off
set TASKNAME=CheckCCStatus
set SCRIPT=C:\Scripts\CheckCCStatus.ps1

echo Creating scheduled task: %TASKNAME%
schtasks /create ^
  /tn "%TASKNAME%" ^
  /tr "powershell.exe -ExecutionPolicy Bypass -File \"%SCRIPT%\"" ^
  /sc minute ^
  /mo 1 ^
  /ru SYSTEM ^
  /f

echo Task %TASKNAME% created successfully.
pause
