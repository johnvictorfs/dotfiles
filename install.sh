#!/usr/bin/env bash
source $HOME/dotfiles/helper.sh

# Start tlp if installed
if [ -x "$(command -v tlp)" ] ; then
  sudo tlp start
fi

# Add Flathub flatpak repository if flatpak is installed
if [ -x "$(command -v flatpak)" ] ; then
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

# Installing Yarn
echo
read -p "${ORANGE}Do you want to install ${GREEN}Yarn${ORANGE}? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
  sudo pacman -Syu yarn
fi

# Neovim: https://neovim.io
read -p "${ORANGE}Do you want to install and setup ${GREEN}Neovim ${ORANGE}? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
    cd $HOME/dotfiles
    ./nvim_setup.sh
fi

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

chmod +x vscode.sh && ./vscode.sh

