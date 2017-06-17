# Modifying the layout of the Joying Radio app.

Essentially this works for most apks. There are some differences where the layout is defined in xml files or on json files.

## Requirements:
- java runtime version 7 or better.<br>
- [apktool](https://ibotpeaches.github.io/Apktool/)<br>
- Editor that handles unix LF correct. Any linux or Mac OS/X editor will do. Notepad on Windows does NOT. On Windows use [Notepad++](https://notepad-plus-plus.org/download/) for example.<br>
- Optional: [ApkPack](http://mirrors.gtxlabs.com/joying/3_Misc_Tools/ApkPack/)<br>
- **Read(!!**) the basic apktool [Basic, Decoding, Building](https://ibotpeaches.github.io/Apktool/documentation/) documentation to get a general understanding fo the apk structure. It's about 1½ page and prevents a lot of questions.

## Installation:
- Java: Either use [Sun java](https://www.java.com) for all platforms, [Openjdk](http://openjdk.java.net) for linux, or Mac OS/X own java version (make sure it is version 7 or better)<br>
- apktool: See [here](https://ibotpeaches.github.io/Apktool/install/)<br>
- ApkPack.exe: This one can be used to pack/unpack the Allapp.pkg. This allows you to get the apks. Another option is to "adb pull" the original of your unit to work on.
apkPack is a windows binary but runs fine under wine.<br>

## General note
An apk file is actually nothing more than a zip file. This means that you can also unzip/rezip an apk. For only modifying buttons and other graphical elements, this is sufficient. When you also want to modify the layout of the main screen or sub-screens, you really need apktool to decompile/compile. If you want to do minor code changes, you also need apktool. _(Also a java jar file is also nothing more than a zip file)_.<br>

### Note for Windows users
1. Text files contain lines (obvious). These lines end with CRLF ("\r\n") line endings on Windows (and MAC versions before OS/X). On linuxes/unixes they end with "\n".
For some files inside an apk this really matters!<br>
That's why you need an editor that can handle that correctly, like for example Notepad++.
2. Android is Case sensitive! Uppercase and lowercase characters do matter and are different (unless when used in strings)

## Getting the radio apk
1. Copy one of my radio mods.<br>
2. Use ApkPack.exe to get the apk out of the Allapp.pkg.<br>
3. Use adb to copy the apk from the unit like "adb pull /system/app/JY-1-C9-Radio-V1.0/JY-1-C9-Radio-V1.0.apk ." (the last "." is not a typo). _This assumes you already made a connection via USB or tcpip_<br>
4. Download the apk from "http://mirrors.gtxlabs.com/joying/1_Firmware/".<br>

## Decompile the apk
Create some folder where you want to work on the apk.<br>
Inside that folder do a:
```
<path_to>/apktool d <path_to>/JY-JY-1-C9-Radio-V1.0.apk
```
This will create a folder "JY-JY-1-C9-Radio-V1.0" containing the decompiled apk including the from-binary-to-UTF-8 text converted AndroidManifest.xml. (Change forward slash "/" to backward slash "\\" on windows.)
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

## Relation between the graphical elements and the layout definition
All the graphical elements like buttons, the frequency ruler and numbers for the (big) frequency are in "res/drawable-land-nodpi-v4".
The layout definition is in "raw/radio_ui.json". The "radio_ui.json" determines which graphical elements are used, and how and where they are positioned. The "radio_ui.json" also determines which texts in which font and font size are used and where they are positioned.<br>
**Examples**:<br>
- The big frequency ruler is named "type":"HorizontalRuler" in the radio_ui.json and defined by the graphical element "drawables":["bk_ruler"], where "bk_ruler.png" is the image. Note that in the json file no extensions (.png) are used.
- The "type":"StationView" determines the 6 buttons with inactive (unselected: *_n) and active (selected: *_p) and "on_click/on_tap" (*_p) state.
- The Frequency numbers and the buttons left/right around it. The frequency numbers are the images "num_0.png" to "num_9.png", plus the "num_point.png". The buttons left/right are the "drawables":["ic_freqm_n", "ic_freqm_p"] (down) and "drawables":["ic_freqp_n", "ic_freqp_p"] (up).
- The PS, TA, AF, PTY etcetera can easily be found. These do not contain "drawables" (images), but are defined by textsize and text color.

All elements are positioned in a "X0,Y0,X1,Y1" or "top_left_X, top_left_Y,bottom_right_X, bottom_right_Y] rectangle.

Actually this is all.<br>
You can play with it to change the layout.
If you want to change color or form of buttons, ruler or other elements, you have to modify exiting elements or create new elements in either Gimp or Photoshop or another package you are familiar with.<br>
**Note1**: most PNGs are stored in "optimized" color mode (only store used colors) instead of "RGB" color mode (use full color palette). On small PNGs this can reduce the files by a factor 2, thereby reducing your apk size from ~2 MB to ~1.5 MB. This also means that in Gimp or Photoshop (or whatever), you first need to set the color mode to "RGB" before altering the elements, and before saving them back to "optimized".<br>
**Note2**: Remember that Android is case-sensitive. When working with the layout or the graphics, keep this in mind!

## Recompile the apk
When you are done "playing" and you want to experience the great and glorious app you created, you need to recompile it.
In your folder where you have the unpacked folder "JY-JY-1-C9-Radio-V1.0", you do a:
```
<path_to>/apktool -c b JY-JY-1-C9-Radio-V1.0
```
- Note that you specify the folder name, not some apk name
- the "b" is for build. 
- The "-c" is to use the original AndroidManifest.xml

If you see errors, please first google for it before asking questions. There is so much to find on this stuff on the web.
If your apk compiled successfully (don't mind the warnings), you will find it inside "JY-JY-1-C9-Radio-V1.0/disẗ" as a new "JY-JY-1-C9-Radio-V1.0.apk".

## Push the apk to your unit.
Simply use one of the scripts from my repository. Make sure to have adb in the right place (windows) or change the script accordingly. Read the [Readme](https://github.com/hvdwolf/Joying-RootAssistant/blob/master/Radio-Mod/Readme.md) inside this RadioMods sections for info on how to use the scripts to install it on your unit.

## Troubleshooting
Q1. adb or adb.exe can't be found.<br>
A1. Make sure you have adb installed. Use the proper path to adb.

Q2. I can't get a connection to the unit.<br>
A2. Search the web and find out how adb should work, see also the readme in my Radio mods. On 6.0.1 first activate adb over tcpip, or conect via USB.

Q3. You get a android icon instead of the Radio icon and when you tap it, your unit says "application not installed".<br>
A3. Reboot, check again and try another time to copy it to your unit. If nothing works (after a couple of attempts), reboot and copy the original radio apk back in place, reboot again.

Q4. You rebooted the unit and you hear music, but you don't see a Radio icon.<br>
A4. Same as Q3/A3: so do the same. This is due to the fact that the Radio function is a 2-step approach on the Intel joying units. The CarRadio.apk (hidden) does the real work. The Radio.apk is just the visible "tweak and go" app.
