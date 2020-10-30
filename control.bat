@echo off
REM -------------------------------------------------------
call :cmd_%1
exit 0

REM -------------------------------------------------------
:cmd_build
    wolframscript.exe .\build\scripts\build.wls
    wolframscript.exe .\build\scripts\install.wls
    exit /B 0
