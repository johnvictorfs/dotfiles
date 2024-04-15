export DISABLE_AUTO_UPDATE=true

export EDITOR="lvim"
export VISUAL=$EDITOR

# Ignore files/folders in .gitignore when searching with fzf 
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# Load Zgenom Plugin Manager for ZSH
if [[ -f "${HOME}/.zgenom/zgenom.zsh" ]]; then
  source "${HOME}/.zgenom/zgenom.zsh"

  zgenom load zsh-users/zsh-completions
  zgenom load zsh-users/zsh-autosuggestions
  zgenom load zsh-users/zsh-syntax-highlighting

  # Oh-my-zsh plugins
  plugins=(sudo git command-not-found)

  # Install and use oh-my-zsh
  zgenom oh-my-zsh

  # prompt theme
  source ~/dotfiles/zsh/jvfs.zsh-theme
fi

# personal aliases
[ -f $HOME/.aliases ] && source $HOME/.aliases

# personal env vars
[ -f $HOME/.env_vars ] && source $HOME/.env_vars

export PATH="$HOME/.local/bin:$PATH"

# Adds `~/.bin` to PATH
export PATH="$PATH:$(du "$HOME/.bin/" | cut -f2 | tr '\n' ':' | sed 's/:*$//')"

export DOTNET_ROOT=$HOME/dotnet
export PATH=$PATH:$HOME/dotnet

# Android Studio stuff
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export ANDROID_SDK="$HOME/Android/Sdk"

# rbenv
if [ -x "$(command -v rbenv)" ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

# flatpak
export PATH="/var/lib/flatpak/exports/bin:$PATH"

# cargo
export PATH="$HOME/.cargo/bin:$PATH"

# pyenv
if [[ -d "${HOME}/.pyenv/bin" ]]; then
  export PATH="$(pyenv root)/shims:$PATH"
  export PATH="${HOME}/.pyenv/bin:$PATH"
  export PYENV_ROOT="$HOME/.pyenv"
  command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# poetry
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
      source "${DEFAULT_ENV_PATH}/bin/activate"  # commented out by conda initialize
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

# n node version manager
export N_PREFIX="$HOME/.n"
export PATH="$N_PREFIX/bin:$PATH"

# pnpm
export PNPM_HOME="/home/john/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "/home/john/.bun/_bun" ] && source "/home/john/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# perl (???)
# PATH="/home/john/perl5/bin${PATH:+:${PATH}}"; export PATH;
# PERL5LIB="/home/john/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
# PERL_LOCAL_LIB_ROOT="/home/john/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
# PERL_MB_OPT="--install_base \"/home/john/perl5\""; export PERL_MB_OPT;
# PERL_MM_OPT="INSTALL_BASE=/home/john/perl5"; export PERL_MM_OPT;

# console-ninja vscode extension
PATH=~/.console-ninja/.bin:$PATH
