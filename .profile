export EDITOR=/usr/bin/nvim

# Adds `~/.bin` to $PATH
export PATH="$PATH:$(du "$HOME/.bin/" | cut -f2 | tr '\n' ':' | sed 's/:*$//')"

# Japanese input
# https://confluence.jaytaala.com/display/TKB/Japanese+input+with+i3+and+Arch+based+distros
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=fcitx
export GTK_THEME="Adwaita:dark"
