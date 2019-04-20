#!/usr/bin/env bash

ORANGE=$'\e[33m'
RED=$'\e[31m'
GREEN=$'\e[32m'
NC=$'\e[0m'

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

declare -a snap_packages=(
    "discord"
    "pycharm-professional"
    "webstorm"
    "code --classic"
    "sublime-text"
    "heroku"
)

for package in "${snap_packages[@]}"; do
    read -p "${ORANGE}Do you want to install ${package}? (Y/n)${NC} " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] ; then
        snap install "${package}"
    fi
done;

echo
echo "${GREEN}Finished installing snap packages.${NC}"
