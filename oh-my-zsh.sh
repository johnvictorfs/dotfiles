#!/usr/bin/env bash
source $HOME/dotfiles/helper.sh

input "${ORANGE}Do you want to replace your current dotfiles with the new ones? (.aliases and .zshrc) Backups will be made"

if [ $ANSWER ]; then
  cd $HOME/dotfiles
  ZSH_FILE=$HOME/.zshrc
  ZSH_BACKUP=$HOME/.zshrc.backup

  if [ ! -x "$(command -v zsh)" ]; then
    # Install Zsh if not already installed
    ./zsh.sh
    echo "${RED}Re-run this script after you've done so${NC}"
    exit 0
  fi

  echo
  echo -e "${ORANGE}Backing up current dotfiles...${NC}"

  if [ -f $ZSH_FILE ]; then
    mv $ZSH_FILE $ZSH_BACKUP # Backing up current .zshrc file
    echo -e "${ORANGE}Renamed current ${RED}~/.zshrc${NC} ${ORANGE}to ${GREEN}~/.zshrc.backup${NC}"
  fi

  if [ -f $HOME/.aliases ]; then
    mv $HOME/.aliases $HOME/.aliases.backup # Backing up current .aliases files
    echo -e "${ORANGE}Renamed current ${RED}~/.aliases${NC} ${ORANGE}to ${GREEN}~/.aliases.backup${NC}"
  fi

  echo -e "${ORANGE}Symlinking dotfiles...${NC}"
  ln -sf $HOME/dotfiles/.zshrc $HOME
  ln -sf $HOME/dotfiles/.aliases $HOME

  source $ZSH_FILE

  echo
  echo "${GREEN}Finished symlinking dotfiles.${NC}"
  echo
fi

input "${ORANGE}Do you wish to install Zgen and Zinit? (Zsh package managers)"
if [ $ANSWER ]; then
  # Zgenom plugin manager for ZSH
  # https://github.com/jandamm/zgenom
  git clone https://github.com/jandamm/zgenom.git "${HOME}/.zgenom"

  # Zinit plugin manager for ZSH
  # https://github.com/zdharma/zinit
  mkdir -p "$HOME/.zinit"
  git clone https://github.com/zdharma/zinit.git "$HOME/.zinit/bin"
fi

input "${ORANGE}Do you wish to install the pure prompt? (with yarn)"
if [ $ANSWER ]; then
  yarn global add pure-prompt
  fpath+=$HOME/.zsh/pure
  autoload -U promptinit; promptinit
  prompt pure
fi
