#!/usr/bin/env bash
source $HOME/dotfiles/helper.sh

# Paru setup
if [ ! -x "$(command -v yay)" ]; then
  input "${ORANGE}Do you want to install and setup ${GREEN}Paru (AUR Package Manager)?"

  if [[ $ANSWER = true ]]; then
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si
    cd ..
    rm -rf paru
  fi
fi

