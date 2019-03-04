# Installing and setting up my most used packages
sudo apt-get install -y zsh
sudo apt-get install -y git
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
sudo apt-get install -y fonts-powerline
sudo apt-get install -y nodejs
sudo apt-get install -y tree
sudo apt-get install -y shutter
sudo apt-get install -y tmux
sudo apt-get install -y python3.7
sudo apt-get install -y python3.7-venv
sudo apt-get install -y python3-pip
sudo apt-get install -y sqlite3
sudo apt-get install -y gnome-disk-utility
sudo apt-get install -y gnome-software
sudo apt-get install -y elementary-tweaks
curl https://pyenv.run | bash
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python

pip3 install --user pynvim

# Neovim: https://neovim.io
mkdir ~/snap
wget -O ~/snap/nvim.appimage "https://github.com/neovim/neovim/releases/download/v0.3.4/nvim.appimage"
chmod a+x ~/snap/nvim.appimage

# Plug package manager for Neovim/Vim: https://github.com/junegunn/vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Mac-OS Sierra gtk Theme: https://github.com/vinceliuice/Sierra-gtk-theme
sudo add-apt-repository ppa:dyatlov-igor/sierra-theme
sudo apt update
sudo apt-get install -y sierra-gtk-theme
gsettings set org.gnome.desktop.interface gtk-theme Sierra-dark

# Flat-remix Icons: https://github.com/daniruiz/flat-remix
cd /tmp && rm -rf flat-remix &&
git clone https://github.com/daniruiz/flat-remix &&
mkdir -p ~/.icons && cp -r flat-remix/Flat-Remix* ~/.icons/ &&
gsettings set org.gnome.desktop.interface icon-theme "Flat-Remix-Red-Dark"

mkdir ~/.local/share/plank/themes/paperterial &&
wget -O ~/.local/share/plank/themes/paperterial/dock.theme "https://raw.githubusercontent.com/KenHarkey/plank-themes/master/paperterial/dock.theme"

# Installing and Symlinking dotfiles
git clone https://github.com/johnvictorfs/dotfiles.git ~/.zsh/dotfiles/ &&
mkdir ~/.config/nvim
mv ~/.zshrc ~/.zshrc.backup && # Backing up current .zshrc file
mv ~/.config/nvim/init.vim ~/.config/nvim/init.vim.backup # Backing up current init.vim directory
ln -sv ~/.zsh/dotfiles/.zshrc ~ &&
ln -sv ~/.zsh/dotfiles/init.vim ~/.config/nvim

killall -HUP gala

chsh -s $(which zsh) # Use zsh instead of bash