#!/system/bin/sh
#

# Installer for the seSuperuser su binary.
# Original: https://github.com/phhusson/Superuser
# This one: https://github.com/seSuperuser/Superuser
# This sub repository only contains and installs the su binary and install-recovery.sh script

# Version 1.0, 28 September 2017, HvdW

# Make backup of original su
cp -f /system/bin/su /system/bin/su.org
cp -f /data/seSuperuser/su /system/bin/su
chmod 06775 /system/bin/su

# Is there already an install-recovery.sh ?
if [ ! -f /system/bin/install-recovery.sh ]
then
	cp -f /system/bin/install-recovery.sh /system/bin/install-recovery.sh.org
fi

# Use single quotes to prevent bash from expanding the #! shebang
printf '#!/bin/system/sh\n' > /system/bin/install-recovery.sh
printf '\n\n' >> /system/bin/install-recovery.sh
printf '# This /system/bin/install-recovery.sh is installed here to start the\n' >> /system/bin/install-recovery.sh
printf '# seSuperuser su binary in daemon mode\n\n' >> /system/bin/install-recovery.sh
printf 'su --daemon &\n' >> /system/bin/install-recovery.sh
chmod 755 /system/bin/install-recovery.sh



