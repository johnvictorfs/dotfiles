#!/usr/bin/env bash
source $HOME/dotfiles/helper.sh

# Options: 'paru', 'yay'
AUR_HELPER=paru

# Install AUR helper if necessary
./$AUR_HELPER.sh

IMAGES_FOLDER=$HOME/dotfiles/images

PACKAGES=(
  # Browser
  firefox
  google-chrome

  # Work messaging app
  slack-electron

  # Godly CLI fuzzy-finder
  fzf

  # Alternative to 'find', to be used with fzf
  fd

  # Go programming language, peer dependency of some things
  go

  # Node.js package manager
  yarn

  # Chat app
  telegram-desktop

  # Themes
  breeze-obsidian-cursor-theme # Cursor theme, AUR
  papirus-icon-theme # Icons theme
  nordic-theme-git # GTK theme, AUR
  materia-gtk-theme # GTK theme

  # Alternative to ls
  exa

  # Python Package Manager
  python-pip

  # Fonts
  adobe-source-han-sans-jp-fonts # Font for kanji/hiragana/katakana
  ttf-jetbrains-mono
  ttf-fantasque-sans-mono
  ttf-font-awesome
  ttf-google-sans # AUR
  ttf-material-design-icons # AUR
  nerd-fonts-fira-code # AUR
  noto-fonts
  noto-fonts-cjk

  # i3 setup
  i3-gaps-rounded-git # i3 with gaps and rounded corners, AUR
  i3exit # Suspend/lock etc. commands and screens
  polybar # Status bar
  picom # Compositor
  rofi-git # Fancier dmenu, AUR version
  dunst # Notification daemon
  arandr # Multi-monitor setup

  # Terminal Emulator
  kitty

  # Display Manager (Login screen)
  lightdm
  lightdm-gtk-greeter

  # File manager
  nautilus

  # Audio CLI
  ffmpeg

  # Ruby stuff
  rbenv
  ruby-build

  # Telegram Client
  telegram-desktop

  # Development stuff
  postgresql
  heroku-cli 

  # Night light
  redshift

  # GTK Theme Settings
  lxappearance-gtk3

  # Syntax highlighting for ccat
  highlight

  # PDF Viewer
  # evince # GTK pdf viewer
  zathura
  zathura-pdf-mupdf

  # e-Book reader
  foliate

  # Latex stuff
  pdftk # Latex compiler
  biber # Latex Bibliography
  texlive-most # Useful latex stuff like a bunch of optional packages
  texlive-lang # Other languages support, accents, symbols etc.
  texlive-fontsextra # Extra latex fonts
  minted # Code syntax highlighting

  # Video Player
  mpv

  # Bluetooth
  # bluez
  # bluez-utils

  # Misc. utils
  light # Brightness commands
  nitrogen # Wallpaper manager
  calc # Terminal calculator
  python-dbus # Python API for dbus
  xclip # Clipboard utils
  maim # Screenshots

  # Audio Management
  pulseaudio
  pavucontrol
)

PYTHON_PACKAGES=(
  bs4 # BeautifulSoup
  html5lib # Html parser
  i3ipc # i3 events stuff API
  fontawesome # Fontawesome icon names API for python
)

# Install needed packages
input "${ORANGE}Install/upgrade needed packages with $AUR_HELPER and pip?"
if [ $ANSWER ]; then
  # Package list to space-separated string
  PACKAGES_STR=$( IFS=$' '; echo "${PACKAGES[*]}" )
  [ $(command -v $AUR_HELPER) ] && $AUR_HELPER -Syu $PACKAGES_STR || echo "${RED}Skipping installation. $AUR_HELPER not installed.${NC}"

  # Install Python packages
  PACKAGES_PYTHON_STR=$( IFS=$' '; echo "${PYTHON_PACKAGES[*]}" )
  [ $(command -v pip) ] && pip install --user $PACKAGES_PYTHON_STR || echo "${RED}Skipping installation. Pip not installed.${NC}"
fi

### i3-gaps
if [ -f $HOME/.config/i3/config ]; then
  # Backing up old i3 config file
  rm -rf $HOME/.config/i3/config.backup
  mv $HOME/.config/i3/config $HOME/.config/i3/config.backup
  echo -e "${ORANGE}Renamed current ${RED}~/.config/i3/config${NC} ${ORANGE}to ${GREEN}~/.config/i3/config.backup${NC}"
fi

# Symlink binaries
[ -d $HOME/.bin ] || ln -s $HOME/dotfiles/.bin $HOME/

# Create i3 config dir if it doesn't exist already
mkdir -p $HOME/.config/i3

# Symlink kitty config files from git repo to configs
ln -sf $HOME/dotfiles/i3/config $HOME/.config/i3

# Symlink .profile
ln -sf $HOME/dotfiles/.profile $HOME

# Symlink dunst settings
ln -sf $HOME/dotfiles/dunst $HOME/.config

### Kitty Terminal
if [ -f $HOME/.config/kitty/kitty.conf ]; then
  # Backing up old kitty config file
  rm -rf $HOME/.config/kitty/kitty.conf.backup
  mv $HOME/.config/kitty/kitty.conf $HOME/.config/kitty/kitty.conf.backup
  echo -e "${ORANGE}Renamed current ${RED}~/.config/kitty/kitty.conf${NC} ${ORANGE}to ${GREEN}~/.config/kitty/kitty.conf.backup${NC}"
fi

# Create kitty config dir if it doesn't exist already
[ -d $HOME/.config/kitty ] || mkdir -p $HOME/.config/kitty

# Symlink kitty config files from git repo to configs
ln -sf $HOME/dotfiles/kitty/kitty.conf $HOME/.config/kitty

### Polybar
if [ -d $HOME/.config/polybar ]; then
  rm -rf $HOME/.config/polybar.backup
  mv $HOME/.config/polybar $HOME/.config/polybar.backup
  echo -e "${ORANGE}Renamed current ${RED}~/.config/polybar${NC} ${ORANGE}to ${GREEN}~/.config/polybar.backup${NC}"
fi

ln -sf $HOME/dotfiles/polybar $HOME/.config

### picom
if [ -d $HOME/.config/picom ]; then
  rm -rf $HOME/.config/picom.backup
  mv $HOME/.config/picom $HOME/.config/picom.backup
  echo -e "${ORANGE}Renamed current ${RED}~/.config/picom${NC} ${ORANGE}to ${GREEN}~/.config/picom.backup${NC}"
fi

# Rofi config
[ -d $HOME/.config/rofi ] && input "${ORANGE}Replace rofi config?"
[ $ANSWER ] && [ -d $HOME/.config/rofi ] || ln -sf $HOME/dotfiles/rofi $HOME/.config

ln -sf $HOME/dotfiles/picom $HOME/.config

# Start tlp if installed
if [ -x "$(command -v tlp)" ]; then
  input "${ORANGE}Start tlp battery saver?"

  [ $ANSWER ] && sudo tlp start
fi

# Add Flathub flatpak repository if flatpak is installed
if [ -x "$(command -v flatpak)" ]; then
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

input "${ORANGE}Replace neofetch config?"
if [ $ANSWER ]; then
  mkdir -p $HOME/.config/neofetch/
  NEOFETCH_PATH=$HOME/.config/neofetch/config.conf
  BACKUP_PATH=$HOME/.config/neofetch/config.conf.backup
  MESSAGE="${ORANGE}Backed up current neofetch config to '$BACKUP_PATH'${NC}"

  [ -f $NEOFETCH_PATH ] && mv $NEOFETCH_PATH $BACKUP_PATH && echo $MESSAGE

  ln -sf $HOME/dotfiles/neofetch/config.conf $HOME/.config/neofetch
fi

# Add images folder to nitrogen
[ $(command -v nitrogen) ] && input "${ORANGE}Update wallpaper with nitrogen?"
[ $ANSWER ] && [ $(command -v nitrogen) ] && nitrogen --set-auto $IMAGES_FOLDER/solid_wallpaper_2.png

