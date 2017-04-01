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

REM Connect to android unit
adb kill-server
adb connect %1
timeout 3 > NUL


REM mount system as read-write and update dpi in build.prop
adb shell "su -c mount -o remount,rw /system"
adb shell "su -c cp /system/bin/busybox /system/bin/busybox/busybox.org"
adb push ./busybox /system/bin/busybox
adb shell "su -c chmod 06755 /system/bin/busybox"
adb shell "su -c mount -o ro,remount /system"

adb kill-server


echo.
echo "You need to reboot your device now."
echo.

:END