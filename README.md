# My Dotfiles

Configuration files for zshrc (`.zshrc` and `.aliases`), Neovim (`init.vim`), Vscode, i3-gaps and others

> Note: All packages will attempt to be installed with `pacman` (Arch Repository Package Manager) or `yay` (AUR Package Manager), some Python (pip) packages will be installed as well in the i3-setup

## Usage

```bash
git clone https://github.com/johnvictorfs/dotfiles.git $HOME/dotfiles
cd $HOME/dotfiles

# Standard setup
./install.sh

# Zsh setup
./install-zsh.sh # Requires pacman, install manually if you don't have it
./install-oh-my-zsh.sh # Distro-agnostic

# Neovim setup (installation done with pacman, config and plugins are distro-agnostic)
./nvim_setup.sh

# i3-gaps setup (installation done with pacman and yay, config is distro-agnostic)
./i3_setup.sh
```

### i3-gaps and Kitty (Terminal emulator) setup

![image](https://user-images.githubusercontent.com/37747572/75616616-f464e700-5b31-11ea-90ea-5a0bc8199b72.png)

### Neovim setup

![image](https://user-images.githubusercontent.com/37747572/75616637-473e9e80-5b32-11ea-989b-75176f07ffeb.png)

