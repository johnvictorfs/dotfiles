#!/usr/bin/env bash
source $HOME/dotfiles/helper.sh


if [ ! -x "$(command -v flatpak)" ] ; then
  echo "${RED}Flatpak is not installed${NC}"
  read -p "${ORANGE}Do you want to install it? (Y/n)${NC} " -n 1 -r
  echo

  if [[ $REPLY =~ ^[Yy]$ ]] ; then
    sudo apt update -y
    sudo apt install flatpak -y
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  else
    exit 1
  fi
fi

if [ ! "$(flatpak list | grep 'com.visualstudio.code')" ] ; then
  echo "${RED}Vscode is not installed${NC}"
  read -p "${ORANGE}Do you want to install it? (Y/n)${NC} " -n 1 -r
  echo

  if [[ $REPLY =~ ^[Yy]$ ]] ; then
    flatpak install flathub com.visualstudio.code
  else
    exit 1
  fi
fi

declare -a extensions=(
  "abusaidm.html-snippets"
  "dbaeumer.vscode-eslint"
  "DiemasMichiels.emulate"
  "dracula-theme.theme-dracula"
  "dsznajder.es7-react-js-snippets"
  "Equinusocio.vsc-community-material-theme"
  "Equinusocio.vsc-material-theme"
  "equinusocio.vsc-material-theme-icons"
  "esbenp.prettier-vscode"
  "formulahendry.code-runner"
  "johnpapa.Angular2"
  "jpoissonnier.vscode-styled-components"
  "k--kato.intellij-idea-keybindings"
  "ms-azuretools.vscode-docker"
  "ms-python.python"
  "ms-vscode.cpptools"
  "ms-vsliveshare.vsliveshare"
  "necinc.elmmet"
  "octref.vetur"
  "OfHumanBondage.react-proptypes-intellisense"
  "PKief.material-icon-theme"
  "Prisma.vscode-graphql"
  "suming.react-proptypes-generate"
  "uloco.theme-bluloco-dark"
  "visioncan.vscode-jss-snippets"
  "vuetifyjs.vuetify-vscode"
  "fallenwood.viml"
)

echo
read -p "${ORANGE}Do you want to install all vscode extensions? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
  for extension in "${extensions[@]}"; do
    com.visualstudio.code --install-extension "${extension}"    
  done;
fi

echo
read -p "${ORANGE}Do you want your Vscode settings to be replaced? Backups will be made (Y/n) " -n 1 -r
echo
echo

CODE_PATH="$HOME/.var/app/com.visualstudio.code/config/Code"

if [[ $REPLY =~ ^[Yy]$ ]] ; then
  if [ -f $CODE_PATH/User/keybindings.json ] ; then
    mv $CODE_PATH/User/keybindings.json $CODE_PATH/User/keybindings.backup.json
    echo -e "${ORANGE}Renamed current ${RED}$CODE_PATH/User/keybindings.json${NC} ${ORANGE}to ${GREEN}$CODE_PATH/User/keybindings.backup.json${NC}"
  fi
  if [ -f $CODE_PATH/User/settings.json ] ; then
    mv $CODE_PATH/User/settings.json $CODE_PATH/User/settings.backup.json
    echo -e "${ORANGE}Renamed current ${RED}$CODE_PATH/User/settings.json${NC} ${ORANGE}to ${GREEN}$CODE_PATH/User/settings.backup.json${NC}"
  fi
  ln -sv $HOME/dotfiles/vscode/keybindings.json $CODE_PATH/User/
  ln -sv $HOME/dotfiles/vscode/settings.json $CODE_PATH/User/
fi

echo
echo "${GREEN}Finished setting up VScode Settings.${NC}"
echo
