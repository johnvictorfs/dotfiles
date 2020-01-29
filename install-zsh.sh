#!/usr/bin/env bash
source $HOME/dotfiles/helper.sh

sudo apt install zsh -y
chsh -s $(which zsh)

echo
echo "${GREEN}Zsh installed successfully.${NC}"
echo
echo "${RED}Log out and log back in for changes to take place${NC}"
echo
