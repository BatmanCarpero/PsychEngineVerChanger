@echo off
:: Verificar permisos de administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: Ejecuta este script como administrador.
    pause
    exit /b
)

title Configurador Psych Engine (0.6.3 / 0.7.3)
setlocal ENABLEEXTENSIONS
setlocal ENABLEDELAYEDEXPANSION

echo =============================================
echo        CONFIGURADOR DE PSYCH ENGINE
echo =============================================
echo.
echo 1. Psych Engine 0.6.3 (Haxe 4.2.5)
echo 2. Psych Engine 0.7.3 (Haxe 4.3.2)
echo.

set /p choice=Selecciona la version (1 o 2): 

if "%choice%"=="1" (
    set ENGINE_VERSION=0.6.3
    set REQUIRED_HAXE=4.2.5
    set HAXE_EXECUTABLE=For_063.exe
    goto check_haxe
)
if "%choice%"=="2" (
    set ENGINE_VERSION=0.7.3
    set REQUIRED_HAXE=4.3.2
    set HAXE_EXECUTABLE=For_073.exe
    goto check_haxe
)

echo Opcion invalida.
pause
exit /b

:check_haxe
echo.
echo Verificando Haxe...

where haxe >nul 2>nul
if errorlevel 1 goto try_install_haxe

for /f "delims=" %%i in ('haxe --version') do set HAXEVERSION=%%i
echo Version actual de Haxe: %HAXEVERSION%

if "%HAXEVERSION%"=="%REQUIRED_HAXE%" (
    echo Haxe %REQUIRED_HAXE% ya esta activo.
    goto check_haxelib
)

echo Tienes Haxe %HAXEVERSION%, pero se requiere %REQUIRED_HAXE%.
set /p confirm=¿Quieres desinstalar la version actual de Haxe y continuar con la instalacion de la version %REQUIRED_HAXE%? (S/N): 
if /i "%confirm%"=="S" goto uninstall_haxe
goto end

:uninstall_haxe
echo =============================================
echo Desinstalando Haxe actual...
echo =============================================

:: Buscar el Uninstall.exe en la carpeta anterior a la ruta de instalación de Haxe
for /f "delims=" %%i in ('where haxe') do set HAXE_PATH=%%i
set HAXE_DIR=!HAXE_PATH:\haxe.exe=!

:: Ajustar la ruta para buscar en la carpeta anterior (C:\HaxeToolkit\)
set HAXE_PARENT_DIR=C:\HaxeToolkit

if exist "!HAXE_PARENT_DIR!\Uninstall.exe" (
    echo Ejecutando desinstalador oficial desde "!HAXE_PARENT_DIR!\Uninstall.exe"...
    start /wait "" "!HAXE_PARENT_DIR!\Uninstall.exe" /S
    timeout /t 5 >nul
) else (
    echo No se encontro el desinstalador oficial en "!HAXE_PARENT_DIR!".
    echo Intentando desinstalacion manual...
    if exist "!HAXE_PATH!" (
        del /f /q "!HAXE_PATH!" >nul 2>nul
    )
)

:: Limpiar variables de entorno
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v HAXEPATH /f >nul 2>&1
reg delete "HKCU\Environment" /v HAXEPATH /f >nul 2>&1

echo Haxe desinstalado correctamente.
goto try_install_haxe

:try_install_haxe
echo =============================================
echo Instalando Haxe %REQUIRED_HAXE%...
echo =============================================

REM Verificar si el ejecutable de Haxe existe
if not exist "%HAXE_EXECUTABLE%" (
    echo ERROR: Falta el archivo "%HAXE_EXECUTABLE%".
    echo Asegurate de que este en la misma carpeta que este script.
    pause
    exit /b
)

REM Ejecutar el instalador de Haxe como aplicación
echo Ejecutando el instalador de Haxe: %HAXE_EXECUTABLE%...
start /wait "" "%HAXE_EXECUTABLE%"
if errorlevel 1 (
    echo ERROR: Fallo la instalacion de Haxe.
    pause
    exit /b
)

REM Actualizar variables de entorno
echo Actualizando variables de entorno...
setx HAXEPATH "C:\HaxeToolkit\haxe" /M >nul
setx PATH "%PATH%;C:\HaxeToolkit\haxe" /M >nul

echo Haxe %REQUIRED_HAXE% instalado correctamente.
goto check_haxelib

:check_haxelib
where haxelib >nul 2>nul
if errorlevel 1 (
    echo ERROR: No se encontro 'haxelib'.
    pause
    exit /b
)

goto set_libs

:set_libs
echo.
echo Estableciendo librerias para Psych Engine %ENGINE_VERSION%...
echo.

if "%ENGINE_VERSION%"=="0.6.3" goto set_063
if "%ENGINE_VERSION%"=="0.7.3" goto set_073

:set_063
haxelib set flixel 5.2.2 >nul
haxelib set flixel-addons 3.0.2 >nul
haxelib set flixel-demos 2.9.0 >nul
haxelib set flixel-templates 2.6.6 >nul
haxelib set flixel-tools 1.5.1 >nul
haxelib set flixel-ui 2.5.0 >nul
haxelib git flxanimate https://github.com/ShadowMario/flxanimate.git dev >nul
haxelib set hscript 2.5.0 >nul
haxelib set hxCodec 2.6.1 >nul
haxelib set lime-samples 7.0.0 >nul
haxelib set lime 8.0.1 >nul
haxelib git linc_luajit https://github.com/superpowers04/linc_luajit.git >nul
haxelib set openfl 9.2.1 >nul
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc.git >nul
goto done

:set_073
haxelib set flixel 5.5.0 >nul
haxelib set flixel-addons 3.2.1 >nul
haxelib set flixel-tools 1.5.1 >nul
haxelib set flixel-ui 2.5.0 >nul
haxelib git flxanimate https://github.com/ShadowMario/flxanimate.git dev >nul
haxelib git hxCodec https://github.com/polybiusproxy/hxCodec.git >nul
haxelib set hxcpp-debug-server 1.2.4 >nul
haxelib git hxdiscord_rpc https://github.com/MAJigsaw77/hxdiscord_rpc.git >nul
haxelib set lime 8.0.1 >nul
haxelib git linc_luajit https://github.com/superpowers04/linc_luajit.git >nul
haxelib set openfl 9.3.2 >nul
haxelib set tjson 1.4.0 >nul

set ZIP_FILE=SScript-8.1.6.zip
set HAXELIB_PATH=%~dp0\haxelib
set EXTRACT_DIR=!HAXELIB_PATH!\SScript\8.1.6

if not exist "%ZIP_FILE%" (
    echo ERROR: Falta el archivo "%ZIP_FILE%".
    echo Asegurate de que este en la misma carpeta que este script.
    pause
    exit /b
)

if not exist "!HAXELIB_PATH!" (
    mkdir "!HAXELIB_PATH!"
)

echo Descomprimiendo SScript...
powershell -Command "Expand-Archive -Path '%ZIP_FILE%' -DestinationPath '!EXTRACT_DIR!' -Force"
if errorlevel 1 (
    echo ERROR: Fallo al descomprimir el archivo ZIP.
    pause
    exit /b
)

haxelib set SScript 8.1.6 >nul
goto done

:done
echo.
echo =============================================
echo Configuracion completada para Psych Engine %ENGINE_VERSION%!
echo.
echo Librerias instaladas en: %~dp0\haxelib
echo =============================================
pause
exit /b

:end
echo Operacion cancelada. Fin del proceso.
pause
exit /b