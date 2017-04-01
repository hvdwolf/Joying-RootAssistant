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
..\win-adb\adb root
..\win-adb\adb connect %1
timeout 3 > NUL

REM Make the partitions read-writable
..\win-adb\adb shell mount -o rw,remount /system
..\win-adb\adb shell mount -o rw,remount /system /system
..\win-adb\adb shell mount -o rw,remount /
..\win-adb\adb shell mount -o rw,remount / /

REM Make some temporary folders
..\win-adb\adb shell "mkdir /tmp"
..\win-adb\adb shell "mkdir /tmp/supersu"

REM Do the copying
..\win-adb\adb push resources/chattr.pie /tmp/supersu/
..\win-adb\adb push resources/install.sh /tmp/supersu/
..\win-adb\adb push resources/install-recovery.sh /tmp/supersu/
..\win-adb\adb push resources/libsupol.so /tmp/supersu/
..\win-adb\adb push resources/su.pie /tmp/supersu/
..\win-adb\adb push resources/Superuser.apk /tmp/supersu/
..\win-adb\adb push resources/supolicy /tmp/supersu/

REM  Do the actual installation
..\win-adb\adb shell chmod 0755 /tmp/supersu/install.sh
..\win-adb\adb shell "cd /tmp/supersu/ && sh install.sh"

REM Clean up
..\win-adb\adb shell rm -rf /tmp/supersu
..\win-adb\adb shell mount -o ro,remount /system
..\win-adb\adb shell mount -o ro,remount /

echo Reboot your Head Unit NOW!
