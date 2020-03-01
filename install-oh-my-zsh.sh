#!/usr/bin/env bash

read -p "${ORANGE}Do you want to replace your current dotfiles with the new ones? (.aliases and .zshrc) Backups will be made (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
  cd $HOME/dotfiles
  if [ ! -x "$(command -v zsh)" ]; then
    chmod +x install-zsh.sh && ./install-zsh.sh
    echo "${RED}Re-run this script after you've done so${NC}"
    exit 0
  fi

  chmod +x install-oh-my-zsh.sh && ./install-oh-my-zsh.sh

  echo
  echo -e "${ORANGE}Backing up current dotfiles...${NC}"

  if [ -f $HOME/.zshrc ] ; then
    mv $HOME/.zshrc $HOME/.zshrc.backup # Backing up current .zshrc file
    echo -e "${ORANGE}Renamed current ${RED}~/.zshrc${NC} ${ORANGE}to ${GREEN}~/.zshrc.backup${NC}"
  fi

  if [ -f $HOME/.aliases ] ; then
    mv $HOME/.aliases $HOME/.aliases.backup # Backing up current .aliases files
    echo -e "${ORANGE}Renamed current ${RED}~/.aliases${NC} ${ORANGE}to ${GREEN}~/.aliases.backup${NC}"
  fi

  echo -e "${ORANGE}Symlinking dotfiles...${NC}"
  ln -sf $HOME/dotfiles/.zshrc $HOME
  ln -sf $HOME/dotfiles/.aliases $HOME

  source $HOME/.zshrc

  echo
  echo "${GREEN}Finished symlinking dotfiles.${NC}"
  echo
fi

# Zgen plugin manager for ZSH
# https://github.com/tarjoilija/zgen
git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"

# Zinit plugin manager for ZSH
# https://github.com/tarjoilija/zgen
mkdir "${HOME}/.zinit"
git clone https://github.com/zdharma/zinit.git "${HOME}/.zinit/bin"

