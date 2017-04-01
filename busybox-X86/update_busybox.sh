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

# mount system as read-write and update dpi in build.prop
adb shell "su -c mount -o remount,rw /system"
adb shell "su -c cp /system/bin/busybox /system/bin/busybox/busybox.org"
adb push ./busybox /system/bin/busybox
adb shell "su -c chmod 06755 /system/bin/busybox"
adb shell "su -c mount -o ro,remount /system"

adb kill-server



echo -e "\n\nReboot your Head Unit NOW!\n\n"
