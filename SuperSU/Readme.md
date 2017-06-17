# SuperSu v2.82 SR1
This is the [Chainfire.eu SuperSU](https://chainfire.eu/) version 2.82 SR1 of 09 June 2017. This is a repackaged version of the "flashable zip". It is repackaged for Joying Intel Sofia 3GR units.
My scripts (linux & windows) are based on another windows script for the 2.78 version released/created somewhere in September 2016. Unfortunately I can't give the creator the credits he/she deserves as I have no idea who that was.

**Changelog**</br>
17 June 2017: Updated SuperSu.apk and its binaries to V2.82-SR1<br>
18 April 2017: Altered the scripts and changed temporary copy location for more robustness.<br>

**CREDITS:**</br>
All credits go to Chainfire for his SuperSU application. This installation script is just tailored from the SuperSU install-script.

**WARNING!  STANDARD DISCLAIMER:**

               WITH GREAT POWER COMES GREAT RESPONSIBILITY.

               By proceeding and using the scripts, you accept that
               the used script is carried out at your own risk and
               you will not hold anyone else but yourself responsible.

               WITH GREAT POWER COMES GREAT RESPONSIBILITY.
 

With that disclaimer behind us we can now continue. Note that even if things go wrong and your unit will not work correctly again, you can very easily fix that by simply flashing your unit again with the (latest) [Joying ROM](https://www.carjoying.com/Joying-blog/59.html).</br>
One final remark to make: Note that 999 out of 1000 apps **don't need root access**. Even more: due to the access rights you earlier gave them during install, it might even result in security issues on your unit as those apps might have "leaks" that are otherwise covered by the Android system itself, but not anymore with that apk now having root access.

**Requirements:**</br>
  * `adb` - For windows it has been packaged in this repository inside this specific `SuperSU_for_Joying_Intel` folder. On Linux or one of the other systems you need to install it using your favorite package manager (like for Ubuntu/Debian likes: `sudo apt-get install adb`) or install it via the Android SDK (as can be done for windows as well).
  * You need either a Windows Laptop/PC or a Linux/\*BSD/MacOS X/Solaris laptop/PC that is connected to the same WiFi network as your Head Unit. You can find the ip-address of your head unit via `Settings -> WiFi; vertical "triple-dot" menu in top-right; Advanced`. 

**How-To install:**</br>
1. Download:
    * On Windows: Better download this repository as a zip. Unzip the file somewhere to your disk.
    * On Linux: Download the repository ith git or download the zip. In case of the zip, unzip the file somewhere to your disk.
2. 
    * On Windows: Run CMD.exe as Administrator. 
    * On Linux likes: Open a terminal.
3. Change to the folder where you unzipped the files or downloaded the repository, and change into the `SuperSU_for_Joying_Intel` folder where the `copy_install.sh` and `copy_install.bat` are located.
4. 
    * On Windows: Run the copy_install.bat script with the IP address of your Head Unit as a parameter: `copy_install.bat 192.168.178.50` (for example)
    * On linux: Run the copy_install.sh script with the IP address of your Head Unit as a parameter:`./copy_install.sh 192.168.178.50` (for example)
5. Wait until the script finishes.
6. Reboot your Head Unit.
7. DONE! ENJOY!

You should now have the SuperSU application working with modified SELinux policy settings. This will allow you to give other apps root access as well.

