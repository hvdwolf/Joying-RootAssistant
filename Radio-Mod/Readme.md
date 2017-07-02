# Install modded Radio app

The default Radio app of Joying is in general working well, but I don't like the layout.

There are now 5 versions for 5.1.1: a BLUE\_WHITE, a RED, a RED\_WHITE, an ORANGE and a GREEN version. The RED and RED\_WHITE version are simple modifications on the ones that XDA developer [gustden already made](https://forum.xda-developers.com/showpost.php?p=70367793&postcount=434).</br>
There is 1 version for 6.0.1: a BLUE\_WHITE version.

Modifcations:
  * PS text from (small) top left to the center, increased font size and removed the "PS: prefix
  * Reducedthe frequency numbers and put these above the station buttons.
  * All station buttons on a single row.

The Radio app has a corrupted RDS text. The PS text is 8 characters and that same field is used for the 32 or 64 character RDS-text, but this string is not handled correctly by the app. 

The RED version is for older Audi (and older Volkswagen?)</br>
The RED_WHITE version is for a newer Audi (and newer Volkswagen ?)</br>
The BLUE_WHITE has the frequency in white instead of yellow.</br>
The ORANGE version is for BMWs.<br>
The GREEN versions is for Ford and Skoda.<br>
All have the modified Station name (PS text) and modified buttons.<br>
And for those who wantto switch back to the default Joying Radio app, I also added the JOYING_DEFAULT.


**How-To install:**</br>
1. Go to the [Releases](https://github.com/hvdwolf/Joying-RootAssistant/releases/tag/20170617) page to download the appropriate zip file.
2. 
    * On Windows: Run CMD.exe as Administrator. 
    * On Linux likes: Open a terminal.
3. Change to the folder where you unzipped the files or downloaded the repository, and change into the folder of your preferred color
4. 
    * On Windows: Run the install.bat script with the IP address of your Head Unit as a parameter: `install.bat 192.168.178.50` (for example)
    * On linux: Run the install.sh script with the IP address of your Head Unit as a parameter:`./install.sh 192.168.178.50` (for example)
5. Wait until the script finishes.
6. Done. If you replaced the original Radio app with a modded version, you need to reboot. If you change one of my modded versions with another of my modded versions, a reboot is not neccessary.


**Note!**
If you get warnings that you don't get access to write/copy AND you have already rooted your device with SuperSu, you need to give access via the SuperSu apk to adb wanting to operate in root mode (the `su` command).

-------
**5.1.1 Versions**<br>
**Blue_White**
![BLUE_WHITE](5.1.1/BLUE_WHITE/BLUE_WHITE.jpg "Blue_White version")
**Red_White**
![RED_WHITE](5.1.1/RED_WHITE/RED_WHITE.jpg "Red_White version")
**Red**
![RED](5.1.1/RED/RED.jpg "Red version")
**Orange**
![ORANGE](5.1.1/ORANGE/ORANGE.jpg "Orange version")
**GREEN**
![GREEN](5.1.1/GREEN/GREEN.jpg "Green version")

*(screenshots made with [Screenshot Touch](https://play.google.com/store/apps/details?id=com.mdiwebma.screenshot))*


-------
**6.0.1 Versions**<br>
**Blue_White**
![BLUE_WHITE](6.0.1/BLUE_WHITE/BLUE_WHITE.jpg "Blue_White version")
**SanAngel Mod**
![SanAngel](6.0.1/Sanangel-Mod/SanAngel.jpg "SanAngel's version")