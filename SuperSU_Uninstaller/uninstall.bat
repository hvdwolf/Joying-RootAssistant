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

REM Make sure the original su and app_process32 is available
adb push -p su /sdcard/su
adb push -p app_process32 /sdcard/app_process32 

REM Make the partitions read-writable
adb shell mount -o rw,remount /system


REM /system/bin
REM lrwxrwxrwx root     root              2017-10-05 19:04 app_process -> /system/xbin/daemonsu
REM lrwxrwxrwx root     root              2017-10-05 19:04 app_process32 -> /system/xbin/daemonsu
REM -rwxr-xr-x root     shell       17884 2008-08-01 14:00 app_process32_original
REM -rwxr-xr-x root     shell       17884 2017-10-05 19:04 app_process_init

adb shell "rm /system/bin/app_process"
adb shell "rm /system/bin/app_process32"
adb shell "cp /sdcard/app_process32 /system/bin/app_process32"
adb shell "ln -s /system/binapp_process32 /system/binapp_process"
adb shell "chmod 0755 /system/bin/app_process32"
adb shell "chown 0:2000 /system/bin/app_process32"
adb shell "toybox chcon u:object_r:zygote_exec:s0 /system/bin/app_process32"

REM /system/lib
REM -rw-r--r--    1 0        0           346536 Oct  5 17:04 libsupol.so
adb shell "rm -rf /system/lib/libsupol.so"

REM /system/xbin
REM -rwxr-xr-x    1 0        0           104012 Oct  5 17:04 su
REM -rwxr-xr-x    1 0        0            46416 Oct  5 17:04 supolicy
REM -rwxr-xr-x    1 0        0           104012 Oct  5 17:04 daemonsu
adb shell "rm -rf /system/xbin/su"
adb shell "cp /sdcard/su /system/xbin/su"
adb shell "chmod 0755 /system/xbin/su"
adb shell "chown 0:0 /system/xbin/su"
adb shell "rm -rf /system/xbin/supolicy"
adb shell "rm -rf /system/xbin/daemonsu"

adb shell "rm -rf /system/bin/install-recovery.sh"
adb shell "rm -rf /system/etc/install-recovery.sh"

REM /system/app/SuperSU/SuperSU.apk
adb shell "rm -rf /system/app/SuperSU"

echo Reboot your Head Unit NOW!


:END

