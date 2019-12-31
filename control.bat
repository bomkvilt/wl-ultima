@echo off

set command=%1
       if "%command%" == "init"  ( call :do_init
) else if "%command%" == "build" ( call :do_build
) else call :on_incorrect_cammand
exit 0

REM -------------------------------------------------------
:do_init
    call "./scripts/init.bat"
    exit /B 0

:do_build
    exit /B 0

:on_incorrect_cammand
    echo incorrect command
    exit 1
