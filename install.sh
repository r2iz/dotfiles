#!/usr/bin/env bash

echo -ne "\033[32m"
echo "========================================="
echo " Dotfiles - nere531                      "
echo " https://github.com/r2iz/dotfiles        "
echo "========================================="
echo -ne "\033[39m"

echo -n "Do you want to continue? [y/N] "
read -n1 input
echo
if [[ ${input} != "y" ]]; then
  echo "aborting."
  exit 1
fi

current=$(cd $(dirname ${0}); pwd)

if [[ ! -e ~/.gdb-dashboard ]]; then
  echo -e "\033[36m[info] Downloading '.gdb-dashboard'...\033[39m"
  curl https://raw.githubusercontent.com/cyrus-and/gdb-dashboard/master/.gdbinit -o ~/.gdb-dashboard
fi

echo -e "\033[36m[info] Creating symlink...\033[39m"
mkdir -p ~/.config
ln -snvf  ${current}/.zshrc     ~/.zshrc
ln -snvf  ${current}/.gdbinit   ~/.gdbinit

ln -snvfd ${current}/.config/hypr       ~/.config/
ln -snvfd ${current}/.config/mako       ~/.config/
ln -snvfd ${current}/.config/nvim       ~/.config/
ln -snvfd ${current}/.config/swaylock   ~/.config/
ln -snvfd ${current}/.config/wofi       ~/.config/
ln -snvfd ${current}/.config/waybar     ~/.config/
ln -snvf ${current}/.config/microsoft-edge-stable-flags.conf ~/.config/microsoft-edge-stable-flags.conf

echo -e "\033[32m[info] All done!\033[32m"
