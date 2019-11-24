#!/usr/bin/env bash
source $HOME/dotfiles/helper.sh

sudo apt -qq update

declare -a apt_packages=(
  "ranger"
  "xterm"
  "curl"
  "neofetch"
  "nodejs"
  "gnome-tweak-tool"
  "git"
  "fonts-powerline"
  "fonts-firacode"
  "postgresql"
  "postgresql-contrib"
  "tree"
  "tmux"
  "python3.7"
  "python3.7-venv"
  "python3-pip"
  "python3-tk"
  "sqlite3"
  "tlp"
  "tlp-rdw"
)

for package in "${apt_packages[@]}"; do
  startloading
  echo "${ORANGE}Installing ${GREEN}${package}${NC}..."
  sudo apt-get -qq install -y "${package}" > /dev/null && echo && echo "${GREEN}Finished installing ${GREEN}${package}${NC}"
  endloading
  sleep 0.5
done;

echo "${GREEN}Finished installing apt packages.${NC}"
