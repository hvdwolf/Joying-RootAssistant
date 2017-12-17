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


#Make sure the original su is available
adb push su.org /sdcard/su.org

# Make the partitions read-writable
adb shell mount -o rw,remount /system


#/system/bin
#lrwxrwxrwx root     root              2017-10-05 19:04 app_process -> /system/xbin/daemonsu
#lrwxrwxrwx root     root              2017-10-05 19:04 app_process32 -> /system/xbin/daemonsu
#-rwxr-xr-x root     shell       17884 2008-08-01 14:00 app_process32_original
#-rwxr-xr-x root     shell       17884 2017-10-05 19:04 app_process_init

adb shell "rm /system/bin/app_process"
adb shell "rm /system/bin/app_process32"
adb shell "cp /system/bin/app_process32_original /system/bin/app_process32"
adb shell "cp /system/bin/app_process_init /system/bin/app_process"
adb shell "chmod 0755 /system/bin/app_process*"

#/system/lib
#-rw-r--r--    1 0        0           346536 Oct  5 17:04 libsupol.so
adb shell "rm -rf /system/lib/libsupol.so"

#/system/xbin
#-rwxr-xr-x    1 0        0           104012 Oct  5 17:04 su
#-rwxr-xr-x    1 0        0            46416 Oct  5 17:04 supolicy
#-rwxr-xr-x    1 0        0           104012 Oct  5 17:04 daemonsu
adb shell "rm -rf /system/xbin/su"
#adb shell "cp /system/xbin/su.org  /system/xbin/su"
adb shell "cp /sdcard/su.org /system/xbin/su"
adb shell "chmod 0755 /system/xbin/su"
adb shell "rm -rf /system/xbin/supolicy"
adb shell "rm -rf /system/xbin/daemonsu"

adb shell "rm -rf /system/bin/install-recovery.sh"
adb shell "rm -rf /system/etc/install-recovery.sh"

#/system/app/SuperSU/SuperSU.apk
adb shell "rm -rf /system/app/SuperSU"
