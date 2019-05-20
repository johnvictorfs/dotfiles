#!/usr/bin/env bash
source $HOME/dotfiles/helper.sh

# Oh-my-zsh
sudo apt install curl -y
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Dracula gnome terminal color
sudo apt install dconf-cli -y
git clone https://github.com/GalaticStryder/gnome-terminal-colors-dracula --quiet
cd gnome-terminal-colors-dracula
./install.sh
cd .. && rm -rf gnome-terminal-colors-dracula

# Spaceship theme
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --quiet
ln -sf "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

# ZPlugin
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zplugin/master/doc/install.sh)"
