#!/usr/bin/env bash
source $HOME/dotfiles/helper.sh

mkdir -p $HOME/.themes

echo "Installing Nordic theme..."
git clone --quiet https://github.com/EliverLara/Nordic.git $HOME/.themes/Nordic

read -p "${ORANGE}Do you wish to set the GTK theme to Nordic? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
  gsettings set org.gnome.desktop.interface gtk-theme "Nordic"
  gsettings set org.gnome.desktop.wm.preferences theme "Nordic"
fi

