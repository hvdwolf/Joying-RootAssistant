# Modifying the layout of Joying apps.


## Requirements:
- java runtime version 7 or better<br>
- [apktool](https://ibotpeaches.github.io/Apktool/)<br>
- Editor that handles unix LF correct. Any linux or Mac OS/X editor will do. Notepad on Windows does NOT. On Windows use Notepad++ for example.<br>
- Optional: [ApkPack](http://mirrors.gtxlabs.com/joying/3_Misc_Tools/ApkPack/)<br>
- Read(**!!**) the basic apktool [Basic, Decoding, Building](https://ibotpeaches.github.io/Apktool/documentation/) documentation to get a general understanding fo the apk structure.

## Installation:
- Java: Either use [Sun java](https://www.java.com) for all platforms, [Openjdk](http://openjdk.java.net) for linux, or Mac OS/X own java version (make sure it is version 7 or better)<br>
- apktool: See [here](https://ibotpeaches.github.io/Apktool/install/)<br>
- ApkPack.exe: This one can be used to pack/unpack the Allapp.pkg. This allows you to get the apks. Another option is to "adb pull" the original of your unit to work on.
apkPack is a windows binary but runs fine under wine.<br>

## General note
An apk file is actually nothing more than a zip file. This means that you can also unzip/rezip an apk. For only modifying buttonsand other graphical elements, this is sufficient. When you also want to modify the layout of the main screen or sub-screens, you really need apktool to decompile/compile. If you want to do minor code changes, you also need apktool. (A java jar file is also nothing more than a zip file).<br>

### Note for Windows users
1. Text files contain lines (obvious). These lines end with CRLF ("\r\n") line endings on Windows (and MAC versions before OS/X). On linuxes/unixes they end with "\n".
For some files inside an apk this really matters!<br>
That's why you need an editor that can handle that correctly.
2. Android is Case sensitive! Uppercase and lowercase characters do matter and are different (unless when used in strings)

## Getting the radio apk
1. Copy one of my radio mods.<br>
2. Use ApkPack.exe to get the apk out of the Allapp.pkg.<br>
3. Use adb to copy the apk from the unit like "adb pull /system/app/JY-1-C9-Radio-V1.0/JY-1-C9-Radio-V1.0.apk ." (the last "." is not a typo). _This assumes you already made a connection via USB or tcpip_<br>
4. Download the apk from "http://mirrors.gtxlabs.com/joying/1_Firmware/".<br>

## Decompile the apk
Create some folder where you want to work on the apk.<br>
Inside that folder do a "<path_to>/apktool d JY-JY-1-C9-Radio-V1.0.apk".<br>
This will create a folder "JY-JY-1-C9-Radio-V1.0" containing the decompiled apk including the from-binary-to-UTF-8 text converted AndroidManifest.xml
```
AndroidManifest.xml	(file)
apktool.yml		(file)
assets			(folder containing "all kind of things" needed by the apk, but not belonging to the standard res structure. This can be images, files, scripts or even other apks)
original		(folder containing original AndroidManifest.xml)
res			(folder containing layout, graphics, translations, etc.)
smali			(folder containing the decompiled code in "smali" format)
```

The "res" folder contains a large amount of sub folders.<br>
The three most important folders are:<br>
```
drawable-land-nodpi-v4		(contains resolution unspecific graphic elements for landscape mode)
drawable-nodpi-v4		(portrait version of above. Only needed because the original apk contains a corrupt png and can't be recompiled)
raw				(contains screen config/layout in json formatted files. Most apks have the config/layout in straight xml)
```

## Initial steps when using the original apk
When using the original apk (instead of one of my mods), you need two extra steps:<br>
- Copy the "ic_point.png" from the folder "drawable-land-nodpi-v4" to the folder "drawable-nodpi-v4". As mentioned: that png is corrupt in the original "drawable-nodpi-v4" which makes that you can't recompile the apk.<br>
- You need to make a small code change in smali to get rid of the "PS:" prefix in front of the PS-text containing the station name.<br>
Edit the "smali/com/syu/radio/RadioController.smali" in a good editor! (NOT Notepad).<br>
Search for the string "PS:" which is in line 1557.<br>
Change:<br>
```
const-string v3, "PS:"
```
into
```
const-string v3, ""
```


