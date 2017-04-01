::You are free to tweak or modify this as you see fit,
::Just please be respectful is all I ask.

::Source: Generic Android ToolKit
::Author: Social-Design-Concepts

echo off

::called with: call "%CHECK_DEVICE%"

    set tmp=""

    set adbchk="List of devices attached"
    set adbchk2="unknown"
    set fbchk=""
    set deviceinfo=UNKNOWN

:CHECK_ADB
    set tmp=""
    for /f "tokens=1-4" %%a in ( '"%PLATFORM_TOOLS%adb" devices ^2^> nul' ) do (set tmp="%%a %%b %%c %%d")
    if /i %tmp% == %adbchk% ( goto CHECK_FB )
    if /i not %tmp% == %adbchk% ( goto CHECK_AUTHORIZATION )
    set tmp=""
GOTO:EOF

:CHECK_FB
    set tmp=""
    for /f "tokens=1-2" %%a in ( '"%PLATFORM_TOOLS%fastboot" devices ^2^> nul' ) do (set tmp="%%a %%b")
    if /i %tmp% == %fbchk% (set status=UNKNOWN&color 0C)
    if /i not %tmp% == %fbchk% (set status=FASTBOOT-ONLINE&call %default-color% &for /f "tokens=1-2" %%a in ('"%PLATFORM_TOOLS%fastboot" devices ^2^> nul' ) do ( set deviceinfo=%%a %%b))
    set tmp=""
GOTO:EOF

:CHECK_AUTHORIZATION
    set tmp=""
    for /f "tokens=1" %%a in ( '"%PLATFORM_TOOLS%adb" get-serialno ^2^> nul' ) do (set tmp="%%a")
    if /i %tmp% == %adbchk2% ( set status=UNAUTHORIZED&color 0C &for /f "tokens=1-2" %%a in ('"%PLATFORM_TOOLS%adb" devices ^2^> nul' ) do ( set deviceinfo=%%a %%b ))
    if /i not %tmp% == %adbchk2% ( set status=ADB-ONLINE&call %default-color% &for /f "tokens=1-2" %%a in ('"%PLATFORM_TOOLS%adb" devices ^2^> nul' ) do ( set deviceinfo=%%a %%b ))
    set tmp=""
GOTO:EOF

:EOF