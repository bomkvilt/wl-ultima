@echo off
REM -------------------------------------------------------
call :cmd_%1
exit 0

REM -------------------------------------------------------
:cmd_init 
    call ".\\scripts\\init.bat"
    exit /B 0
:cmd_build
    wolframscript.exe ".\\scripts\\build.wls"
    exit /B 0
