#!/bin/bash


# ipaddress given?
if [ "$1" = "" ]
then
        echo "Provide IP Address to connect to for adb"
        echo "for example:  ./install.sh 192.168.178.52"
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

# copy necessary files
adb shell "mkdir -p /data/seSuperuser"
adb push su /data/seSuperuser/su
adb push jy-setup.sh /data/seSuperuser/jy-setup.sh
adb push Superuser.apk /data/seSuperuser/Superuser.apk
adb push install-recovery.sh /data/seSuperuser/install-recovery.sh

# Do the actual installation
adb shell chmod 0755 /data/seSuperuser/jy-setup.sh
adb shell "cd /data/seSuperuser && sh jy-setup.sh"

# Clean up
adb shell rm -rf /data/seSuperuser
adb shell sync
#adb shell mount -o ro,remount /system

echo "Reboot your Head Unit NOW!"


