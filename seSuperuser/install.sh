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
adb push su /data/seSuperuser
adb push jy-setup.sh /data/seSuperuser
adb push Superuser.apk /data/seSuperuser

# Do the actual installation
adb shell chmod 0755 /data/seSuperuser/jy-setup.sh
adb shell "cd /data/seSuperuser && sh jy-setup.sh"

# Clean up
adb shell rm -rf /data/seSuperuser
adb shell sync
#adb shell mount -o ro,remount /system

echo "Reboot your Head Unit NOW!"
echo 'After the reboot go to the play store and download "phh\'s SuperUser"'
echo "or simply go to https://play.google.com/store/apps/details?id=me.phh.superuser"

