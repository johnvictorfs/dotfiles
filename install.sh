ORANGE=$'\e[33m'
NC=$'\e[0m'

# Installing and setting up my most used packages
sudo apt install -y git
sudo apt install -y fonts-powerline
sudo apt install -y nodejs
sudo apt install -y tree
sudo apt install -y tmux
sudo apt install -y python3.7
sudo apt install -y python3.7-venv
sudo apt install -y python3-pip
sudo apt install -y sqlite3
curl https://pyenv.run | bash
curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
pip3 install --user pynvim

# Neovim: https://neovim.io
mkdir ~/snap
wget -O ~/snap/nvim.appimage "https://github.com/neovim/neovim/releases/download/v0.3.4/nvim.appimage"
chmod a+x ~/snap/nvim.appimage

# Plug package manager for Neovim/Vim: https://github.com/junegunn/vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Mac-OS Sierra gtk Theme: https://github.com/vinceliuice/Sierra-gtk-theme
read -p $"${ORANGE}Do you wish to install and set the theme to Sierra-dark gtk theme? (Y/n)${NC}${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
    echo "Installing Sierra-dark gtk theme..."
    sudo add-apt-repository ppa:dyatlov-igor/sierra-theme
    sudo apt update
    sudo apt install -y sierra-gtk-theme
    gsettings set org.gnome.desktop.interface gtk-theme Sierra-dark
fi

read -p $"${ORANGE}Do you wish to set the icons theme to Flat-remix icons? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
    # Flat-remix Icons: https://github.com/daniruiz/flat-remix
    cd /tmp && rm -rf flat-remix &&
    git clone https://github.com/daniruiz/flat-remix &&
    mkdir -p ~/.icons && cp -r flat-remix/Flat-Remix* ~/.icons/ &&
    gsettings set org.gnome.desktop.interface icon-theme "Flat-Remix-Red-Dark"
fi

read -p $"${ORANGE}Do you wish the install the plank dock? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
    sudo apt install -y plank
    read -p $"${ORANGE}Do you wish to install the paperterial theme for the plank dock? (It has to be turned on manually) (Y/n)${NC} " -n 1 -r 
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] ; then
        mkdir ~/.local/share/plank/themes/paperterial &&
        wget -O ~/.local/share/plank/themes/paperterial/dock.theme "https://raw.githubusercontent.com/KenHarkey/plank-themes/master/paperterial/dock.theme"
    fi
fi

echo -e "${ORANGE}Backing up current dotfiles...${NC}"
mkdir ~/.config/nvim
mv ~/.env_vars ~/.env_vars.backup # Backing up current .env_vars file
mv ~/.bashrc ~/.bashrc.backup # Backing up current .bashrc file
mv ~/.aliases ~/.aliases.backup # Backing up current .aliases files
mv ~/.config/nvim/init.vim ~/.config/nvim/init.vim.backup # Backing up current init.vim directory

touch ~/.env_vars # Creating .env_vars files, not in repo because it's to be used for secret env vars

echo -e "${ORANGE}Symlinking dotfiles...${NC}"
ln -sv ~/dotfiles/.bashrc ~
ln -sv ~/dotfiles/.aliases ~
ln -sv ~/dotfiles/init.vim ~/.config/nvim

source ~/.bashrc