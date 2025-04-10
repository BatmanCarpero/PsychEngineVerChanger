
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
haxelib set flixel-tools 1.5.1 >nul
haxelib set flixel-ui 2.5.0 >nul
haxelib set flxanimate 3.0.4 >nul
haxelib set hscript 2.5.0 >nul
haxelib set openfl 9.2.1 >nul
haxelib set lime 8.0.1 >nul
haxelib set actuate 1.8.9 >nul

echo Estableciendo linc_luajit desde Git...
haxelib git linc_luajit https://github.com/superpowers04/linc_luajit

echo Estableciendo discord_rpc desde Git...
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc.git
goto done

:set_073
REM Librerias version 0.7.3
haxelib set flixel 5.6.1 >nul
haxelib set flixel-addons 3.2.2 >nul
haxelib set flixel-tools 1.5.1 >nul
haxelib set openfl 9.3.3 >nul
haxelib set lime 8.1.2 >nul
haxelib set actuate 1.8.9 >nul
haxelib set tjson 1.4.0 >nul
haxelib set hxvlc 1.9.2 >nul

echo Estableciendo flxanimate desde Git...
haxelib git flxanimate https://github.com/ShadowMario/flxanimate.git

echo Estableciendo linc_luajit desde Git...
haxelib git linc_luajit https://github.com/superpowers04/linc_luajit

echo Estableciendo funkin.vis desde Git...
haxelib git funkin-vis https://github.com/ShadowMario/funkin-vis

echo Estableciendo hxdiscord_rpc desde Git...
haxelib git grig https://github.com/GrigGameAudio/grig

echo Estableciendo grig.audio desde Git...
haxelib git grig https://github.com/GrigGameAudio/grig

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
