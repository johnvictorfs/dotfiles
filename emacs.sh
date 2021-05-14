#!/usr/bin/env bash
source $HOME/dotfiles/helper.sh

if [ ! -x "$(command -v emacs)" ]; then
  echo
  echo "${GREEN}Installing and setting up emacs...${NC}"
  echo

  sudo pacman -S emacs
fi

# Backup current init.el config if it exists
if [ -f $HOME/.config/emacs/init.el ]; then
  path="$HOME/.config/emacs/init.el"
  backup="$HOME/.config/emacs/init.el.backup"

  mv $path $backup_path
  echo -e "${ORANGE}Renamed current ${RED}${path}${NC} ${ORANGE}to ${GREEN}${backup}${NC}"
fi

# Symlink $HOME/dotfiles init.el
[ -d $HOME/.config/emacs ] || mkdir -p $HOME/.config/emacs
ln -sf $HOME/dotfiles/emacs/init.el $HOME/.config/emacs

echo "${GREEN}Finished installation and setup of Emacs${NC}"
echo

