#!/bin/bash


# ipaddress given?
if [ "$1" = "" ]
then
        echo "Provide IP Address to connect to for adb"
        echo "for example:  ./copy_install.sh 192.168.178.52"
        exit
fi
set -x


# Setup the connection
adb kill-server
adb connect $1
sleep 2
adb root
adb connect $1
sleep 2


#Make sure the original su and app_process32 is available
adb push su /sdcard/su
adb push app_process32 /sdcard/app_process32 

# Make the partitions read-writable
adb shell mount -o rw,remount /system


#/system/bin
#lrwxrwxrwx root     root              2017-10-05 19:04 app_process -> /system/xbin/daemonsu
#lrwxrwxrwx root     root              2017-10-05 19:04 app_process32 -> /system/xbin/daemonsu
#-rwxr-xr-x root     shell       17884 2008-08-01 14:00 app_process32_original
#-rwxr-xr-x root     shell       17884 2017-10-05 19:04 app_process_init

adb shell "rm /system/bin/app_process"
adb shell "rm /system/bin/app_process32"
adb shell "cp /sdcard/app_process32 /system/bin/app_process32"
adb shell "ln -s /system/binapp_process32 /system/binapp_process"
adb shell "chmod 0755 /system/bin/app_process32"
adb shell "chown 0:2000 /system/bin/app_process32"
adb shell "toybox chcon u:object_r:zygote_exec:s0 /system/bin/app_process32"

#/system/lib
#-rw-r--r--    1 0        0           346536 Oct  5 17:04 libsupol.so
adb shell "rm -rf /system/lib/libsupol.so"

#/system/xbin
#-rwxr-xr-x    1 0        0           104012 Oct  5 17:04 su
#-rwxr-xr-x    1 0        0            46416 Oct  5 17:04 supolicy
#-rwxr-xr-x    1 0        0           104012 Oct  5 17:04 daemonsu
adb shell "rm -rf /system/xbin/su"
adb shell "cp /sdcard/su /system/xbin/su"
adb shell "chmod 0755 /system/xbin/su"
adb shell "chown 0:0 /system/xbin/su"
adb shell "rm -rf /system/xbin/supolicy"
adb shell "rm -rf /system/xbin/daemonsu"

adb shell "rm -rf /system/bin/install-recovery.sh"
adb shell "rm -rf /system/etc/install-recovery.sh"

#/system/app/SuperSU/SuperSU.apk
adb shell "rm -rf /system/app/SuperSU"
