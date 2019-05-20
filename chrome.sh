#!/usr/bin/env bash
source $HOME/dotfiles/helper.sh

echo
read -p "${ORANGE}Do you wish to install ${GREEN}Google Chrome${ORANGE}? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	sudo dpkg -i google-chrome-stable_current_amd64.deb
fi
