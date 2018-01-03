@echo off

REM check permissions: running as Administrator?
fsutil dirty query C: >nul 2>&1
if %errorLevel% NEQ 0 (
        echo.
        echo You did not start this script in an Administrator command box.
        echo Open an Administrator command prompt and restart this script.
        echo.
        GOTO END
)

REM check for ip-address
if "%1"=="" (
        echo.
        echo no argument given. I need the ip-address. Restart the script with "copy_install.bat ip-address".
        echo.
        GOTO END
)

REM Setup the connection
adb kill-server
adb connect %1
timeout 3 > NUL
adb root
adb connect %1
timeout 3 > NUL

REM Make the partitions read-writable
adb shell mount -o rw,remount /system

REM copy necessary files
adb shell "mkdir -p /data/seSuperuser"
adb push su /data/seSuperuser/su
adb push jy-setup.sh /data/seSuperuser/jy-setup.sh
adb push Superuser.apk /data/seSuperuser/Superuser.apk
adb push install-recovery.sh /data/seSuperuser/install-recovery.sh

REM Do the actual installation
adb shell chmod 0755 /data/seSuperuser/jy-setup.sh
adb shell "cd /data/seSuperuser && sh jy-setup.sh"

REM Clean up
adb shell rm -rf /data/seSuperuser
adb shell sync

echo Reboot your Head Unit NOW!


:END

