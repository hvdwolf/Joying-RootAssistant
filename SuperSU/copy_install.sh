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

# Make the partitions read-writable
adb shell mount -o rw,remount /system

# Make some temporary folders
adb shell "mkdir /sdcard/supersu"

# Do the copying
adb push resources/chattr.pie /sdcard/supersu/
adb push resources/install.sh /sdcard/supersu/
adb push resources/install-recovery.sh /sdcard/supersu/
adb push resources/libsupol.so /sdcard/supersu/
adb push resources/su.pie /sdcard/supersu/
adb push resources/Superuser.apk /sdcard/supersu/
adb push resources/supolicy /sdcard/supersu/

# internal copy
adb shell "mkdir -p /data/supersu"
adb shell "cp /sdcard/supersu/* /data/supersu/"

# Do the actual installation
adb shell chmod 0755 /data/supersu/install.sh
adb shell "cd /data/supersu/ && sh install.sh"

# Clean up
adb shell rm -rf /sdcard/supersu
adb shell rm -rf /data/supersu
adb shell sync
#adb shell mount -o ro,remount /system

echo Reboot your Head Unit NOW!
