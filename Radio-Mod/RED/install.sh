#!/bin/sh

# ipaddress given?
if [ "$1" = "" ]
then
	echo "Provide IP Address to connect to for adb"
	echo "for example:  install 10.0.0.52"
	exit
fi
set -x

# no old "left over" connections
adb kill-server

adb connect $1

sleep 2

# Push update APK file to sdcard then /system/app
adb push JY-1-C9-Radio-V1.0.apk /sdcard/
adb shell "su -c am force-stop com.syu.radio"
adb shell "su -c mount -o remount,rw /system"
adb shell "su -c cp /system/app/JY-1-C9-Radio-V1.0/JY-1-C9-Radio-V1.0.apk /system/app/JY-1-C9-Radio-V1.0/JY-1-C9-Radio-V1.0.apk.old"
adb shell "su -c cp /sdcard/JY-1-C9-Radio-V1.0.apk /system/app/JY-1-C9-Radio-V1.0"
adb shell "su -c chmod 644 /system/app/JY-1-C9-Radio-V1.0/JY-1-C9-Radio-V1.0.apk"
adb shell "su -c ls -l /system/app/JY-1-C9-Radio-V1.0"

#echo "######### PLEASE REBOOT YOUR SYSTEM ###########"
