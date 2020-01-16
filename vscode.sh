#!/usr/bin/env bash
source $HOME/dotfiles/helper.sh

if [ ! -x "$(command -v code)" ] ; then
  echo "${RED}Vscode is not installed${NC}"
  read -p "${ORANGE}Do you want to install it? (Y/n)${NC} " -n 1 -r
  echo

  if [ ! -x "$(command -v snap)" ] ; then
    echo "${RED}Snap is not installed${NC}"
    read -p "${ORANGE}Do you want to install it? (Y/n)${NC} " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]] ; then
      sudo apt update -y
      sudo apt install snapd -y
    else
      exit 1
    fi
  fi

  if [[ $REPLY =~ ^[Yy]$ ]] ; then
    snap install code --classic
  else
    exit 1
  fi
fi

declare -a extensions=(
  "abusaidm.html-snippets"
  "dbaeumer.vscode-eslint"
  "dracula-theme.theme-dracula"
  "dsznajder.es7-react-js-snippets"
  "Equinusocio.vsc-material-theme"
  "esbenp.prettier-vscode"
  "johnpapa.Angular2"
  "jpoissonnier.vscode-styled-components"
  "k--kato.intellij-idea-keybindings"
  "ms-python.python"
  "necinc.elmmet"
  "octref.vetur"
  "OfHumanBondage.react-proptypes-intellisense"
  "PKief.material-icon-theme"
  "pushqrdx.inline-html"
  "suming.react-proptypes-generate"
  "visioncan.vscode-jss-snippets"
  "vuetifyjs.vuetify-vscode"
)

echo
read -p "${ORANGE}Do you want to install all vscode extensions? (Y/n)${NC} " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
  for extension in "${extensions[@]}"; do
    code --install-extension "${extension}"    
  done;
fi

echo
read -p "${ORANGE}Do you want your Vscode settings to be replaced? Backups will be made (Y/n) " -n 1 -r
echo
echo
if [[ $REPLY =~ ^[Yy]$ ]] ; then
  if [ -f $HOME/.config/Code/User/keybindings.json ] ; then
    mv $HOME/.config/Code/User/keybindings.json $HOME/.config/Code/User/keybindings.backup.json
    echo -e "${ORANGE}Renamed current ${RED}~/.config/Code/User/keybindings.json${NC} ${ORANGE}to ${GREEN}~/.config/Code/User/keybindings.backup.json${NC}"
  fi
  if [ -f $HOME/.config/Code/User/settings.json ] ; then
    mv $HOME/.config/Code/User/settings.json $HOME/.config/Code/User/settings.backup.json
    echo -e "${ORANGE}Renamed current ${RED}~/.config/Code/User/settings.json${NC} ${ORANGE}to ${GREEN}~/.config/Code/User/settings.backup.json${NC}"
  fi
  ln -sv $HOME/dotfiles/vscode/keybindings.json $HOME/.config/Code/User/
  ln -sv $HOME/dotfiles/vscode/settings.json $HOME/.config/Code/User/
fi

echo
echo "${GREEN}Finished setting up VScode Settings.${NC}"
echo
