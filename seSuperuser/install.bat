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
..\win-adb\adb kill-server
..\win-adb\adb connect %1
timeout 3 > NUL
..\win-adb\adb root
..\win-adb\adb connect %1
timeout 3 > NUL

REM Make the partitions read-writable
..\win-adb\adb shell mount -o rw,remount /system

REM copy necessary files
..\win-adb\adb shell "mkdir -p /data/seSuperuser"
..\win-adb\adb push resources/su /data/seSuperuser
..\win-adb\adb push resources/jy-setup.sh /data/seSuperuser

REM Do the actual installation
..\win-adb\adb shell chmod 0755 /data/seSuperuser/jy-setup.sh
..\win-adb\adb shell "cd /data/seSuperuser && sh jy-setup.sh"

REM Clean up
..\win-adb\adb shell rm -rf /data/seSuperuser
..\win-adb\adb shell sync

echo Reboot your Head Unit NOW!
echo After the reboot go to the play store and download "phh's SuperUser"
echo or simply go to https://play.google.com/store/apps/details?id=me.phh.superuser

:END

