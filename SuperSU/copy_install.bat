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

REM Make some temporary folders
..\win-adb\adb shell "mkdir /sdcard/supersu"

REM Do the copying
..\win-adb\adb push resources/chattr.pie /sdcard/supersu/
..\win-adb\adb push resources/install.sh /sdcard/supersu/
..\win-adb\adb push resources/install-recovery.sh /sdcard/supersu/
..\win-adb\adb push resources/libsupol.so /sdcard/supersu/
..\win-adb\adb push resources/su.pie /sdcard/supersu/
..\win-adb\adb push resources/Superuser.apk /sdcard/supersu/
..\win-adb\adb push resources/supolicy /sdcard/supersu/

REM internal copy
..\win-adb\adb shell "mkdir -p /data/supersu"
..\win-adb\adb shell "cp /sdcard/supersu/* /data/supersu/"

REM Do the actual installation
..\win-adb\adb shell chmod 0755 /data/supersu/install.sh
..\win-adb\adb shell "cd /data/supersu/ && sh install.sh"

REM Clean up
..\win-adb\adb shell rm -rf /sdcard/supersu
..\win-adb\adb shell rm -rf /data/supersu
..\win-adb\adb shell sync

echo Reboot your Head Unit NOW!

:END
