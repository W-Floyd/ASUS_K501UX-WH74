#!/bin/bash

################################################################################
# Functions
################################################################################

__input () {

echo "${1} [y/n]"

shift

local __input_complete='0'

while [ "${__input_complete}" = '0' ]; do

read -N 1 __input

echo

if [ "${__input}" = 'y' ]; then
	__input_complete='1'
elif [ "${__input}" = 'n' ]; then
	__input_complete='1'
	${@}
else
	echo "Incorrect input, try again."
fi

done

}

################################################################################

__write_scale () {
dconf write '/com/ubuntu/user-interface/scale-factor' "{'eDP1': ${1}}"
}

__set_scale () {
local __scale='16'
__write_scale "${__scale}"

echo 'Does this look good?
Press + to increase size, - to decrease, or = to keep it as it is.'

local __satisfied=0
while [ "${__satisfied}" = '0' ]; do

read -N 1 __scalecheck

echo

if [ "${__scalecheck}" = '=' ]; then

	__satisfied=1
	
elif [ "${__scalecheck}" = '+' ]; then

	__scale=$((__scale+1))
	echo 'Scale increased'
    __write_scale "${__scale}"
    
elif [ "${__scalecheck}" = '-' ]; then

	__scale=$((__scale-1))
	echo 'Scale decreased'
    __write_scale "${__scale}"
    
fi

done

echo 'Okay, done.'

}

__fix_wifi () {
echo 'options asus_nb_wmi wapf=4' | sudo tee '/etc/modprobe.d/asus_nb_wmi.conf' 1> /dev/null
}

__fix_functions () {
sudo sed -i -e "s|\(GRUB_CMDLINE_LINUX_DEFAULT=.*\)|\1 acpi_osi=/|" /etc/default/grub
sudo update-grub
}

__fix_brightness () {
sudo sed -i -e "s|\(GRUB_CMDLINE_LINUX_DEFAULT=.*\)|\1 acpi_backlight=native|" /etc/default/grub
sudo update-grub
}

################################################################################
# Questions
################################################################################

__input 'Is this an ASUS K501UX WH-74?' exit

__input 'Are you already scaled up for the 4K screen?' __set_scale

__input 'Is your wifi working?' __fix_wifi

__input 'Is the airplane mode function key working?' __fix_functions

__input 'Are you able to adjust the screen brightness?' __fix_brightness

echo 'Please restart now.'

exit
