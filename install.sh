#!/bin/bash
set -e

sudo apt-get update
sudo apt-get install -y openssh-server stow
sudo service ssh start

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim

cd "$(dirname "$0")"
stow -t "$HOME" git kitty lazygit nvim scripts tmux wezterm zsh
