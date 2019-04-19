#!/usr/bin/env bash

ORANGE=$'\e[33m'
RED=$'\e[31m'
GREEN=$'\e[32m'
NC=$'\e[0m'

if [ ! -x "$(command -v subl)" ] ; then
	read -p "${RED}You do not have Sublime Text 3 installed. Do you want to install it now? (Y/n)${NC} " -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]] ; then
    	if [ -x "$(command -v snap)" ] ; then
    		snap install sublime-text
    	else
		    read -p "${RED}Snap is not installed. Do you want to install it now? (Y/n)${NC} " -n 1 -r
		    echo
		    if [[ $REPLY =~ ^[Yy]$ ]] ; then
		    	sudo apt update -y
		    	sudo apt install snapd -y
		    	snap install sublime-text
		    else
		    	exit 1
		    fi
    	fi
    else
    	exit 1
    fi
fi

# Install Package Control
cd ~/.config/sublime-text-3/Installed\ Packages
curl -O "https://packagecontrol.io/Package%20Control.sublime-package"
mv Package%20Control.sublime-package "Package Control.sublime-package"

# Setup configs
cd ~/dotfiles
cp -r sublime/Package\ Control.sublime-settings ~/.config/sublime-text-3/Packages/User/
cp -r sublime/Preferences.sublime-settings ~/.config/sublime-text-3/Packages/User/

echo
echo "${GREEN}Finished setting up Sublime 3 Settings.${NC}"
echo