#!/usr/bin/env bash

# Zgen plugin manager for ZSH
# https://github.com/tarjoilija/zgen
git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"

# Zinit plugin manager for ZSH
# https://github.com/tarjoilija/zgen
mkdir "${HOME}/.zinit"
git clone https://github.com/zdharma/zinit.git "${HOME}/.zinit/bin"

