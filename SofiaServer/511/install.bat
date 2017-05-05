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

# no old "left over" connections
adb kill-server

adb connect %1

sleep 2
# Copy launcher.sh to /sdcard - then to /data directory
adb push launcher.sh /sdcard/
adb shell "su -c cp /sdcard/launcher.sh /data"
adb shell "su -c chmod 755 /data/launcher.sh" 

# Push update APK file to sdcard then /system/app
adb push Sofia-1-C9-Server-V1.0.apk /sdcard/
adb shell "su -c mount -o remount,rw /system"
adb shell "su -c cp /system/app/Sofia-1-C9-Server-V1.0/Sofia-1-C9-Server-V1.0.apk /system/app/Sofia-1-C9-Server-V1.0/Sofia-1-C9-Server-V1.0.apk.old"
adb shell "su -c cp /sdcard/Sofia-1-C9-Server-V1.0.apk /system/app/Sofia-1-C9-Server-V1.0"
adb shell "su -c chmod 644 /system/app/Sofia-1-C9-Server-V1.0/Sofia-1-C9-Server-V1.0.apk"
adb shell "su -c ls -l /system/app/Sofia-1-C9-Server-V1.0"

echo "######### PLEASE REBOOT YOUR SYSTEM ###########"

:END
