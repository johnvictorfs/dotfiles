#!/usr/bin/env bash
source $HOME/dotfiles/helper.sh

if [ ! -x "$(command -v nvim)" ] ; then
  echo
  echo "${GREEN}Installing and setting up neovim...${NC}"
  echo

  startloading

  # Download nvim.appimage
  [ -d $HOME/snap ] || mkdir -p $HOME/snap
  wget --quiet -O $HOME/snap/nvim.appimage "https://github.com/neovim/neovim/releases/download/v0.4.3/nvim.appimage"
  chmod +x $HOME/snap/nvim.appimage
  sudo mv $HOME/snap/nvim.appimage /usr/bin/nvim
fi

# Plug package manager for Neovim/Vim: https://github.com/junegunn/vim-plug
curl -sfLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Backup current init.vim config if it exists
if [ -f $HOME/.config/nvim/init.vim ] ; then
  path="$HOME/.config/nvim/init.vim"
  backup_path="$HOME/.config/nvim/init.vim.backup"

  mv $path $backup_path
  echo -e "${ORANGE}Renamed current ${RED}${path}${NC} ${ORANGE}to ${GREEN}${backup_path}${NC}"
fi

# Symlink $HOME/dotfiles init.vim
[ -d $HOME/.config/nvim ] || mkdir -p $HOME/.config/nvim && echo "Created dir"
ln -sf $HOME/dotfiles/init.vim $HOME/.config/nvim

# Open Vim, run 'PlugInstall --sync' and quit
nvim +'PlugInstall --sync' +qa

# Py-n-vim
python3 -m pip install -q --user pynvim

endloading

echo "${GREEN}Finished installation and setup of Neovim${NC}"
echo
