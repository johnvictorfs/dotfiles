# Load Zgen Plugin Manager for ZSH
if [[ -f "${HOME}/.zgen/zgen.zsh" ]]; then
  source "${HOME}/.zgen/zgen.zsh"
fi

# Load Zinit Plugin Manager for ZSH
if [[ -f "${HOME}/.zinit/bin/zinit.zsh" ]]; then
  source "${HOME}/.zinit/bin/zinit.zsh"
fi

# Install and use oh-my-zsh
zgen oh-my-zsh

# Path to oh-my-zsh installation.
export ZSH="/home/${USER}/.oh-my-zsh"

alias src="source $HOME/.zshrc"

export VISUAL="nvim"
export EDITOR="vim"

[ -f $HOME/.bash_prompt ] && source $HOME/.bash_prompt

[ -f $HOME/.aliases ] && source $HOME/.aliases

[ -f $HOME/.env_vars ] && source $HOME/.env_vars

export PATH="$HOME/.local/bin:$PATH"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

export DOTNET_ROOT=$HOME/dotnet
export PATH=$PATH:$HOME/dotnet

# Android Studio stuff
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools


export GEM_HOME=$HOME/.ruby
export PATH=$PATH:$HOME/.ruby/bin

[ "$(command -v ruby)" ] && export PATH="$PATH:$(ruby -e 'puts Gem.user_dir')/bin"

export PATH="$HOME/.rbenv/bin:$PATH"

if [ -x "$(command -v rbenv)" ]; then
    eval "$(rbenv init -)"
fi

export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
export PATH="/var/lib/flatpak/exports/bin:$PATH"

# Adds `~/.bin` to $PATH
export PATH="$PATH:$(du "$HOME/.bin/" | cut -f2 | tr '\n' ':' | sed 's/:*$//')"

# added by travis gem
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh

 # This loads RVM into a shell session.
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" 

# Zplugin installer
if [[ -f "${HOME}/.zplugin/bin/zplugin.zsh" ]]; then
  source "/home/${USER}/.zplugin/bin/zplugin.zsh"
  autoload -Uz _zplugin
  (( ${+_comps} )) && _comps[zplugin]=_zplugin

  ZPLGM[MUTE_WARNINGS]=1
fi

# End of Zinit's installer chunk
if [[ "$(command -v zinit)" ]]; then
  zinit light zdharma/fast-syntax-highlighting
  zinit light zsh-users/zsh-autosuggestions
  zinit light zsh-users/zsh-completions
fi

# Load pyenv
if [[ -d "${HOME}/.pyenv/bin" ]]; then
  export PATH="${HOME}/.pyenv/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# Load poetry
if [[ -f "${HOME}/.poetry/env" ]]; then
  source $HOME/.poetry/env
fi

# Activate python virtual envs in .venv when cd'ing
function cd() {
  builtin cd "$@"

  # Default path to virtualenv in your projects
  DEFAULT_ENV_PATH="./.venv"

  # If env folder is found then activate the vitualenv
  function activate_venv() {
    if [[ -f "${DEFAULT_ENV_PATH}/bin/activate" ]]; then 
      source "${DEFAULT_ENV_PATH}/bin/activate"
      echo "Activating ${VIRTUAL_ENV}"
    fi
  }

  if [[ -z "$VIRTUAL_ENV" ]]; then
    activate_venv
  else
    # check the current folder belong to earlier VIRTUAL_ENV folder
    # if yes then do nothing
    # else deactivate then run a new env folder check
      parentdir="$(dirname ${VIRTUAL_ENV})"
      if [[ "$PWD"/ != "$parentdir"/* ]]; then
        echo "Deactivating ${VIRTUAL_ENV}"
        deactivate
        activate_venv
      fi
  fi
}

function killport() {
  # Check if something is running at the port passed before trying to kill it
  if lsof -Pi ":$1" -sTCP:LISTEN -t >/dev/null; then
    echo "Killing process at port '$1'"
    sudo kill $(lsof -t -i:"$1")
    echo "Killed process at port '$1' successfully"
  else
    echo "There is nothing listening at port '$1'"
  fi
}

export ANDROID_SDK="/home/john/Android/Sdk"

# Oh-my-zsh plugins
zgen oh-my-zsh plugins/sudo
zgen oh-my-zsh plugins/git
zgen oh-my-zsh plugins/command-not-found

# Install and load Pure zsh theme
# https://github.com/sindresorhus/pure
zgen load mafredri/zsh-async
zgen load sindresorhus/pure

PURE_PROMPT_SYMBOL=""

