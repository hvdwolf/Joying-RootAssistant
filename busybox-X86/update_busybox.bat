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
..\wina-adb\adb kill-server
..\wina-adb\adb connect %1
timeout 3 > NUL


REM mount system as read-write and update dpi in build.prop
..\wina-adb\adb shell "su -c mount -o remount,rw /system"
..\wina-adb\adb shell "su -c cp /system/bin/busybox /system/bin/busybox/busybox.org"
..\wina-adb\adb push ./busybox /system/bin/busybox
..\wina-adb\adb shell "su -c chmod 06755 /system/bin/busybox"
..\wina-adb\adb shell "su -c mount -o ro,remount /system"

..\wina-adb\adb kill-server


echo.
echo "It is not necessary to reboot your device now, but it will not hurt."
echo.

:END
