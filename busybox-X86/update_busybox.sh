#!/bin/bash

# ipaddress given?
if [ "$1" = "" ]
then
        echo "Provide IP Address to connect to for adb"
        echo "for example:  install 10.0.0.52"
        exit
fi
set -x

# Connect to android unit
adb kill-server
adb connect $1
sleep 2

adb push ./busybox /sdcard/busybox
adb shell "su -c mount -o remount,rw /system"
adb shell "su -c cp /system/bin/busybox /system/bin/busybox.org"
adb shell "su -c cp /sdcard/busybox /system/bin/busybox"
adb shell "su -c chmod 06755 /system/bin/busybox"
adb shell "su -c mount -o ro,remount /system"

adb kill-server


echo -e "\n\nIt is not necessary to reboot your device now, but it will not hurt.\n\n"
