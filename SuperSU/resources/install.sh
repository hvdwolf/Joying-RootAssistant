#!/sbin/sh
#
# SuperSU installer ZIP
# Copyright (c) 2012-2016 - Chainfire
#
# ----- GENERIC INFO ------
#
# The following su binary versions are included in the full package. Each
# should be installed only if the system has the same or newer API level
# as listed. The script may fall back to a different binary on older API
# levels. supolicy are all ndk/pie/19+ for 32 bit, ndk/pie/20+ for 64 bit.
#
# binary        ARCH/path   build type      API
#
# arm-v5te      arm         ndk non-pie     7+
# x86           x86         ndk non-pie     7+
#
# x86           x86         ndk pie         17+   (su.pie, naming exception)
# arm-v7a       armv7       ndk pie         17+
# mips          mips        ndk pie         17+
#
# arm64-v8a     arm64       ndk pie         20+
# mips64        mips64      ndk pie         20+
# x86_64        x64         ndk pie         20+
#
# Non-static binaries are supported to be PIE (Position Independent
# Executable) from API level 16, and required from API level 20 (which will
# refuse to execute non-static non-PIE).
#
# The script performs several actions in various ways, sometimes
# multiple times, due to different recoveries and firmwares behaving
# differently, and it thus being required for the correct result.
#
# Overridable variables (shell):
#   BIN - Location of architecture specific files (native folder)
#   COM - Location of common files (APK folder)
#   LESSLOGGING - Reduce ui_print logging (true/false)
#   NOOVERRIDE - Do not read variables from /system/.supersu or
#                /data/.supersu
#
# Overridable variables (shell, /system/.supersu, /cache/.supersu,
# /data/.supersu):
#   SYSTEMLESS - Do a system-less install? (true/false, 6.0+ only)
#   PATCHBOOTIMAGE - Automatically patch boot image? (true/false,
#                    SYSTEMLESS only)
#   BOOTIMAGE - Boot image location (PATCHBOOTIMAGE only)
#   STOCKBOOTIMAGE - Stock boot image location (PATCHBOOTIMAGE only)
#   BINDSYSTEMXBIN - Poor man's overlay on /system/xbin (true/false,
#                    SYSTEMLESS only)
#   PERMISSIVE - Set sepolicy to fake-permissive (true/false, PATCHBOOTIMAGE
#                only)
#   KEEPVERITY - Do not remove dm-verity (true/false, PATCHBOOTIMAGE only)
#   KEEPFORCEENCRYPT - Do not replace forceencrypt with encryptable (true/
#                      false, PATCHBOOTIMAGE only)
#   FRP - Place files in boot image that allow root to survive a factory
#         reset (true/false, PATCHBOOTIMAGE only). Reverts to su binaries
#         from the time the ZIP was originall flashed, updates are lost.
# Shell overrides all, /data/.supersu overrides /cache/.supersu overrides
# /system/.supersu
#
# Note that if SELinux is set to enforcing, the daemonsu binary expects
# to be run at startup (usually from install-recovery.sh, 99SuperSUDaemon,
# or app_process) from u:r:init:s0 or u:r:kernel:s0 contexts. Depending
# on the current policies, it can also deal with u:r:init_shell:s0 and
# u:r:toolbox:s0 contexts. Any other context will lead to issues eventually.
#
# ----- "SYSTEM" INSTALL -----
#
# "System" install puts all the files needed in /system and does not need
# any boot image modifications. Default install method pre-Android-6.0
# (excluding Samsung-5.1).
#
# Even on Android-6.0+, the script attempts to detect if the current
# firmware is compatible with a system-only installation (see the
# "detect_systemless_required" function), and will prefer that
# (unless the SYSTEMLESS variable is set) if so. This will catch the
# case of several custom ROMs that users like to use custom boot images
# with - SuperSU will not need to patch these. It can also catch some
# locked bootloader cases that do allow security policy updates.
#
# To install SuperSU properly, aside from cleaning old versions and
# other superuser-type apps from the system, the following files need to
# be installed:
#
# API   source                        target                              chmod   chcon                       required
#
# 7-19  common/Superuser.apk          /system/app/Superuser.apk           0644    u:object_r:system_file:s0   gui
# 20+   common/Superuser.apk          /system/app/SuperSU/SuperSU.apk     0644    u:object_r:system_file:s0   gui
#
# 17+   common/install-recovery.sh    /system/etc/install-recovery.sh     0755    *1                          required
# 17+                                 /system/bin/install-recovery.sh     (symlink to /system/etc/...)        required
# *1: same as /system/bin/toolbox: u:object_r:system_file:s0 if API < 20, u:object_r:toolbox_exec:s0 if API >= 20
#
# 7+    ARCH/su *2                    /system/xbin/su                     *3      u:object_r:system_file:s0   required
# 7+                                  /system/bin/.ext/.su                *3      u:object_r:system_file:s0   gui
# 17+                                 /system/xbin/daemonsu               0755    u:object_r:system_file:s0   required
# 17-21                               /system/xbin/sugote                 0755    u:object_r:zygote_exec:s0   required
# *2: su.pie for 17+ x86(_32) only
# *3: 06755 if API < 18, 0755 if API >= 18
#
# 19+   ARCH/supolicy                 /system/xbin/supolicy               0755    u:object_r:system_file:s0   required
# 19+   ARCH/libsupol.so              /system/lib(64)/libsupol.so         0644    u:object_r:system_file:s0   required
#
# 17-21 /system/bin/sh or mksh *4     /system/xbin/sugote-mksh            0755    u:object_r:system_file:s0   required
# *4: which one (or both) are available depends on API
#
# 21+   /system/bin/app_process32 *5  /system/bin/app_process32_original  0755    u:object_r:zygote_exec:s0   required
# 21+   /system/bin/app_process64 *5  /system/bin/app_process64_original  0755    u:object_r:zygote_exec:s0   required
# 21+   /system/bin/app_processXX *5  /system/bin/app_process_init        0755    u:object_r:system_file:s0   required
# 21+                                 /system/bin/app_process             (symlink to /system/xbin/daemonsu)  required
# 21+                             *5  /system/bin/app_process32           (symlink to /system/xbin/daemonsu)  required
# 21+                             *5  /system/bin/app_process64           (symlink to /system/xbin/daemonsu)  required
# *5: Only do this for the relevant bits. On a 64 bits system, leave the 32 bits files alone, or dynamic linker errors
#     will prevent the system from fully working in subtle ways. The bits of the su binary must also match!
#
# 17+   common/99SuperSUDaemon *6     /system/etc/init.d/99SuperSUDaemon  0755    u:object_r:system_file:s0   optional
# *6: only place this file if /system/etc/init.d is present
#
# 17+   'echo 1 >' or 'touch' *7      /system/etc/.installed_su_daemon    0644    u:object_r:system_file:s0   optional
# *7: the file just needs to exist or some recoveries will nag you. Even with it there, it may still happen.
#
# It may seem some files are installed multiple times needlessly, but
# it only seems that way. Installing files differently or symlinking
# instead of copying (unless specified) will lead to issues eventually.
#
# After installation, run '/system/xbin/su --install', which may need to
# perform some additional installation steps. Ideally, at one point,
# a lot of this script will be moved there.
#
# The included chattr(.pie) binaries are used to remove ext2's immutable
# flag on some files. This flag is no longer set by SuperSU's OTA
# survival since API level 18, so there is no need for the 64 bit versions.
# Note that chattr does not need to be installed to the system, it's just
# used by this script, and not supported by the busybox used in older
# recoveries.

ch_con() {
  LD_LIBRARY_PATH=$SYSTEMLIB /system/bin/toybox chcon -h u:object_r:system_file:s0 $1 1>/dev/null 2>/dev/null
  LD_LIBRARY_PATH=$SYSTEMLIB /system/toolbox chcon -h u:object_r:system_file:s0 $1 1>/dev/null 2>/dev/null
  LD_LIBRARY_PATH=$SYSTEMLIB /system/bin/toolbox chcon -h u:object_r:system_file:s0 $1 1>/dev/null 2>/dev/null
  chcon -h u:object_r:system_file:s0 $1 1>/dev/null 2>/dev/null
  LD_LIBRARY_PATH=$SYSTEMLIB /system/bin/toybox chcon u:object_r:system_file:s0 $1 1>/dev/null 2>/dev/null
  LD_LIBRARY_PATH=$SYSTEMLIB /system/toolbox chcon u:object_r:system_file:s0 $1 1>/dev/null 2>/dev/null
  LD_LIBRARY_PATH=$SYSTEMLIB /system/bin/toolbox chcon u:object_r:system_file:s0 $1 1>/dev/null 2>/dev/null
  chcon u:object_r:system_file:s0 $1 1>/dev/null 2>/dev/null
} 

ch_con_ext() {
  LD_LIBRARY_PATH=$SYSTEMLIB /system/bin/toybox chcon $2 $1 1>/dev/null 2>/dev/null
  LD_LIBRARY_PATH=$SYSTEMLIB /system/toolbox chcon $2 $1 1>/dev/null 2>/dev/null
  LD_LIBRARY_PATH=$SYSTEMLIB /system/bin/toolbox chcon $2 $1 1>/dev/null 2>/dev/null
  chcon $2 $1 1>/dev/null 2>/dev/null
}

ln_con() {
  LD_LIBRARY_PATH=$SYSTEMLIB /system/bin/toybox ln -s $1 $2 1>/dev/null 2>/dev/null
  LD_LIBRARY_PATH=$SYSTEMLIB /system/toolbox ln -s $1 $2 1>/dev/null 2>/dev/null
  LD_LIBRARY_PATH=$SYSTEMLIB /system/bin/toolbox ln -s $1 $2 1>/dev/null 2>/dev/null
  ln -s $1 $2 1>/dev/null 2>/dev/null
  ch_con $2 1>/dev/null 2>/dev/null
}

set_perm() {
  chown $1.$2 $4
  chown $1:$2 $4
  chmod $3 $4
  ch_con $4
  ch_con_ext $4 $5
}

cp_perm() {
  rm $5 1>/dev/null 2>/dev/null
  if [ -f "$4" ]; then
    cat $4 > $5
    set_perm $1 $2 $3 $5 $6
  fi
}
 
SYSTEMLIB=/system/lib
BIN=.
COM=.
PIE=.pie
SUMOD=0755
SU=su.pie
SUPOLICY=true
APKFOLDER=true
APKNAME=/system/app/SuperSU/SuperSU.apk
APPPROCESS=true
APPPROCESS64=false	


# START Installing
chmod -R 0755 $BIN/*
RAMDISKLIB=$BIN:$SYSTEMLIB
LD_LIBRARY_PATH=$RAMDISKLIB $BIN/supolicy --live "permissive *" 1>/dev/null 2>/dev/null 
chmod 0755 chattr$PIE

LD_LIBRARY_PATH=$SYSTEMLIB $BIN/chattr$PIE -ia /system/bin/su 1>/dev/null 2>/dev/null 
LD_LIBRARY_PATH=$SYSTEMLIB $BIN/chattr$PIE -ia /system/xbin/su 1>/dev/null 2>/dev/null 
LD_LIBRARY_PATH=$SYSTEMLIB $BIN/chattr$PIE -ia /system/bin/.ext/.su 1>/dev/null 2>/dev/null 
LD_LIBRARY_PATH=$SYSTEMLIB $BIN/chattr$PIE -ia /system/sbin/su 1>/dev/null 2>/dev/null 
LD_LIBRARY_PATH=$SYSTEMLIB $BIN/chattr$PIE -ia /vendor/sbin/su 1>/dev/null 2>/dev/null 
LD_LIBRARY_PATH=$SYSTEMLIB $BIN/chattr$PIE -ia /vendor/bin/su 1>/dev/null 2>/dev/null 
LD_LIBRARY_PATH=$SYSTEMLIB $BIN/chattr$PIE -ia /vendor/xbin/su 1>/dev/null 2>/dev/null 
LD_LIBRARY_PATH=$SYSTEMLIB $BIN/chattr$PIE -ia /system/xbin/daemonsu 1>/dev/null 2>/dev/null 
LD_LIBRARY_PATH=$SYSTEMLIB $BIN/chattr$PIE -ia /system/xbin/sugote 1>/dev/null 2>/dev/null 
LD_LIBRARY_PATH=$SYSTEMLIB $BIN/chattr$PIE -ia /system/xbin/sugote_mksh 1>/dev/null 2>/dev/null 
LD_LIBRARY_PATH=$SYSTEMLIB $BIN/chattr$PIE -ia /system/xbin/supolicy 1>/dev/null 2>/dev/null 
LD_LIBRARY_PATH=$SYSTEMLIB $BIN/chattr$PIE -ia /system/xbin/ku.sud 1>/dev/null 2>/dev/null 
LD_LIBRARY_PATH=$SYSTEMLIB $BIN/chattr$PIE -ia /system/xbin/.ku 1>/dev/null 2>/dev/null 
LD_LIBRARY_PATH=$SYSTEMLIB $BIN/chattr$PIE -ia /system/xbin/.su 1>/dev/null 2>/dev/null 
LD_LIBRARY_PATH=$SYSTEMLIB $BIN/chattr$PIE -ia /system/lib/libsupol.so 1>/dev/null 2>/dev/null 
LD_LIBRARY_PATH=$SYSTEMLIB $BIN/chattr$PIE -ia /system/lib64/libsupol.so 1>/dev/null 2>/dev/null 
LD_LIBRARY_PATH=$SYSTEMLIB $BIN/chattr$PIE -ia /system/etc/install-recovery.sh 1>/dev/null 2>/dev/null 
LD_LIBRARY_PATH=$SYSTEMLIB $BIN/chattr$PIE -ia /system/bin/install-recovery.sh 1>/dev/null 2>/dev/null 

if [ -f "/system/bin/install-recovery.sh" ]; then
if [ ! -f "/system/bin/install-recovery_original.sh" ]; then
  mv /system/bin/install-recovery.sh /system/bin/install-recovery_original.sh 1>/dev/null 2>/dev/null
  ch_con /system/bin/install-recovery_original.sh
fi
fi
if [ -f "/system/etc/install-recovery.sh" ]; then
if [ ! -f "/system/etc/install-recovery_original.sh" ]; then
  mv /system/etc/install-recovery.sh /system/etc/install-recovery_original.sh 1>/dev/null 2>/dev/null
  ch_con /system/etc/install-recovery_original.sh
fi
fi

# only wipe these files in /system install, so not part of the wipe_ functions

rm -f /system/bin/install-recovery.sh 1>/dev/null 2>/dev/null 
rm -f /system/etc/install-recovery.sh 1>/dev/null 2>/dev/null 

rm -f /system/bin/su 1>/dev/null 2>/dev/null 
rm -f /system/xbin/su 1>/dev/null 2>/dev/null 
rm -f /system/sbin/su 1>/dev/null 2>/dev/null 
rm -f /vendor/sbin/su 1>/dev/null 2>/dev/null 
rm -f /vendor/bin/su 1>/dev/null 2>/dev/null 
rm -f /vendor/xbin/su 1>/dev/null 2>/dev/null 

rm -rf /data/app/eu.chainfire.supersu-* 1>/dev/null 2>/dev/null 
rm -rf /data/app/eu.chainfire.supersu.apk 1>/dev/null 2>/dev/null 


mkdir /system/bin/.ext 1>/dev/null 2>/dev/null 
set_perm 0 0 0777 /system/bin/.ext
cp_perm 0 0 $SUMOD $BIN/$SU /system/bin/.ext/.su
cp_perm 0 0 $SUMOD $BIN/$SU /system/xbin/su
cp_perm 0 0 0755 $BIN/$SU /system/xbin/daemonsu

if ($SUPOLICY); then
cp_perm 0 0 0755 $BIN/supolicy /system/xbin/supolicy
cp_perm 0 0 0644 $BIN/libsupol.so $SYSTEMLIB/libsupol.so
fi
if ($APKFOLDER); then
mkdir /system/app/SuperSU 1>/dev/null 2>/dev/null 
set_perm 0 0 0755 /system/app/SuperSU
fi
cp_perm 0 0 0644 $COM/Superuser.apk $APKNAME
cp_perm 0 0 0755 $COM/install-recovery.sh /system/etc/install-recovery.sh
ln_con /system/etc/install-recovery.sh /system/bin/install-recovery.sh
if ($APPPROCESS); then
rm /system/bin/app_process 1>/dev/null 2>/dev/null 
ln_con /system/xbin/daemonsu /system/bin/app_process
if ($APPPROCESS64); then
  if [ ! -f "/system/bin/app_process64_original" ]; then
	mv /system/bin/app_process64 /system/bin/app_process64_original 1>/dev/null 2>/dev/null
  else
	rm /system/bin/app_process64 1>/dev/null 2>/dev/null
  fi
  ln_con /system/xbin/daemonsu /system/bin/app_process64
  if [ ! -f "/system/bin/app_process_init" ]; then
	cp_perm 0 2000 0755 /system/bin/app_process64_original /system/bin/app_process_init
  fi
else
  if [ ! -f "/system/bin/app_process32_original" ]; then
	mv /system/bin/app_process32 /system/bin/app_process32_original 1>/dev/null 2>/dev/null 
  else
	rm /system/bin/app_process32 1>/dev/null 2>/dev/null 
  fi
  ln_con /system/xbin/daemonsu /system/bin/app_process32
  if [ ! -f "/system/bin/app_process_init" ]; then
	cp_perm 0 2000 0755 /system/bin/app_process32_original /system/bin/app_process_init
  fi
fi
fi

echo 1 > /system/etc/.installed_su_daemon
set_perm 0 0 0644 /system/etc/.installed_su_daemon

LD_LIBRARY_PATH=$SYSTEMLIB /system/xbin/su --install 