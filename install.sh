#!/usr/bin/env bash

ORANGE=$'\e[33m'
GREEN=$'\e[32m'
RED=$'\e[31m'
NC=$'\e[0m'

read -p "${ORANGE}Do you want to run ${GREEN}'sudo apt update'${ORANGE}? (Y/n)${NC} " -n 1 -r
echo
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
    sudo apt update
fi

# Installing apt packages
declare -a apt_packages=(
	"gnome-tweak-tool"
    "git"
    "fonts-powerline"
    "fonts-firacode"
    "postgresql postgresql-contrib"
    "tree"
    "tmux"
    "python3.7"
    "python3.7-venv"
    "python3-pip"
    "python3-tk"
    "sqlite3"
)

for package in "${apt_packages[@]}"; do
    read -p "${ORANGE}Do you want to install ${package}? (Y/n)${NC} " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] ; then
        sudo apt install -y "${package}"
    fi
done;

# Installing pyenv
read -p "${ORANGE}Do you want to install pyenv? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
    curl https://pyenv.run | bash
fi

# Installing poetry
read -p "${ORANGE}Do you want to install poetry? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
    curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python
fi

# Installing oh-my-bash
read -p "${ORANGE}Do you want to install and setup oh-my-bash? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
fi

# Installing py n vim
read -p "${ORANGE}Do you want to install py-n-vim? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
    pip3 install --user pynvim
fi

# Installing Nodejs 11.X (comes with npm)
read -p "${ORANGE}Do you want to install Node.js 11.X + Npm? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
    sudo apt install -y curl python-software-properties
    curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -
fi

# Neovim: https://neovim.io
read -p "${ORANGE}Do you want to install Neovim 0.3.4? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
    mkdir $HOME/snap
    wget -O $HOME/snap/nvim.appimage "https://github.com/neovim/neovim/releases/download/v0.3.4/nvim.appimage"
    chmod a+x $HOME/snap/nvim.appimage

    # Plug package manager for Neovim/Vim: https://github.com/junegunn/vim-plug
    curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Mac-OS Sierra gtk Theme: https://github.com/vinceliuice/Sierra-gtk-theme
read -p $"${ORANGE}Do you wish to install and set the theme to Sierra-dark gtk theme? (Y/n)${NC}${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
    echo "Installing Sierra-dark gtk theme..."
    sudo add-apt-repository ppa:dyatlov-igor/sierra-theme -y
    sudo apt update
    sudo apt install -y sierra-gtk-theme
    gsettings set org.gnome.desktop.interface gtk-theme Sierra-dark
fi

read -p $"${ORANGE}Do you wish to install and set the icons theme to Flat-remix icons? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
    # Flat-remix Icons: https://github.com/daniruiz/flat-remix
    cd /tmp && rm -rf flat-remix &&
    git clone https://github.com/daniruiz/flat-remix &&
    mkdir -p $HOME/.icons && cp -r flat-remix/Flat-Remix* $HOME/.icons/ &&
    gsettings set org.gnome.desktop.interface icon-theme "Flat-Remix-Red-Dark"
fi

read -p "${ORANGE}Do you wish the install the Plank dock? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
    sudo apt install -y plank
    read -p "${ORANGE}Do you wish to install the paperterial theme for the plank dock? (It has to be turned on manually) (Y/n)${NC} " -n 1 -r 
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] ; then
        mkdir $HOME/.local/share/plank/themes/paperterial &&
        wget -O $HOME/.local/share/plank/themes/paperterial/dock.theme "https://raw.githubusercontent.com/KenHarkey/plank-themes/master/paperterial/dock.theme"
    fi
    read -p "${ORANGE}Do you wish to replace the Gnome Dock with the Plank dock? (Y/n)${NC} " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] ; then
        echo -e "${GREEN}Setting plank to load on start up...${NC}"
        cp plank.desktop $HOME/.config/autostart/
        plank
        echo -e "${GREEN}Disabling Gnome Dock...${NC}"
        gsettings set org.gnome.shell.extensions.dash-to-dock autohide false
        gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
        gsettings set org.gnome.shell.extensions.dash-to-dock intellihide false
    fi
fi

read -p "${ORANGE}Do you want to replace your current dotfiles with the new ones? Backups will be made (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
	echo
    echo -e "${ORANGE}Backing up current dotfiles...${NC}"

    if [ ! -d $HOME/.config/nvim ] ; then
		mkdir $HOME/.config/nvim
	fi

	if [ -f $HOME/.env_vars ] ; then
		mv $HOME/.env_vars $HOME/.env_vars.backup # Backing up current .env_vars file
		echo -e "${ORANGE}Renamed current ${RED}~/.env_vars${NC} ${ORANGE}to ${GREEN}~/.env_vars.backup${NC}"
	fi

	if [ -f $HOME/.bashrc ] ; then
		mv $HOME/.bashrc $HOME/.bashrc.backup # Backing up current .bashrc file
		echo -e "${ORANGE}Renamed current ${RED}~/.bashrc${NC} ${ORANGE}to ${GREEN}~/.bashrc.backup${NC}"
	fi

	if [ -f $HOME/.aliases ] ; then
		mv $HOME/.aliases $HOME/.aliases.backup # Backing up current .aliases files
		echo -e "${ORANGE}Renamed current ${RED}~/.aliases${NC} ${ORANGE}to ${GREEN}~/.aliases.backup${NC}"
	fi

    if [ -f $HOME/.bash_prompt ] ; then
        mv $HOME/.bash_prompt $HOME/.bash_prompt.backup # Backing up current .bash_prompt files
        echo -e "${ORANGE}Renamed current ${RED}~/.bash_prompt${NC} ${ORANGE}to ${GREEN}~/.bash_prompt.backup${NC}"
    fi

	if [ -f $HOME/.config/nvim/init.vim ] ; then
		mv $HOME/.config/nvim/init.vim $HOME/.config/nvim/init.vim.backup # Backing up current init.vim directory
		echo -e "${ORANGE}Renamed current ${RED}~/.config/nvim/init.vim${NC} ${ORANGE}to ${GREEN}~/.config/nvim/init.vim.backup${NC}"
	fi

	echo -e "${ORANGE}Symlinking dotfiles...${NC}"
	ln -sv $HOME/dotfiles/.bashrc $HOME
	ln -sv $HOME/dotfiles/.aliases $HOME
    ln -sv $HOME/dotfiles/.bash_prompt $HOME
	ln -sv $HOME/dotfiles/init.vim $HOME/.config/nvim
	# echo
	# echo -e "${RED}If you haven't yet, you will probably need to change your terminal font to a powerline-compatible font like 'hack'.${NC}"
	# echo

	source $HOME/.bashrc
fi

echo
echo "${GREEN}Finished symlinking dotfiles.${NC}"
echo

read -p "${ORANGE}Do you wish to change the Desktop Wallpaper to the Kali Linux image? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
    gsettings set org.gnome.desktop.background picture-uri file:///${HOME}/dotfiles/images/kali-linux-wallpaper.png
fi

chmod a+x snap_packages.sh && ./snap_packages.sh
chmod a+x sublime.sh && ./sublime.sh
