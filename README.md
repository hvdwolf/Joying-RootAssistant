# Joying-Assistant for rooted units

WARNING: Only for joying Intel 3GR head units.

Currently the releases for this repository contain the SuperSU install scripts and the apk for the installation of several modded Joying apks, additional tools and busybox.
You can find the releases on the Releases page (See also the link above the green bar)

## 1. SuperSU_for_Joying_Intel
The Joying units are rooted but miss a user-friendly Superuser apk that deals with the SELinux policies on your unit.
These scripts as zip file can be found on the releases page and are called like "SuperSU_for_Joying_Intel".zip.

## 2. Joying-Assist.apk
The prerequisite to use this apk is that your unit is completely rooted with proper SE-linux policies. For this you need the SuperSU script from 1. (unless you did it in some other way).

So what does this apk do.

### 2.1 Enable/disable adb over tcpip
The 5.1.1 units came with "adb over tcpip" enabled by default. This was quite handy but it is a huge security risk. A hacker only needs to know the ip-address of your unit to break into it. The 6.0.1 unit comes with "adb over tcpip" disabled by default. This tool option enables/disables it. When enabled, it is disabled automatically again after the next reboot. Safety before everything else. 

### 2.2 SuperSu upgrade
It can upgrade your existing SuperSU installation,which you did using above scripts or another way. The SuperSu apk is upgraded automatically, but the used system binaries are not. That can be done via this option.

### 2.3 busybox-X86
The busybox version on the Joying head units is relatively old and buggy. The scripts in the busybox-X86 folder will update the busybox version on your system.

### 2.4 Radio Mods
The standard layout of the Joying radio app is not very nice. These mods contain one version of a changed layout in 5 colors.

### 2.5 Viper4Android
Viper4Android is the leading audio enhancement tool. It does a much better job then the pre-installed equalizer. This apk comes with 2 versions:<br> 
the latest "ViPER4Android_FX_v2505_A4.x-A7.x.apk"<br>
and the somewhat older "ViPER4Android_FX_A4.x.apk"<br>
Some users experience a "broken" equalizer in the latest A7 version and experience much better output with the previous A4 version.

### 2.6 SofiaServer mods
The SofiaServer apk is an impotant apk on this head unit, but also one that contains bugs and flaws. Gustden and AssassinsLament made quite some improvements.

### 2.7 Install Google settings
Joying modified the default Android Settings apk. They removed some valuable options but also added a few head unit options. This tool option gives you the possibility to install Google Settings.

### 2.8 Bluetooth enhancements and tools
(On the Todo list)
