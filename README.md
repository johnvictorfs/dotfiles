# My Dotfiles

Configuration files for zshrc (`.zshrc` and `.aliases`), Neovim (`init.vim`), Vscode, i3-gaps and others

Some configs and scripts are based on [simrat39/dotfiles](https://github.com/simrat39/dotfiles), [LukeSmithxyz/voidrice](https://github.com/LukeSmithxyz/voidrice) and [adi1090x/rofi](https://github.com/adi1090x/rofi).

---

## Installation

- **Before Installing:** Most packages will attempt to be installed with `pacman` (Arch Repository Package Manager) or `yay` (AUR Package Manager), some Python (pip) packages will be installed as well in the i3-setup. Even then most configuration is distro-agnostic, and you can read below what you can and cannot run depending if you're running an Arch-based distro or not. You can just answer 'N' to every installation prompt when running the below scripts if you're not using an Arch-based distro, and install the needed packages manually with your preferred package manager if necessary.

- **Clone repository dotfiles to `~/dotfiles`:**
  ```bash
  git clone https://github.com/johnvictorfs/dotfiles.git $HOME/dotfiles
  cd $HOME/dotfiles
  ```

- **Zsh Setup:**
  ```bash
  # (installation with pacman, config is distro-agnostic)
  ./install-zsh.sh

  # Distro-agnostic, symlink .zshrc and .aliases files
  ./install-oh-my-zsh.sh
  ```

- **Neovim Setup:**
  > Installation with pacman, config is distro-agnostic

  ```bash
  ./nvim_setup.sh
  ```

- **i3-gaps Setup:**
  > Installation with yay, config is distro-agnostic

  ```bash
  ./i3_setup.sh
  ```

- **VsCode Setup:**
  > Installation with pacman, config is distro-agnostic

  ```bash
  ./vscode.sh
  ```

---

## i3-gaps (rounded) and Kitty Setup

![image](https://user-images.githubusercontent.com/37747572/77350016-aa2eea00-6d1a-11ea-998d-2601ce02ed8a.png)

![image](https://user-images.githubusercontent.com/37747572/77351467-95535600-6d1c-11ea-99ad-4b4bc4561922.png)

![image](https://user-images.githubusercontent.com/37747572/77351585-bb78f600-6d1c-11ea-9b7e-edbe30eadf9e.png)

## Neovim setup ([ayu-theme](https://github.com/ayu-theme/ayu-vim))

![image](https://user-images.githubusercontent.com/37747572/77350088-c468c800-6d1a-11ea-833d-44dac60a4d49.png)

---

## i3 Keybinds

- **Default <kbd>$mod</kbd> key:** <kbd>Super</kbd>

| Key | Action |
|-----|--------|
| <kbd>$mod</kbd> + <kbd><1-8></kbd> | Switch Workspace |
| <kbd>$mod</kbd> + <kbd>Shift</kbd> + <kbd><1-8></kbd> | Move active Window to Workspace and switch to it |
| <kbd>$mod</kbd> + <kbd>Shift</kbd> + <kbd>Space</kbd> | Toggle floating on active Window |
| <kbd>$mod</kbd> + <kbd>Ctrl</kbd> + <kbd>m</kbd> | Open audio settings |
| <kbd>$mod</kbd> + <kbd>f</kbd> | Toggle Active Window Full-screen |
| <kbd>$mod</kbd> + <kbd>Return</kbd> | Open Terminal Window |
| <kbd>$mod</kbd> + <kbd>&larr;</kbd> / <kbd>&uarr;</kbd> / <kbd>&rarr;</kbd> / <kbd>&darr;</kbd> | Switch Active Window |
| <kbd>$mod</kbd> + <kbd>r</kbd> | Toggle resize Mode, resize with <kbd>&larr;</kbd> / <kbd>&uarr;</kbd> / <kbd>&rarr;</kbd> / <kbd>&darr;</kbd> then press <kbd>Return</kbd> to confirm |
| <kbd>$mod</kbd> + <kbd>Ctrl</kbd> + <kbd>&larr;</kbd> / <kbd>&uarr;</kbd> / <kbd>&rarr;</kbd> | Resize active window without resize mode |
| <kbd>$mod</kbd> + <kbd>Shift</kbd> + <kbd>&larr;</kbd> / <kbd>&uarr;</kbd> / <kbd>&rarr;</kbd> / <kbd>&darr;</kbd> | Move Active Window |
| <kbd>$mod</kbd> + <kbd>d</kbd> | Open Application Launcher |
| <kbd>$mod</kbd> + <kbd>q</kbd> | Close active Window |
| <kbd>PrtScr</kbd> | Region selection Screenshot (Saved to `~/Pictures/Screenshots` and copied to clipboard) |
| <kbd>$mod</kbd> + <kbd>PrtScr</kbd> | Monitor Screenshot (Saved to `~/Pictures/Screenshots` and copied to clipboard) |
| <kbd>Volume Up/Down</kbd> | Increase/Decrease Volume with Fn keys |
| <kbd>Volume Mute</kbd> | Mute/Unmute Volume with Fn keys |
| <kbd>$mod</kbd> + <kbd>Shift</kbd> + <kbd>c</kbd> | Reload i3 config files |
| <kbd>$mod</kbd> + <kbd>Shift</kbd> + <kbd>r</kbd> | Restart i3 (maintains session) |
| <kbd>$mod</kbd> + <kbd>0</kbd> | System Mode to lock/suspend/restart/shutdown etc. |
| <kbd>$mod</kbd> + Click + Drag Window | Move floating window with the mouse |

---

## Packages used

- Terminal Emulator: [Kitty](https://github.com/kovidgoyal/kitty)
- Window Manager: [i3 (gaps + rounded fork)](https://github.com/resloved/i3)
- Application Launcher: [rofi](https://github.com/davatorium/rofi)
- Status Bar: [polybar](https://github.com/polybar/polybar)
- Wallpaper config: [feh](https://github.com/derf/feh)
- Compositor: [compton](https://github.com/tryone144/compton)
- Shell: [zsh](https://www.zsh.org/)
- Shell manager: [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
