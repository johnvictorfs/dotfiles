#!/usr/bin/env bash
source $HOME/dotfiles/helper.sh

# Yay setup
if [ ! -x "$(command -v yay)" ] ; then
  read -p "${ORANGE}Do you want to install and setup ${GREEN}Yay (AUR Package Manager) ${ORANGE}? (Y/n)${NC} " -n 1 -r
  echo

  if [[ $REPLY =~ ^[Yy]$ ]] ; then
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -sifi
  fi
fi

