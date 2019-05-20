#!/usr/bin/env bash
source $HOME/dotfiles/helper.sh

echo
read -p "${ORANGE}Do you wish to setup the Sublime 3 Configs? (Y/n)${NC} " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]] ; then
  exit 1
fi

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
echo -e "${GREEN}Installing Package Control...${NC}"
echo
cd $HOME/.config/sublime-text-3/Installed\ Packages
curl -O "https://packagecontrol.io/Package%20Control.sublime-package"
mv Package%20Control.sublime-package "Package Control.sublime-package"

# Setup configs
echo
read -p "${ORANGE}Do you want your Sublime 3 settings to be replaced? Backups will be made (Y/n) " -n 1 -r
echo
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
	if [ -f $HOME/.config/sublime-text-3/Packages/User/Package\ Control.sublime-settings ] ; then
      mv $HOME/.config/sublime-text-3/Packages/User/Package\ Control.sublime-settings $HOME/.config/sublime-text-3/Packages/User/Package\ Control.sublime-settings.backup
      echo -e "${ORANGE}Renamed current ${RED}~/.config/sublime-text-3/Packages/User/Package\ Control.sublime-settings${NC} ${ORANGE}to ${GREEN}~/.config/sublime-text-3/Packages/User/Package\ Control.sublime-settings.backup${NC}"
    fi
    if [ -f $HOME/.config/sublime-text-3/Packages/User/Preferences.sublime-settings ] ; then
      mv $HOME/.config/sublime-text-3/Packages/User/Preferences.sublime-settings $HOME/.config/sublime-text-3/Packages/User/Preferences.sublime-settings.backup
      echo -e "${ORANGE}Renamed current ${RED}~/.config/sublime-text-3/Packages/User/Preferences.sublime-settings${NC} ${ORANGE}to ${GREEN}~/.config/sublime-text-3/Packages/User/Preferences.sublime-settings.backup${NC}"
    fi

  ln -sv $HOME/dotfiles/sublime/Package\ Control.sublime-settings $HOME/.config/sublime-text-3/Packages/User/
  ln -sv $HOME/dotfiles/sublime/Preferences.sublime-settings $HOME/.config/sublime-text-3/Packages/User/
fi

echo
echo "${GREEN}Finished setting up Sublime 3 Settings.${NC}"
echo