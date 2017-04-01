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
adb connect %1
adb root
adb connect %1
sleep 2

# Make the partitions read-writable
adb shell mount -o rw,remount /system
adb shell mount -o rw,remount /system /system
adb shell mount -o rw,remount /
adb shell mount -o rw,remount / /

# Make some temporary folders
adb shell "mkdir /tmp"
adb shell "mkdir /tmp/supersu"

# Do the copying
adb push resources/chattr.pie /tmp/supersu/
adb push resources/install.sh /tmp/supersu/
adb push resources/install-recovery.sh /tmp/supersu/
adb push resources/libsupol.so /tmp/supersu/
adb push resources/su.pie /tmp/supersu/
adb push resources/Superuser.apk /tmp/supersu/
adb push resources/supolicy /tmp/supersu/

# Do the actual installation
adb shell chmod 0755 /tmp/supersu/install.sh
adb shell "cd /tmp/supersu/ && sh install.sh"

# Clean up
adb shell rm -rf /tmp/supersu
adb shell mount -o ro,remount /system
adb shell mount -o ro,remount /

echo Reboot your Head Unit NOW!
