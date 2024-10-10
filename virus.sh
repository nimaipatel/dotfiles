#!/bin/bash

set -xe

# unix
ln -sf    "$(pwd)/.gitconfig"   ~/.gitconfig
ln -sf    "$(pwd)/.vimrc"       ~/.vimrc
ln -sf    "$(pwd)/.tmux.conf"   ~/.tmux.conf

# macOS
ln -sf    "$(pwd)/.zshrc"       ~/.zshrc
ln -sf    "$(pwd)/.wezterm.lua" ~/.wezterm.lua
