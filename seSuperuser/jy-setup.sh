#!/system/bin/sh
#

# Installer for the seSuperuser su binary.
# Original: https://github.com/phhusson/Superuser
# This one: https://github.com/seSuperuser/Superuser
# This sub repository only contains and installs the su binary and install-recovery.sh script

# Version 1.0, 28 September 2017, HvdW

# Make backup of original su
if [ ! -e /system/xbin/su.org ]
then
	cp -f /system/xbin/su /system/xbin/su.org
fi
cp -f /data/seSuperuser/su /system/xbin/su
chmod 0775 /system/xbin/su
chown 0:0 /system/xbin/su

mkdir -p /system/app/Superuser
chmod 755 /system/app/Superuser
cp /data/seSuperuser/Superuser.apk /system/app/Superuser/Superuser.apk
chmod 644 /system/app/Superuser/Superuser.apk 

# Is there already an install-recovery.sh ?
if [ -e /system/bin/install-recovery.sh ]
then
	cp -f /system/bin/install-recovery.sh /system/bin/install-recovery.sh.org
fi
cp /data/seSuperuser/install-recovery.sh /system/bin/install-recovery.sh
chmod 755 /system/bin/install-recovery.sh



