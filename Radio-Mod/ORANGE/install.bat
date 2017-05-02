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

REM Now do the rooting actions
..\..\win-adb\adb kill-server
..\..\win-adb\adb connect %1


timeout 3 > NUL

REM Push update APK file to sdcard then /system/app
..\..\win-adb\adb push JY-1-C9-Radio-V1.0.apk /sdcard/
..\..\win-adb\adb shell "su -c am force-stop com.syu.radio"
..\..\win-adb\adb shell "su -c mount -o remount,rw /system"
..\..\win-adb\adb shell "su -c cp /system/app/JY-1-C9-Radio-V1.0/JY-1-C9-Radio-V1.0.apk /system/app/JY-1-C9-Radio-V1.0/JY-1-C9-Radio-V1.0.apk.old"
..\..\win-adb\adb shell "su -c cp /sdcard/JY-1-C9-Radio-V1.0.apk /system/app/JY-1-C9-Radio-V1.0"
..\..\win-adb\adb shell "su -c chmod 644 /system/app/JY-1-C9-Radio-V1.0/JY-1-C9-Radio-V1.0.apk"
..\..\win-adb\adb shell "su -c ls -l /system/app/JY-1-C9-Radio-V1.0"

..\..\win-adb\adb kill-server

echo.
echo "You need to reboot your device now."
echo.

:END