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
    mkdir ~/snap
    wget -O ~/snap/nvim.appimage "https://github.com/neovim/neovim/releases/download/v0.3.4/nvim.appimage"
    chmod a+x ~/snap/nvim.appimage

    # Plug package manager for Neovim/Vim: https://github.com/junegunn/vim-plug
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
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
    mkdir -p ~/.icons && cp -r flat-remix/Flat-Remix* ~/.icons/ &&
    gsettings set org.gnome.desktop.interface icon-theme "Flat-Remix-Red-Dark"
fi

read -p "${ORANGE}Do you wish the install the Plank dock? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
    sudo apt install -y plank
    read -p "${ORANGE}Do you wish to install the paperterial theme for the plank dock? (It has to be turned on manually) (Y/n)${NC} " -n 1 -r 
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] ; then
        mkdir ~/.local/share/plank/themes/paperterial &&
        wget -O ~/.local/share/plank/themes/paperterial/dock.theme "https://raw.githubusercontent.com/KenHarkey/plank-themes/master/paperterial/dock.theme"
    fi
    read -p "${ORANGE}Do you wish to replace the Gnome Dock with the Plank dock? (Y/n)${NC} " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] ; then
        echo -e "${GREEN}Setting plank to load on start up...${NC}"
        cp plank.desktop ~/.config/autostart/
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
    echo -e "${ORANGE}Backing up current dotfiles...${NC}"
	mkdir ~/.config/nvim
	mv ~/.env_vars ~/.env_vars.backup # Backing up current .env_vars file
	echo -e "${ORANGE}Backed up ${RED}.bashrc${NC} ${ORANGE}to ${GREEN}.bashrc.backup${NC}"
	mv ~/.bashrc ~/.bashrc.backup # Backing up current .bashrc file
	echo -e "${ORANGE}Backed up ${RED}.aliases${NC} ${ORANGE}to ${GREEN}.aliases.backup${NC}"
	mv ~/.aliases ~/.aliases.backup # Backing up current .aliases files
	echo -e "${ORANGE}Backed up ${RED}init.vim${NC} ${ORANGE}to ${GREEN}init.vim.backup${NC}"
	mv ~/.config/nvim/init.vim ~/.config/nvim/init.vim.backup # Backing up current init.vim directory

	touch ~/.env_vars # Creating .env_vars files, not in repo because it's to be used for secret env vars

	echo -e "${ORANGE}Symlinking dotfiles...${NC}"
	ln -sv ~/dotfiles/.bashrc ~
	ln -sv ~/dotfiles/.aliases ~
	ln -sv ~/dotfiles/init.vim ~/.config/nvim
	echo
	echo -e "${RED}If you haven't yet, you will probably need to change your terminal font to a powerline-compatible font like 'hack'.${NC}"
	echo

	source ~/.bashrc
fi

read -p "${ORANGE}Do you wish to change the Desktop Wallpaper to the Kali Linux image? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
    gsettings set org.gnome.desktop.background picture-uri file:///${HOME}/dotfiles/images/kali-linux-wallpaper.png
fi

echo
echo "${GREEN}Finished symlinking dotfiles.${NC}"
echo

chmod a+x snap_packages.sh && ./snap_packages.sh
chmod a+x sublime.sh && ./sublime.sh
