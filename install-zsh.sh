#!/usr/bin/env bash

ORANGE=$'\e[33m'
GREEN=$'\e[32m'
RED=$'\e[31m'
NC=$'\e[0m'

sudo apt install zsh -y
chsh -s $(which zsh)

echo
echo "${GREEN}Zsh installed successfully.${NC}"
echo
echo "${RED}Log out and log back in for changes to take place${NC}"
echo