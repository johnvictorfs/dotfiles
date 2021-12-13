#!/usr/bin/env bash
source $HOME/dotfiles/helper.sh

if [ ! -x "$(command -v code)" ]; then
  echo "${RED}Vscode is not installed${NC}"
  input "${ORANGE}Do you want to install it (with paru)?"

  [ $ANSWER ] && paru -S visual-studio-code-bin || exit 1
fi

declare -a extensions=(
  "abusaidm.html-snippets"
  "aliariff.slim-lint"
  "atlassian.atlascode"
  "bung87.rails"
  "bung87.vscode-gemfile"
  "ckolkman.vscode-postgres"
  "dbaeumer.vscode-eslint"
  "dracula-theme.theme-dracula"
  "eamodio.gitlens"
  "Equinusocio.vsc-community-material-theme"
  "Equinusocio.vsc-material-theme"
  "equinusocio.vsc-material-theme-icons"
  "esbenp.prettier-vscode"
  "Gruntfuggly.todo-tree"
  "James-Yu.latex-workshop"
  "jpoissonnier.vscode-styled-components"
  "k--kato.intellij-idea-keybindings"
  "misogi.ruby-rubocop"
  "ms-python.python"
  "ms-python.vscode-pylance"
  "ms-toolsai.jupyter"
  "octref.vetur"
  "PKief.material-icon-theme"
  "rangav.vscode-thunder-client"
  "rebornix.ruby"
  "redhat.vscode-commons"
  "redhat.vscode-yaml"
  "shamanu4.django-intellisense"
  "sianglim.slim"
  "teabyii.ayu"
  "uloco.theme-bluloco-dark"
  "wingrunr21.vscode-ruby"
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
