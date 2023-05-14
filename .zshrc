export PATH="$(pyenv root)/shims:$PATH"

# Load Zgenom Plugin Manager for ZSH
if [[ -f "${HOME}/.zgenom/zgenom.zsh" ]]; then
  source "${HOME}/.zgenom/zgenom.zsh"
fi

# Load Zinit Plugin Manager for ZSH
if [[ -f "${HOME}/.zinit/bin/zinit.zsh" ]]; then
  source "${HOME}/.zinit/bin/zinit.zsh"
fi

# Install and use oh-my-zsh
zgenom oh-my-zsh

# Path to oh-my-zsh installation.
export ZSH="/home/${USER}/.oh-my-zsh"

alias src="source $HOME/.zshrc"

export VISUAL="lvim"
export EDITOR="lvim"

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

export PATH="$HOME/.rbenv/bin:$PATH"

if [ -x "$(command -v rbenv)" ]; then
    eval "$(rbenv init -)"
fi

export PATH="/var/lib/flatpak/exports/bin:$PATH"

# Adds `~/.bin` to $PATH
export PATH="$PATH:$(du "$HOME/.bin/" | cut -f2 | tr '\n' ':' | sed 's/:*$//')"

export PATH="$HOME/.cargo/bin:$PATH"

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
# source "${DEFAULT_ENV_PATH}/bin/activate"  # commented out by conda initialize
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
    sudo kill -9 $(lsof -t -i:"$1")
    echo "Killed process at port '$1' successfully"
  else
    echo "There is nothing listening at port '$1'"
  fi
}

export ANDROID_SDK="$HOME/Android/Sdk"

# Ignore files/folders in .gitignore when searching with fzf 
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# Oh-my-zsh plugins
zgenom oh-my-zsh plugins/sudo
zgenom oh-my-zsh plugins/git
zgenom oh-my-zsh plugins/command-not-found

ZSH_THEME=""

# Install and load Pure zsh theme
# https://github.com/sindresorhus/pure
zgenom load mafredri/zsh-async

fpath+=$HOME/.zsh/pure
autoload -U promptinit; promptinit
prompt pure

PURE_PROMPT_SYMBOL=""
setopt auto_cd

export N_PREFIX="$HOME/.n"
export PATH="$N_PREFIX/bin:$PATH"


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# pnpm
export PNPM_HOME="/home/john/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

alias pnpx='pnpm dlx'
