#!/usr/bin/env bash
source $HOME/dotfiles/helper.sh

if [ ! -x "$(command -v nvim)" ]; then
  echo
  echo "${GREEN}Installing and setting up neovim...${NC}"
  echo

  paru -S neovim-nightly-bin
fi

if _NVIM="$(command -v nvim)"; then
  # Backup current neovim config if it exists
  if [ -d $HOME/.config/nvim ]; then
    path="$HOME/.config/nvim"
    backup="$HOME/.config/nvim_backup"

    mv $path $backup
    echo -e "${ORANGE}Renamed current ${RED}${path}${NC} ${ORANGE}to ${GREEN}${backup}${NC}"
  fi

  # Symlink neovim config files
  mkdir $HOME/.config/nvim
  ln -s $HOME/dotfiles/nvim/* $HOME/.config/nvim && \

  "${_NVIM}" +"autocmd User PackerComplete ++once quitall" \
          +":lua require 'pluginList' vim.cmd('PackerSync')"
        "${_NVIM}"
fi
