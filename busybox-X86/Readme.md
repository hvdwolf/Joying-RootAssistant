# busybox installer/upgrader

The current versions of the Joying Intel Sofia 4GR headunits come with a buggy 1.22 busybox version. The windows bat file and linux shell script update that joying version to the latest 1.26-2 busybox version.

busybox details/explanations/etc. can be found on [busybox.net](https://busybox.net/).

Another good version of busybox can be found on Jared Rummler's [github pages](https://github.com/jrummyapps/BusyBox) (note that his apk is a userfriendly "shell" around the busybox binary").


**Requirements:**</br>
  * `adb` - For windows it has been packaged in this repository in the win-adb folder. On Linux or one of the other systems you need to install it using your favorite package manager (like for Ubuntu/Debian likes: `sudo apt-get install adb`)or install it via the Android SDK (as can be done for windows as well).
  * You need either a Windows Laptop/PC or a Linux/\*BSD/MacOS X/Solaris laptop/PC that is connected to the same WiFi network as your Head Unit. You can find the ip-address of your head unit via `Settings -> WiFi; vertical "triple-dot" menu in top-right; Advanced`. 

**How-To install:**</br>
1. If you downloaded this repository as zip, you unzip the file somewhere to your disk.
2. 
    * On Windows: Run CMD.exe as Administrator. 
    * On Linux likes: Open a terminal.
3. Change to the folder where you unzipped the files or downloaded the repository, and change into the `busybox_X86` folder where the `update_busybox.sh` and `update_busybox.bat` are located.
4. 
    * On Windows: Run the update_busybox.bat script with the IP address of your Head Unit as a parameter: `update_busybox.bat 192.168.178.50` (for example)
    * On linux: Run the update_busybox.sh script with the IP address of your Head Unit as a parameter:`./update_busybox.sh 192.168.178.50` (for example)
5. Wait until the script finishes.
6. Done. You can reboot but it is not neccessary.
