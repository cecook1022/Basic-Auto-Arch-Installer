#!/bin/bash

# Author - Charles C
# Script is gonna be my first attempt of auto ricing bspwm
#####################################################################
#####################################################################
DriveInfo() {
clear
sudo fdisk -l 
echo -en "${CYAN}What Drive Do You Want To ${GREEN}Partition?${ORANGE} (format:/dev/sdX)${NC}: "
read partDrive
sudo cfdisk ${partDrive}

echo -en "${BLUE}Efi${CYAN} Partiton?${ORANGE} (format:/dev/sdX)${NC}: "
read partEfi
echo -en "${BLUE}Root${CYAN} Partition?${ORANGE} (format:/dev/sdX)${NC}: "
read partRoot
echo -en "${BLUE}Swap${CYAN} Partition?${ORANGE} (format:/dev/sdX)${NC}: "
read partSwap
echo -en "\n${CYAN}Are You Sure These Partitions Are Correct? ${BIRed}(${On_IRed}${BIWhite}Yes or No - LAST CHANCE!!!${NC}${BIRed})${NC}: "
read goCorrect
if [ ${goCorrect} == "Yes" ]; then
	echo -e "\n\n${CYAN}Starting ${GREEN}Partition Format${NC}...."
	sleep 1
	mkfs.ext4 ${partRoot}
	mkswap ${partSwap}
	mkfs.fat -F 32 ${partEfi}
	echo -e "\n${CYAN}Starting ${GREEN}Partition Mounting${NC}...."
	sudo mount ${partRoot} /mnt
	sudo mkdir /mnt/boot
	sudo mount ${partEfi} /mnt/boot
	sudo swapon ${partSwap}
	sleep 1
else
	sleep 1.5
	DriveInfo
fi
}
#####################################################################
Installation() {
clear
echo -e "${CYAN}Now Pacstrap Will Install All Files Necessary for Boot."
echo -e "These Include${NC}:${YELLOW} base linux linux-firmware grub"
echo -en "${GREEN}Would You Like To Include Any Other Programs? ${ORANGE}(Just write as a spaced list ^^)${RED} \n\n>>${NC}~"
read otherInstall
echo -e "\n\n${CYAN}Now Beginning Installation${BLUE}.${RED}.${GREEN}.${YELLOW}.${NC}"
sleep 1
sudo pacman -Syyu
sudo pacstrap /mnt base linux linux-firmware grub ${otherInstall}
echo -e "\n${RED}~${GREEN}~ ${YELLOW}Installation Complete! ${BLUE}~${PURPLE}~${NC}"
sleep 2
clear
echo -e "\n${CYAN}Now Completing First Time Setup${BLUE}.${RED}.${GREEN}.${YELLOW}.${NC}"
genfstab -U /mnt >> /mnt/etc/fstab

}
#####################################################################
### Colorss #########################################################
RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
ORANGE='\033[0;33m'
PURPLE='\033[0;35m'
NC='\033[0m'

#${BIRed}
#${BLUE}
#${GREEN}
#${CYAN}
#${ORANGE}
#${YELLOW}
#${PURPLE}
#${NC}

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White
#####################################################################
#####################################################################
clear
echo "Setting up Initial stuff..."
loadkeys us.map.gz
isUEFI=0
if [ $(ls /sys/firmware/efi/efivars) ]; then
	isUEFI = 1
fi
if [ ${isUEFI} == 1 ]; then
	echo -e "${CYAN}You're Booted In: ${On_IPurple}${BIWhite}UEFI Mode${NC}\n\n"
else
	echo -e "${CYAN}You're Booted In: ${On_IRed}${BIWhite}BIOS Mode${NC}\n\n"
fi
sleep 1
ip link
echo -en "\n${CYAN}What Is Your ${YELLOW}Internet Device?${NC}: "
read iwDevice
ip link set ${iwDevice} up
timedatectl set-ntp true
sleep 2


DriveInfo
sleep 1
Installation