#!/usr/bin/env bash
source $HOME/dotfiles/helper.sh

if [ ! -x "$(command -v nvim)" ]; then
  echo
  echo "${GREEN}Installing and setting up neovim...${NC}"
  echo

  sudo pacman -S neovim
fi

# Plug package manager for Neovim/Vim: https://github.com/junegunn/vim-plug
curl -sfLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Backup current init.vim config if it exists
if [ -f $HOME/.config/nvim/init.vim ]; then
  path="$HOME/.config/nvim/init.vim"
  backup="$HOME/.config/nvim/init.vim.backup"

  mv $path $backup_path
  echo -e "${ORANGE}Renamed current ${RED}${path}${NC} ${ORANGE}to ${GREEN}${backup}${NC}"
fi

# Symlink $HOME/dotfiles init.vim
[ -d $HOME/.config/nvim ] || mkdir -p $HOME/.config/nvim
ln -sf $HOME/dotfiles/nvim/init.vim $HOME/.config/nvim

# Open Vim, run 'PlugInstall --sync' and quit
nvim +'PlugInstall --sync' +qa

# Py-n-vim
[ $(command -v pip) ] && pip install -q --user pynvim

echo "${GREEN}Finished installation and setup of Neovim${NC}"
echo

