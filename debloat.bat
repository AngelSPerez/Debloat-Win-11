::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAnk
::fBw5plQjdG8=
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSjk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+IeA==
::cxY6rQJ7JhzQF1fEqQJhZks0
::ZQ05rAF9IBncCkqN+0xwdVsFAlTi
::ZQ05rAF9IAHYFVzEqQIULRlYQwWWfFyzCPVNuYg=
::eg0/rx1wNQPfEVWB+kM9LVsJDCCHPme1B6Fc3+H1r7vWwg==
::fBEirQZwNQPfEVWB+kM9LVsJDCCHPme1B6Fc3+H1r7vWwg==
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJGyX8VAjFDp6azimOXixEroM1Mz+7eaIo1ldY+sxON6KlLGWJYA=
::YB416Ek+Zm8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
chcp 65001 >nul
title Debloat Windows 11 - Menu Completo
color 0A

:: ================================
:: COMPROBAR ADMINISTRADOR
:: ================================
net session >nul 2>&1
if %errorLevel% neq 0 (
 echo.
 echo [ERROR] Ejecuta este script como ADMINISTRADOR.
 pause
 exit /b
)

:: ================================
:: MENU PRINCIPAL
:: ================================
:MENU
cls
echo =====================================================
echo           DEBLOAT WINDOWS 11 - MENU
echo =====================================================
echo.
echo [1] BASICO
echo     - Elimina apps basura comunes
echo     - Elimina OneDrive
echo     - NO toca servicios criticos
echo.
echo [2] INTERMEDIO (RECOMENDADO)
echo     - Incluye TODO lo del BASICO
echo     - Quita Cortana, Bing, Skype
echo     - Desactiva Widgets
echo.
echo [3] AVANZADO
echo     - Incluye TODO lo del INTERMEDIO
echo     - Reduce telemetria
echo     - Desactiva servicios no esenciales
echo.
echo [4] EXTREMO (RIESGO)
echo     - Incluye TODO lo del AVANZADO
echo     - Elimina casi todas las apps UWP
echo     - NO elimina Microsoft Store
echo.
echo [5] GAMING
echo     - Sistema optimizado para juegos
echo     - Elimina OneDrive y DVR
echo.
echo [6] REVERTIR CAMBIOS
echo     - Restaura configuraciones y servicios
echo.
echo [7] Crear SOLO punto de restauracion
echo [0] Salir
echo.
set /p opt=Selecciona una opcion:

if "%opt%"=="1" goto BASIC
if "%opt%"=="2" goto INTERMEDIATE
if "%opt%"=="3" goto ADVANCED
if "%opt%"=="4" goto EXTREME
if "%opt%"=="5" goto GAMING
if "%opt%"=="6" goto REVERT
if "%opt%"=="7" goto RESTOREPOINT
if "%opt%"=="0" exit
goto MENU

:: ================================
:: RESTORE POINT
:: ================================
:RESTOREPOINT
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"Enable-ComputerRestore -Drive 'C:\'; Checkpoint-Computer -Description 'Antes_Debloat_Win11' -RestorePointType MODIFY_SETTINGS"
echo Punto de restauracion creado.
pause
goto MENU

:: ================================
:: MODOS
:: ================================
:BASIC
call :CREATE_RP
call :RUNPS BASIC
pause
goto MENU

:INTERMEDIATE
call :CREATE_RP
call :RUNPS INTERMEDIATE
pause
goto MENU

:ADVANCED
call :CREATE_RP
call :RUNPS ADVANCED
pause
goto MENU

:EXTREME
cls
echo MODO EXTREMO - ADVERTENCIA
echo Quitara casi todo excepto Microsoft Store
echo.
echo Escribe CONFIRMO para continuar:
set /p conf=>
if not "%conf%"=="CONFIRMO" goto MENU
call :CREATE_RP
call :RUNPS EXTREME
pause
goto MENU

:GAMING
call :CREATE_RP
call :RUNPS GAMING
pause
goto MENU

:REVERT
call :CREATE_RP
call :RUNPS REVERT
pause
goto MENU

:CREATE_RP
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"Checkpoint-Computer -Description 'Antes_Debloat_Win11' -RestorePointType MODIFY_SETTINGS"
exit /b

:: ================================
:: POWERSHELL CENTRAL
:: ================================
:RUNPS
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"param([string]$mode)

Add-Type -AssemblyName System.Windows.Forms
$ErrorActionPreference = 'Stop'
$ok = $true
$msg = ''

try {

 function Remove-Apps($apps){
  foreach($a in $apps){
   Get-AppxPackage -Name $a -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue
   Get-AppxProvisionedPackage -Online | Where {$_.DisplayName -like $a} |
    Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
  }
 }

 function Remove-OneDrive {
  taskkill /f /im OneDrive.exe >nul 2>&1
  if (Test-Path '$env:SystemRoot\SysWOW64\OneDriveSetup.exe') {
   Start-Process '$env:SystemRoot\SysWOW64\OneDriveSetup.exe' '/uninstall' -Wait
  }
  if (Test-Path '$env:SystemRoot\System32\OneDriveSetup.exe') {
   Start-Process '$env:SystemRoot\System32\OneDriveSetup.exe' '/uninstall' -Wait
  }
  Remove-Item '$env:UserProfile\OneDrive' -Recurse -Force -ErrorAction SilentlyContinue
  Remove-Item 'HKCU:\Software\Microsoft\OneDrive' -Recurse -Force -ErrorAction SilentlyContinue
  reg add 'HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive' /v DisableFileSyncNGSC /t REG_DWORD /d 1 /f | Out-Null
 }

 function Enable-Service($s){
  sc config $s start= auto >nul
  sc start $s >nul
 }

 if ($mode -ne 'REVERT') {

  Remove-OneDrive
  Remove-Apps @('*Xbox*','*Solitaire*','*BingWeather*')

  if ($mode -in 'INTERMEDIATE','ADVANCED','EXTREME','GAMING') {
   Remove-Apps @('*Cortana*','*Skype*','*Bing*')
   reg add 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' `
    /v TaskbarDa /t REG_DWORD /d 0 /f | Out-Null
  }

  if ($mode -in 'ADVANCED','EXTREME') {
   reg add 'HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection' `
    /v AllowTelemetry /t REG_DWORD /d 0 /f | Out-Null
   sc config DiagTrack start= disabled >nul
   sc stop DiagTrack >nul
  }

  if ($mode -eq 'EXTREME') {
   Remove-Apps @('*Teams*','*MixedReality*','*YourPhone*','*Clipchamp*')
   foreach ($s in 'WSearch','SysMain','Fax','MapsBroker') {
    sc config $s start= disabled >nul
    sc stop $s >nul
   }
  }

  if ($mode -eq 'GAMING') {
   sc config SysMain start= disabled >nul
   sc stop SysMain >nul
   reg add 'HKCU\System\GameConfigStore' /v GameDVR_Enabled /t REG_DWORD /d 0 /f | Out-Null
  }

 } else {

  reg delete 'HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive' /f 2>nul
  Enable-Service 'DiagTrack'
  Enable-Service 'WSearch'
  Enable-Service 'SysMain'
 }

} catch {
 $ok = $false
 $msg = $_.Exception.Message
}

if ($ok) {
 [System.Windows.Forms.MessageBox]::Show(
  'Proceso completado correctamente. Reinicia el sistema.',
  'EXITO',
  'OK',
  'Information'
 )
} else {
 [System.Windows.Forms.MessageBox]::Show(
  'ERROR:`n' + $msg,
  'ERROR',
  'OK',
  'Error'
 )
}"
exit /b
