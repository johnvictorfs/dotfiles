#!/usr/bin/env bash
source $HOME/dotfiles/helper.sh

# Yay setup
if [ ! -x "$(command -v yay)" ]; then
  input "${ORANGE}Do you want to install and setup ${GREEN}Yay (AUR Package Manager)?"

  if [[ $ANSWER = true ]]; then
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -sifi

    rm -rf yay
  fi
fi

