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
        echo no argument given. I need the ip-address. Restart the script with "install.bat ip-address".
        echo.
        GOTO END
)

REM Setup the connection
adb kill-server
adb connect %1
adb root
adb connect %1
timeout 3 > NUL

REM Make the partitions read-writable
adb shell mount -o rw,remount /system
adb shell mount -o rw,remount /system /system
adb shell mount -o rw,remount /
adb shell mount -o rw,remount / /

REM Make some temporary folders
adb shell "mkdir /tmp"
adb shell "mkdir /tmp/supersu"

REM Do the copying
adb push resources/chattr.pie /tmp/supersu/
adb push resources/install.sh /tmp/supersu/
adb push resources/install-recovery.sh /tmp/supersu/
adb push resources/libsupol.so /tmp/supersu/
adb push resources/su.pie /tmp/supersu/
adb push resources/Superuser.apk /tmp/supersu/
adb push resources/supolicy /tmp/supersu/

REM  Do the actual installation
adb shell chmod 0755 /tmp/supersu/install.sh
adb shell "cd /tmp/supersu/ && sh install.sh"

REM Clean up
adb shell rm -rf /tmp/supersu
adb shell mount -o ro,remount /system
adb shell mount -o ro,remount /

echo Reboot your Head Unit NOW!
