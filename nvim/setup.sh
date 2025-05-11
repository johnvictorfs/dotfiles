#!/usr/bin/env bash
source $HOME/dotfiles/helper.sh

if [ ! -x "$(command -v nvim)" ]; then
  echo
  echo "${GREEN}Installing neovim...${NC}"
  echo

  paru -S neovim
fi

# TODO: Backup automatically
if [ -d $HOME/.config/nvim ]; then
  echo "${RED}Exiting. Nvim config already exists, back it up and delete it first.${NC}"
  exit 1
fi

ln -s $HOME/dotfiles/nvim $HOME/.config

echo "${GREEN}Setup neovim config${NC}"
