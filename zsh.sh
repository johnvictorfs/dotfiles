#!/usr/bin/env bash
source $HOME/dotfiles/helper.sh

if [ ! -x "$(command -v zsh)" ]; then
  echo "${RED}zsh is not installed${NC}"
  input "${ORANGE}Do you want to install it (with pacman)?"

  if [[ $ANSWER = true ]]; then
    sudo pacman -S zsh 
    echo
    echo "${GREEN}Zsh installed successfully.${NC}"
    echo
  else
    exit 1
  fi
fi

if [ -x "$(command -v zsh)" ]; then
  echo "${GREEN}Changing default shell to zsh...${NC}"
  chsh -s $(which zsh)
  echo "${GREEN}Updated default shell to zsh${NC}"
  echo
  echo "${RED}Log out and log back in for changes to take place${NC}"
  echo
fi

