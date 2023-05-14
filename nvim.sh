#!/usr/bin/env bash
source $HOME/dotfiles/helper.sh

if [ ! -x "$(command -v nvim)" ]; then
  echo
  echo "${GREEN}Installing neovim...${NC}"
  echo

  paru -S neovim
fi

echo "${GREEN}Installing LunarVim...${NC}"

# https://www.lunarvim.org/docs/installation
LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)
