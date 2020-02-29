# Install needed packages
sudo pacman -Syu i3-gaps i3status kitty polybar feh bluez bluez-utils

### i3-gaps
if [ -f $HOME/.config/i3/config ] ; then
  # Backing up old i3 config file
  mv $HOME/.config/i3/config $HOME/.config/i3/config.backup
  echo -e "${ORANGE}Renamed current ${RED}~/.config/i3/config${NC} ${ORANGE}to ${GREEN}~/.config/i3/config.backup${NC}"
fi

# Create kitty config dir if it doesn't exist already
mkdir -p $HOME/.config/i3

# Symlink kitty config files from git repo to configs
ln -sf $HOME/dotfiles/i3/config $HOME/.config/i3

### Kitty Terminal
if [ -f $HOME/.config/kitty/kitty.conf ] ; then
  # Backing up old kitty config file
  mv $HOME/.config/kitty/kitty.conf $HOME/.config/kitty/kitty.conf.backup
  echo -e "${ORANGE}Renamed current ${RED}~/.config/kitty/kitty.conf${NC} ${ORANGE}to ${GREEN}~/.config/kitty/kitty.conf.backup${NC}"
fi

# Create kitty config dir if it doesn't exist already
mkdir -p $HOME/.config/kitty

# Symlink kitty config files from git repo to configs
ln -sf $HOME/dotfiles/kitty/kitty.conf $HOME/.config/kitty

