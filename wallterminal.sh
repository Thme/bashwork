#!/bin/bash
USERCFG=/home/"$USER"/.wallterminal.cfg
ROOTCFG=/root/wallterminal.cfg

if [[ $USER != root ]] && [[ ! -f /home/$USER/.wallterminal.cfg  ]] ; then
	echo "/home/"$USER".wallterminal.cfg not found..."
	echo "#wallterminal configuration file" > /home/$USER/.wallterminal.cfg
	echo "#To name your teminal window enter a any name you want it to be identified by. To view the " >> \ 
	/home/$USER/.wallterminal.cfg
	echo "TITLE=" >> /home/$USER/.wallterminal.cfg
	echo "#Set the dimensions with XxY where X is the width of the terminal window in charactors and Y is the" >> \
	/home/$USER/.wallterminal.cfg
	echo "#Height in charactors i setting is affected by font size so be sure to set your font size before" >> \
	/home/$USER/.wallterminal.cfg
	echo "#editing this setting. Example: 130x40 sets the window as 130 charactors wide by 40 charactprs high." >> \ 
	/home/$USER/.wallterminal.cfg
	echo "DIMENSIONS=" >> /home/$USER/.wallterminal.cfg
	echo "#Set the position with X+Y in number of pixels where X is set from the top down" >> \ 
	/home/$USER/.wallterminal.cfg
	echo "" >> /home/$USER/.wallterminal.cfg
	echo "" >> /home/$USER/.wallterminal.cfg
	echo "wallterminal.cfg file created at /home/$USER/.wallterminal.cfg. Please edit before running wallterminal"
	exit 0
elif [[ $USER != root ]] && [[ -f /home/"$USER"/.wallterminal.cfg ]] ; then
	source "$USERCFG" 
fi
if [[ $USER = root ]] && [[ ! -f /root/wallterminal.cfg ]] ; then
	echo "/root/wallterminal.cfg not found..."
	echo "#wallterminal configuration file" > /root/wallterminal.cfg
	echo "#To name your teminal window enter a any name you want it to be identified by. To view the " >> \ 
	/root/wallterminal.cfg
	echo "TITLE=" >> /root/wallterminal.cfg
	echo "#Set the dimensions with XxY where X is the width of the terminal window in charactors and Y is the" >> \
	/root/wallterminal.cfg
	echo "#Height in charactors i setting is affected by font size so be sure to set your font size before" >> \
	/root/wallterminal.cfg
	echo "#editing this setting. Example: 130x40 sets the window as 130 charactors wide by 40 charactprs high." >> \ 
	/root/wallterminal.cfg
	echo "DIMENSIONS=" >> /root/wallterminal.cfg
	echo "#Set the position with X+Y in number of pixels where X is set from the top down" >> \ 
	/root/wallterminal.cfg
	echo "" >> /root/wallterminal.cfg
	echo "" >> /root/wallterminal.cfg
	echo "wallterminal configuration file created at /root/wallterminal.cfg Please edit before running wallterminal"
	exit 0
elif [[ $USER = root ]] && [[ -f /root/wallterminal.cfg ]] ; then 
	source "$ROOTCFG"
fi
TRMOPTS="--hide-borders --hide-toolbar --hide-menubar --title=$TITLE"

#In additio to these settings you can easily set them to your preference. Consult the wmctrl man pages for more options.
#note that only two properties can be toggled/added/or removed when -b is used hence the need of running it twice to 
#fully set the window below everything, stick it across all workspaces and hide it from other parts of a DE...

opt1="-r "$TITLE" -b add,below,sticky"
opt2="-r "$TITLE" -b add,skip_taskbar,skip_pager"

#Checking if the configuration variables have been set. If one is missing prompt an error and exit.
if [[ -z $DIMENSIONS || -z $POSITION ]] || [[ -z $TITLE ]] && [[ $USER != root ]] ; then
	echo "wallterminal has not been configured! Please edit $USERCFG before running wallterminal."
	exit 1
elif [[ -z $DIMENSIONS || -z $POSITION ]] || [[ -z $TITLE ]] && [[ $USER = root ]] ; then
	echo "wallterminal has not been configured! Please edit $ROOTCFG before running wallterminal."
	exit 1
fi

#If you use gnome-terminal simply change "terminal" to "Terminal" they both support the same options gnome-terminal is named
#with a capital "T" they have the same options in this case and this should produce the same results.
xfce4-terminal $TRMOPTS --geometry=$DIMENSIONS+$POSITION &
#The while loop here simply repeatedly checks until wmctrl -l finds the windows TITLE before executing the actions
#of setting it properties and breaking the loop to exit the script. Note when run normally from a terminal wallterminal 
#executes and throws its tageted terminal as a backgroud job and may not be visable to top or htop... If wallterminal 
#is run at boot the terminal opened by it is visable to htop, top and other task managers...
#This is the only actual part that does te work to set the terminal's window properties when it is ready an visable
#to wmctrl to set those properties.
while true 
do
	if [[ "$(wmctrl -l | grep -o "$TITLE")" = $TITLE ]] ; then 
		wmctrl $opt1 && wmctrl $opt2
		echo 'done!'
		break
	fi
done

