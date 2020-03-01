#!/usr/bin/env bash
source $HOME/dotfiles/helper.sh

if [ ! -x "$(command -v code)" ] ; then
  echo "${RED}zsh is not installed${NC}"
  read -p "${ORANGE}Do you want to install it (with pacman)? (Y/n)${NC} " -n 1 -r
echo

  if [[ $REPLY =~ ^[Yy]$ ]] ; then
    sudo pacman -Syu zsh 
    echo
    echo "${GREEN}Zsh installed successfully.${NC}"
    echo
  else
    exit 1
  fi
fi

chsh -s $(which zsh)
echo "${GREEN}Updated default shell to zsh${NC}"
echo
echo "${RED}Log out and log back in for changes to take place${NC}"
echo

