#!/usr/bin/env bash
source $HOME/dotfiles/helper.sh

# Install yay package manager
./yay_setup.sh

# Install needed packages
yay -Syu i3-gaps-rounded-git kitty light rofi polybar feh bluez bluez-utils python-dbus netctl wpa_supplicant dhcpcd scrot xclip calc redshift i3exit lxappearance

# Needed for weather polybar script
pip install --user bs4 html5lib 

### i3-gaps
if [ -f $HOME/.config/i3/config ] ; then
  # Backing up old i3 config file
  rm -rf $HOME/.config/i3/config.backup
  mv $HOME/.config/i3/config $HOME/.config/i3/config.backup
  echo -e "${ORANGE}Renamed current ${RED}~/.config/i3/config${NC} ${ORANGE}to ${GREEN}~/.config/i3/config.backup${NC}"
fi

# Symlink fonts folder
ln -s $HOME/dotfiles/.fonts $HOME/.fonts

# Symlink binaries
ln -s $HOME/dotfiles/.bin $HOME/.bin

# Create kitty config dir if it doesn't exist already
mkdir -p $HOME/.config/i3

# Symlink kitty config files from git repo to configs
ln -sf $HOME/dotfiles/i3/config $HOME/.config/i3

# Symlink .profile
ln -sf $HOME/dotfiles/.profile $HOME

### Kitty Terminal
if [ -f $HOME/.config/kitty/kitty.conf ] ; then
  # Backing up old kitty config file
  rm -rf $HOME/.config/kitty/kitty.conf.backup
  mv $HOME/.config/kitty/kitty.conf $HOME/.config/kitty/kitty.conf.backup
  echo -e "${ORANGE}Renamed current ${RED}~/.config/kitty/kitty.conf${NC} ${ORANGE}to ${GREEN}~/.config/kitty/kitty.conf.backup${NC}"
fi

# Create kitty config dir if it doesn't exist already
mkdir -p $HOME/.config/kitty

# Symlink kitty config files from git repo to configs
ln -sf $HOME/dotfiles/kitty/kitty.conf $HOME/.config/kitty

### Rofi
if [ -f $HOME/.config/rofi/colors.rasi ] ; then
  rm -rf $HOME/.config/rofi/*.backup
  mv $HOME/.config/rofi/colors.rasi $HOME/.config/rofi/colors.rasi.backup
  echo -e "${ORANGE}Renamed current ${RED}~/.config/rofi/colors.rasi${NC} ${ORANGE}to ${GREEN}~/.config/rofi/colors.rasi.backup${NC}"
fi
if [ -f $HOME/.config/rofi/default2.rasi ] ; then
  mv $HOME/.config/rofi/default2.rasi $HOME/.config/rofi/default2.rasi.backup
  echo -e "${ORANGE}Renamed current ${RED}~/.config/rofi/default2.rasi${NC} ${ORANGE}to ${GREEN}~/.config/rofi/default2.rasi.backup${NC}"
fi

mkdir -p $HOME/.config
ln -sf $HOME/dotfiles/rofi/colors.rasi $HOME/.config/rofi
ln -sf $HOME/dotfiles/rofi/default2.rasi $HOME/.config/rofi

### Polybar
if [ -d $HOME/.config/polybar ] ; then
  rm -rf $HOME/.config/polybar.backup
  mv $HOME/.config/polybar $HOME/.config/polybar.backup
  echo -e "${ORANGE}Renamed current ${RED}~/.config/polybar${NC} ${ORANGE}to ${GREEN}~/.config/polybar.backup${NC}"
fi

ln -sf $HOME/dotfiles/polybar $HOME/.config

### Compton
if [ -d $HOME/.config/compton ] ; then
  rm -rf $HOME/.config/compton.backup
  mv $HOME/.config/compton $HOME/.config/compton.backup
  echo -e "${ORANGE}Renamed current ${RED}~/.config/compton${NC} ${ORANGE}to ${GREEN}~/.config/compton.backup${NC}"
fi

ln -sf $HOME/dotfiles/compton $HOME/.config

# Start tlp if installed
if [ -x "$(command -v tlp)" ] ; then
  sudo tlp start
fi

# Add Flathub flatpak repository if flatpak is installed
if [ -x "$(command -v flatpak)" ] ; then
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

