::You are free to tweak or modify this as you see fit,
::Just please be respectful is all I ask.

::Source: Generic Android ToolKit
::Author: Social-Design-Concepts

@echo off

::called with: call "%PRINT_DEVICE%"
:DEVICE_INFO
    echo.
    echo. DEVICE STATUS: %status%
    echo.
    echo. DEVICE INFORMATION: %deviceinfo%
    echo.
    echo =======================================================================
    echo.
    echo.                [ PRESS ENTER TO REFRESH DEVICE STATUS ]
GOTO:EOF
