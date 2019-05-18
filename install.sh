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
    "curl"
    "nodejs"
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
    "tlp tlp-rdw"
)

read -p "${ORANGE}Do you want to install apt packages? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
    for package in "${apt_packages[@]}"; do
        echo
        echo "${ORANGE}Installing package ${GREEN}'${package}'${NC}"
        echo
        sudo apt install -y "${package}"
    done;
fi


if [ -x "$(command -v tlp)" ] ; then
    sudo tlp start
fi

# Installing brew
read -p "${ORANGE}Do you want to install ${GREEN}the brew package manager${ORANGE}? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
    sudo apt install -y curl
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
    
    # Adding brew to PATH
    test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
    test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
    echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
fi

# Installing pyenv
read -p "${ORANGE}Do you want to install ${GREEN}pyenv${ORANGE}? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
    sudo apt install -y curl
    curl https://pyenv.run | bash
fi

# Installing poetry
read -p "${ORANGE}Do you want to install ${GREEN}poetry${ORANGE}? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
    sudo apt install -y curl
    curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python3
fi

# Installing oh-my-bash
read -p "${ORANGE}Do you want to install and setup ${GREEN}oh-my-bash${ORANGE}? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
    sudo apt install -y curl
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
fi

# Installing py n vim
read -p "${ORANGE}Do you want to install ${GREEN}py-n-vim${ORANGE}? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
    pip3 install --user pynvim
fi

# Neovim: https://neovim.io
read -p "${ORANGE}Do you want to install ${GREEN}Neovim 0.3.4${ORANGE}? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
    mkdir $HOME/snap
    wget -O $HOME/snap/nvim.appimage "https://github.com/neovim/neovim/releases/download/v0.3.4/nvim.appimage"
    chmod a+x $HOME/snap/nvim.appimage

    # Plug package manager for Neovim/Vim: https://github.com/junegunn/vim-plug
    curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Mac-OS Sierra gtk Theme: https://github.com/vinceliuice/Sierra-gtk-theme
read -p $"${ORANGE}Do you wish to ${GREEN}install and set the theme to MacOS Dark Mojave gtk theme${ORANGE}? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
    echo "Installing MacOS Dark Mojave gtk theme..."
    cd /tmp
    if [ -d /tmp/Mc-OS-themes ] ; then
        rm -rf /tmp/Mc-OS-themes
    fi
    git clone https://github.com/paullinuxthemer/Mc-OS-themes.git
    cd Mc-OS-themes
    if [ ! -d $HOME/.themes ] ; then
        mkdir $HOME/.themes
    fi
    mv McOS-MJV-Dark-mode-Gnome-3.30 $HOME/.themes
    rm -rf /tmp/Mc-OS-themes
    gsettings set org.gnome.desktop.interface gtk-theme McOS-MJV-Dark-mode-Gnome-3.30
    gsettings set  org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'
fi

read -p "${ORANGE}Do you wish the install the ${GREEN}Plank dock${ORANGE}? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
    sudo apt install -y plank
    read -p "${ORANGE}Do you wish to install the paperterial theme for the plank dock? (It has to be turned on manually) (Y/n)${NC} " -n 1 -r 
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] ; then
        if [ ! -d $HOME/.local/share/plank/ ] ; then
            mkdir $HOME/.local/share/plank/
        fi
        if [ ! -d $HOME/.local/share/plank/themes ] ; then
            mkdir $HOME/.local/share/plank/themes
        fi
        if [ ! -d $HOME/.local/share/plank/themes/paperterial ] ; then
            mkdir $HOME/.local/share/plank/themes/paperterial
        fi
        wget -O $HOME/.local/share/plank/themes/paperterial/dock.theme "https://raw.githubusercontent.com/KenHarkey/plank-themes/master/paperterial/dock.theme"
    fi
    read -p "${ORANGE}Do you wish to replace the Gnome Dock with the Plank dock? (Y/n)${NC} " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] ; then
        echo -e "${GREEN}Setting plank to load on start up...${NC}"
        mkdir $HOME/.config/autostart
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
    if [ !-n "$ZSH_VERSION" ]; then
        chmod +x install-zsh.sh && ./install-zsh.sh
        echo "${RED}Re-run this script after you've done so${NC}"
        exit 0
    fi

    chmod +x install-oh-my-zsh.sh && ./install-oh-my-zsh.sh

    echo
    echo -e "${ORANGE}Backing up current dotfiles...${NC}"

    if [ ! -d $HOME/.config/nvim ] ; then
        mkdir $HOME/.config/nvim
    fi

    if [ -f $HOME/.env_vars ] ; then
        mv $HOME/.env_vars $HOME/.env_vars.backup # Backing up current .env_vars file
        echo -e "${ORANGE}Renamed current ${RED}~/.env_vars${NC} ${ORANGE}to ${GREEN}~/.env_vars.backup${NC}"
    fi

    if [ -f $HOME/.zshrc ] ; then
        mv $HOME/.zshrc $HOME/.zshrc.backup # Backing up current .zshrc file
        echo -e "${ORANGE}Renamed current ${RED}~/.zshrc${NC} ${ORANGE}to ${GREEN}~/.zshrc.backup${NC}"
    fi

    if [ -f $HOME/.aliases ] ; then
        mv $HOME/.aliases $HOME/.aliases.backup # Backing up current .aliases files
        echo -e "${ORANGE}Renamed current ${RED}~/.aliases${NC} ${ORANGE}to ${GREEN}~/.aliases.backup${NC}"
    fi

    if [ -f $HOME/.config/nvim/init.vim ] ; then
        mv $HOME/.config/nvim/init.vim $HOME/.config/nvim/init.vim.backup # Backing up current init.vim directory
        echo -e "${ORANGE}Renamed current ${RED}~/.config/nvim/init.vim${NC} ${ORANGE}to ${GREEN}~/.config/nvim/init.vim.backup${NC}"
    fi

    echo -e "${ORANGE}Symlinking dotfiles...${NC}"
    ln -sv $HOME/dotfiles/.zshrc $HOME
    ln -sv $HOME/dotfiles/.aliases $HOME
    ln -sv $HOME/dotfiles/init.vim $HOME/.config/nvim

    source $HOME/.zshrc

    echo
    echo "${GREEN}Finished symlinking dotfiles.${NC}"
    echo
fi



read -p "${ORANGE}Do you wish to change the Desktop Wallpaper to the Kali Linux image? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
    gsettings set org.gnome.desktop.background picture-uri file:///${HOME}/dotfiles/images/kali-linux-wallpaper.png
fi

chmod +x chrome.sh && ./chrome.sh
chmod +x snap_packages.sh && ./snap_packages.sh
chmod +x sublime.sh && ./sublime.sh
chmod +x vscode.sh && ./vscode.sh