@echo off
REM -------------------------------------------------------
call :cmd_%1
exit 0

REM -------------------------------------------------------
:cmd_build
    wolframscript.exe -script .\build\scripts\main.m
    exit /B 0
