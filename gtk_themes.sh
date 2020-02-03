#!/usr/bin/env bash
source $HOME/dotfiles/helper.sh

mkdir -p $HOME/.themes

declare -A themes=(
  ["Nordic"]="EliverLara/Nordic"
  ["Ant-Dracula"]="EliverLara/Ant-Dracula"
)

for theme in "${!themes[@]}"; do
  read -p "${ORANGE}Do you wish to install the GTK theme ${GREEN}${theme}${ORANGE}? (Y/n)${NC} " -n 1 -r
  echo

  if [[ $REPLY =~ ^[Yy]$ ]] ; then
    path="$HOME/.themes/${theme}"
    
    if [[ -d "${path}" ]] ; then
      echo "${GREEN}${theme}${RED} theme is already installed.${NC}"
    else
      git clone --quiet "https://github.com/${themes[$theme]}.git" "${path}"
      echo "${ORANGE}Installed Theme '${theme}' at ${GREEN}${path}${NC}"
    fi

    read -p "${ORANGE}Do you wish to set the GTK theme to ${GREEN}${theme}${ORANGE}? (Y/n)${NC} " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]] ; then
      gsettings set org.gnome.desktop.interface gtk-theme "${theme}"
      gsettings set org.gnome.desktop.wm.preferences theme "${theme}"
    fi
  fi
done

