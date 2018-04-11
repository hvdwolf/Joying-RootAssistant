# V3.0 - 2/26/2017 - Example script for Joying 2GB Sofia 
#
# This script is designed to customize the commands issued from steering wheel
# keys and is an example of what can be done. Not all programs/actions have
# been tested, but this should serve as a guide to your own custom script.
#
# All output from this script goes to /dev/null, however the system call is
# shown in the 'adb logcat' as a debug statement with the tag MCUKEY. If 
# you want to preserve script output for debugging, you may want to consider a 
# wrapper script to capture. When this script is run by the system, access to
# /sdcard is not available.  Hence you may want to use /data to store anything
# such as counts or command output.  When run by the system it is run with the
# 'system' login.  If you are testing the script using adb, make sure you
# either delete or change ownership of the files so 'system' has r/w access.
#
# USEFUL LAUNCH COMMDANDS defined as variables
#

# Goto Home screen
home="input keyevent 3"

# Back 
back="input keyevent 4"

# pause	
pause="input keyevent 127"

# Play
play="input keyevent 126"

# Recent Task list
recent="input keyevent KEYCODE_APP_SWITCH"

# Launch Web Page ( you may need to get creative with quotes depending on page )
web="am start -a android.intent.action.VIEW -n com.android.browser/.BrowserActivity http://images.intellicast.com/WxImages/RadarLoop/spi_None_anim.gif"

# ScreenFilter
scrflt="am start com.haxor/com.haxor.ScreenFilter"

# Google Voice Command
gvc="am start com.google.android.googlequicksearchbox/com.google.android.googlequicksearchbox.VoiceSearchActivity"

# Google maps
maps="am start com.google.android.apps.maps/com.google.android.maps.MapsActivity"  

# Radio
radio="am start com.syu.radio/com.syu.radio.Launch"

# I heart radio
iheart="am start com.clearchannel.iheartradio.controller/com.clearchannel.iheartradio.controller.activities.NavDrawerActivity"
iheart_press=$play

# Pandora
pandora="am start com.pandora.android/com.pandora.android.Main --activity-single-top --activity-brought-to-front"

# Press position on touchscreen for play/pause, small swipe was more reliable 
pandora_press="input swipe 550 580 555 585 500";

# Spotify
spotify="am start com.spotify.music/com.spotify.music.MainActivity"

# Press position on touchscreen for play/pause
spotify_press="input swipe 945 500 950 505 200"

# SYU Music ( stock music player )
music="am start com.syu.music/com.syu.media.act.Act_Music"

# Torque
torque="am start org.prowl.torque/org.prowl.torque.landing.FrontPage"


# key is the only arguemnt recieved and actions are based on the key number
key=$1

case $key in
        27) # BTPHONE/PTT - 1x press for BACK , 2x for HOME , 3 Google Voice 
		#
		# This section will execute three different commands based on
		# if one, two or three presses were recieved. Command(s) are 
		# put in  background for .7 second and then checked to see
		# if subsequent presses was recieved before execution.
		# 
		last=`cat /data/$key.cnt`
		last=$((last+1))
		case $last in
		1)
			echo $last > /data/$key.cnt
			(sleep .7 &&  [ `cat /data/$key.cnt` = $last ]  && echo 0 > /data/$key.cnt && $back ) &
		;;
		2)
			echo $last > /data/$key.cnt
			(sleep .5 &&  [ `cat /data/$key.cnt` = $last ]  && echo 0 > /data/$key.cnt && $home ) &
		;;
		3)
			echo 0 > /data/$key.cnt
			$gvc
                ;;
                *)
                        echo 0 > /data/$key.cnt
			$home
                ;;

                esac
	;;

        9) # NAVI - 1x press Torque, 2x for google maps
                #
                # This section will execute two different commands based on if
                # one or two presses were recieved. First command is put in 
                # background for .4 second and then checked to see if subsequent
                # press was recieved before execution.
                # Second command ( button press ) is immediate execution and 
                # lets first command know not to execute
		#
		last=`cat /data/$key.cnt`
		last=$((last+1))
                case $last in
                1)
                        echo $last > /data/$key.cnt
                        (sleep .4 && [ `cat /data/$key.cnt` = $last ] && echo 0 > /data/$key.cnt && $torque) &
                ;;
                2)
                        echo 0 > /data/$key.cnt 
			$maps
                ;;
                *)
                        echo 0 > /data/$key.cnt
			$home
                ;;
                esac
	;;

        37) # SOURCE/MODE 
		#
		# Toggle between applications Pandora, Spotify, Stock Music App,
		# and Radio.  If longer than 1m,  then bring up the last one 
		# called before continuing cycle 
		# 

		# Check if key press in last minute by checking if key file was modified
		found=`busybox find /data/$key.cnt -mmin -1 | wc -l`
		if [  "$found" = "0" ] 
		then
			# More than 1 minute bring current player to front
		 	next=`cat /data/$key.last`
			# Do not send pause or play
			keypress=0
		else
		 	next=`cat /data/$key.cnt`
			keypress=1
			# Send pause before changing to next
			$pause
		fi
		echo $next > /data/$key.last
		
		case $next in
		0) echo 1 > /data/$key.cnt
			$pandora
			( [ $keypress = 1 ] && sleep 3 && $pandora_press)
		;;
                1) echo 2 > /data/$key.cnt
			 $spotify 
			( [ $keypress = 1 ] && sleep 3 && $spotify_press)
		;;
                2) echo 3 > /data/$key.cnt
			 $music 
			( [ $keypress = 1 ] && sleep 3 && $music_press)
		;;
                3) echo 0 > /data/$key.cnt
			$radio
		;;
		*) echo 0 > /data/$key.cnt
			echo 0 > /data/$key.last
			$home 
		;;
		esac
	;;

        28) # HANG 
	;;
	31) # DVD
	;;
	32) # EJECT   
        ;;
        33) # MEDIA KEY - Not used by me
        ;;
        34) # BAND KEY - Not used by me
        ;;	

        97) # ACC_ON  - execute on key on
	$play
        ;;
        98) # ACC_OFF - executes on key off
	$pause;  
        ;;
        99) # RESUME  - executes on resume of system
 	    # Commands to be executed on resume

	 ;;

        *) # Pass any other keys pressed as keyevent 
	   # 3-Home, 4-Back, 85-PlayPause, 88-Prev, 86-Stop, 89-FB
	   # 90-FF, 87-Next, 126-Play, 127-Pause 
		input keyevent $key	
	;;
esac  # End $key cases

exit 0

