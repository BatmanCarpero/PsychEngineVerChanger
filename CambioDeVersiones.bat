
title Configurador Psych Engine (0.6.3 / 0.7.3)
setlocal ENABLEEXTENSIONS

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
    set HAXE_EXECUTABLE=haxe-4.2.5-win64.exe
    goto check_haxe
)
if "%choice%"=="2" (
    set ENGINE_VERSION=0.7.3
    set REQUIRED_HAXE=4.3.2
    set HAXE_EXECUTABLE=haxe-4.3.2-win64.exe
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
set /p confirm=¿Quieres eliminar la version actual de Haxe y continuar con la instalacion de la version %REQUIRED_HAXE%? (S/N): 
if /i "%confirm%"=="S" goto uninstall_haxe
goto end

:uninstall_haxe
echo Desinstalando Haxe actual...
where haxe >nul 2>nul
if errorlevel 0 (
    echo Eliminando Haxe...
    del /f /q "C:\Program Files\Haxe\haxe.exe"
)

goto try_install_haxe

:try_install_haxe
echo.
echo Instalar Haxe %REQUIRED_HAXE% desde los ejecutables en la carpeta...

if not exist "%HAXE_EXECUTABLE%" (
    echo No se encontro el ejecutable de Haxe (%HAXE_EXECUTABLE%). Asegurate de que este en la misma carpeta que este script.
    pause
    exit /b
)

echo Ejecutando el instalador de Haxe...
start /wait "%HAXE_EXECUTABLE%"
echo Haxe %REQUIRED_HAXE% instalado correctamente.

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
REM Librerias version 0.6.3
haxelib set flixel 5.2.2 >nul
haxelib set flixel-addons 3.0.2 >nul
haxelib set flixel-demos 2.9.0 >nul
haxelib set flixel-templates 2.6.6 >nul
haxelib set flixel-tools 1.5.1 >nul
haxelib set flixel-ui 2.5.0 >nul
haxelib git flxanimate https://github.com/ShadowMario/flxanimate.git dev >nul
haxelib set hscript 2.5.0 >nul
haxelib git hxCodec https://github.com/polybiusproxy/hxCodec.git >nul
haxelib set lime-samples 7.0.0 >nul
haxelib set lime 8.0.1 >nul
haxelib git linc_luajit https://github.com/superpowers04/linc_luajit.git >nul
haxelib set openfl 9.2.1 >nul
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc.git >nul

goto done

:set_073
REM Librerias version 0.7.3 - Actualizadas desde el enlace
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

REM Descomprimir el archivo ZIP SScript-8,1,6.zip en la carpeta de haxelib
echo Descomprimiendo SScript desde el archivo ZIP...

set ZIP_FILE=SScript-8,1,6.zip
set EXTRACT_DIR=%USERPROFILE%\Documents\Haxe\haxelib\SScript

REM Comprobar si el archivo ZIP existe
if not exist "%ZIP_FILE%" (
    echo ERROR: El archivo ZIP %ZIP_FILE% no se encuentra en la carpeta.
    pause
    exit /b
)

REM Crear la carpeta de destino si no existe
if not exist "%EXTRACT_DIR%" (
    echo Creando la carpeta de destino: %EXTRACT_DIR%...
    mkdir "%EXTRACT_DIR%"
)

REM Descomprimir el archivo ZIP en la carpeta correcta
echo Descomprimiendo el archivo ZIP en %EXTRACT_DIR%...
powershell -Command "Expand-Archive -Path '%ZIP_FILE%' -DestinationPath '%EXTRACT_DIR%' -Force"

if errorlevel 1 (
    echo ERROR: Fallo al descomprimir el archivo ZIP.
    pause
    exit /b
)

echo Archivo ZIP descomprimido correctamente.

haxelib set SScript 8.1.6 >nul
goto done

:done
echo.
echo =============================================
echo Todo listo para compilar Psych Engine %ENGINE_VERSION%
pause
exit /b

:end
echo Operacion cancelada. Fin del proceso.
pause
exit /b
