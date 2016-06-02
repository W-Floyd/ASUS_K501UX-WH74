#!/bin/bash
###############################################################
# Check that the model number actually matches
###############################################################

echo "Is this an ASUS K501UX WH-74? [y/n]"

CORRECTINPUT=0
while [ $CORRECTINPUT != 1 ]; do

read -N 1 modelcheck

if [ $modelcheck = 'y' ]; then
	CORRECTINPUT=1
elif [ $modelcheck = 'n' ]; then
	CORRECTINPUT=1
	exit
else
	echo "Incorrect input, try again."
fi

done

###############################################################
# Functions
###############################################################

inputter () {
REQINPUT=0
while [ $REQINPUT != 1 ]; do

read -N 1 input

if [ $input = 'y' ]; then
	REQINPUT=1
elif [ $input = 'n' ]; then
	REQINPUT=1
	$1
else
	echo "Incorrect input, try again."
fi

done

}

###############################################################

setscale () {
SCALE='16'
dconf write /com/ubuntu/user-interface/scale-factor "{'eDP1': "$SCALE"}"

echo "Does this look good?
Press + to increase size, - to decrease, or = to keep it as it is."

SATISFIED=0
while [ $SATISFIED = '0' ]; do

read -N 1 scalecheck

if [ $scalecheck = '=' ]; then
	SATISFIED=1
elif [ $scalecheck = '+' ]; then
	SCALE=$(echo $SCALE"+1" | bc)
	echo "Scale increased"
	dconf write /com/ubuntu/user-interface/scale-factor "{'eDP1': "$SCALE"}"
elif [ $scalecheck = '-' ]; then
	SCALE=$(echo $SCALE"-1" | bc)
	echo "Scale decreased"
	dconf write /com/ubuntu/user-interface/scale-factor "{'eDP1': "$SCALE"}"
fi

done

echo "Okay, done!"

}

fixwifi () {
echo "options asus_nb_wmi wapf=4" | sudo tee /etc/modprobe.d/asus_nb_wmi.conf
}

fixfunctions () {
NEWLINE=$(cat /etc/default/grub | grep 'GRUB_CMDLINE_LINUX_DEFAULT=' | sed 's/splash/splash acpi_osi=/')
cat /etc/default/grub | sed 's/GRUB_CMDLINE_LINUX_DEFAULT=.*/'"$NEWLINE"'/' > /tmp/grub
sudo mv /tmp/grub /etc/default/grub
sudo update-grub
}

fixbrightness () {
NEWLINE=$(cat /etc/default/grub | grep 'GRUB_CMDLINE_LINUX_DEFAULT=' | sed 's/splash/splash acpi_backlight=native/')
cat /etc/default/grub | sed 's/GRUB_CMDLINE_LINUX_DEFAULT=.*/'"$NEWLINE"'/' > /tmp/grub
sudo mv /tmp/grub /etc/default/grub
sudo update-grub
}

###############################################################
# Questions
###############################################################

echo "
Are you already scaled up for the 4K screen? [y/n]"
inputter setscale

echo "
Is your wifi working [y/n]?"
inputter fixwifi

echo "
Is the airplane mode function key working? [y/n]"
inputter fixfunctions

echo "
Are you able to adjust the screen brightness? [y/n]"
inputter fixbrightness

echo "Please restart now!"

exit
