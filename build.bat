@echo off

SET BUILD_DIR=build
SET PUBLISH_DIR=dist
SET ARTIFACT=Gif123.exe

if exist %BUILD_DIR% rmdir /s/q %BUILD_DIR%

if exist %PUBLISH_DIR% rmdir /s/q %PUBLISH_DIR%

md %BUILD_DIR%

7z x -aoa .\buildtools\aardio.7z -o.\build

copy buildtools\USR.CFG build\config\USR.CFG
copy buildtools\init.aardio build\extensions\trigger\init.aardio
copy buildtools\init-user.aardio build\extensions\trigger\init-user.aardio

echo project_mru=%cd%\default.aproj >> build\config\USR.CFG

start /b build\aardio.exe

set /a MAX_TIMES = 100
set /a times = 0

:loop
set /a times += 1

if %times% GTR %MAX_TIMES% (
    echo "build error: timeout";
    goto end;
)

if exist %PUBLISH_DIR%\%ARTIFACT% (
    echo "build success";
    goto end;
)

timeout /T 3

goto loop
:end

tskill aardio

@REM pause
