export EDITOR=/usr/bin/nano

# Adds `~/.bin` to $PATH
export PATH="$PATH:$(du "$HOME/.bin/" | cut -f2 | tr '\n' ':' | sed 's/:*$//')"
