#!/usr/bin/env bash
source $HOME/dotfiles/helper.sh

if [ ! -x "$(command -v code)" ]; then
  echo "${RED}Vscode is not installed${NC}"
  input "${ORANGE}Do you want to install it (with paru)?"

  [ $ANSWER ] && paru -S visual-studio-code-bin || exit 1
fi

declare -a extensions=(
  # "James-Yu.latex-workshop"
  # "rangav.vscode-thunder-client"
  # "ms-toolsai.jupyter"
  "bung87.vscode-gemfile"
  "dbaeumer.vscode-eslint"
  "eamodio.gitlens"
  "GitHub.github-vscode-theme"
  "esbenp.prettier-vscode"
  "k--kato.intellij-idea-keybindings"
  "ms-python.python"
  "ms-python.vscode-pylance"
  "PKief.material-icon-theme"
  "redhat.vscode-commons"
  "redhat.vscode-yaml"
)

echo
input "${ORANGE}Do you want to install all vscode extensions?"
if [ $ANSWER ]; then
  for extension in "${extensions[@]}"; do
    code --install-extension "${extension}"    
  done;
fi

echo
input "${ORANGE}Do you want your Vscode settings to be replaced? Backups will be made"
CODE_PATH="$HOME/.config/Code"

if [ $ANSWER ]; then
  if [ -f "$CODE_PATH/User/keybindings.json" ]; then
    mv "$CODE_PATH/User/keybindings.json" "$CODE_PATH/User/keybindings.backup.json"
    echo -e "${ORANGE}Renamed current ${RED}$CODE_PATH/User/keybindings.json${NC} ${ORANGE}to ${GREEN}$CODE_PATH/User/keybindings.backup.json${NC}"
  fi

  if [ -f "$CODE_PATH/User/settings.json" ]; then
    mv "$CODE_PATH/User/settings.json" $CODE_PATH/User/settings.backup.json
    echo -e "${ORANGE}Renamed current ${RED}$CODE_PATH/User/settings.json${NC} ${ORANGE}to ${GREEN}$CODE_PATH/User/settings.backup.json${NC}"
  fi

  ln -sv "$HOME/dotfiles/vscode/keybindings.json" "$CODE_PATH/User/"
  ln -sv "$HOME/dotfiles/vscode/settings.json" "$CODE_PATH/User/"
fi

echo
echo "${GREEN}Finished setting up VScode Settings.${NC}"
echo
