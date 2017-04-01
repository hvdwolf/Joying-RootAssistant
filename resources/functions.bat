::You are free to tweak or modify this as you see fit,
::Just please be respectful is all I ask.

::Source: Generic Android ToolKit
::Author: Social-Design-Concepts

echo = off
set default-color=color 0B

set FUNCTION=""
set FUNCTION=%~dp0 
for %%f in ("%FUNCTION%") do set FUNCTION=%%~sf

::set misc stuff for the basic toolKIT
set PRINT_DEVICE=%FUNCTION%print-device.bat
set CHECK_DEVICE=%FUNCTION%check-device.bat

set PLATFORM_TOOLS=%FUNCTION%win-adb\

::set starting device status.
set status=UNKNOWN
