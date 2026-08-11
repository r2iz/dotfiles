#!/usr/bin/env bash
set -euo pipefail

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
backup="$HOME/.config-backup/$(date +%Y%m%d-%H%M%S)"
packages=(hyprland hyprpaper waybar wofi wlogout swaylock swayidle grim slurp swappy brightnessctl wl-clipboard mako xdg-desktop-portal-hyprland xdg-desktop-portal-gtk polkit-gnome qt5-wayland qt6-wayland adwaita-icon-theme alacritty fish starship ttf-jetbrains-mono-nerd noto-fonts-emoji fcitx5 fcitx5-gtk fcitx5-qt fcitx5-mozc-ut fcitx5-configtool neovim git curl)

if command -v paru >/dev/null 2>&1; then
  paru -S --needed "${packages[@]}"
elif command -v pacman >/dev/null 2>&1; then
  sudo pacman -S --needed "${packages[@]}"
else
  printf '%s\n' 'Arch package manager (paru/pacman) is required.' >&2
  exit 1
fi

if ! command -v herdr >/dev/null 2>&1; then
  curl -fsSL https://herdr.dev/install.sh | sh
fi

link_config() {
  local src="$root/$1" dest="$HOME/$1"
  if [[ -e "$dest" || -L "$dest" ]]; then
    if [[ "$(readlink -f "$dest" 2>/dev/null || true)" == "$src" ]]; then
      return
    fi
    mkdir -p "$backup"
    mv -- "$dest" "$backup/"
  fi
  mkdir -p "$(dirname -- "$dest")"
  ln -s -- "$src" "$dest"
}

link_config .config/hypr/hyprland.lua
link_config .config/hypr/hyprpaper.conf
link_config .config/fcitx5/profile
link_config .config/waybar/config
link_config .config/waybar/style.css
link_config .config/alacritty/alacritty.toml
link_config .config/herdr/config.toml
link_config .config/fish/config.fish
link_config .config/starship.toml
link_config .config/gtk-3.0/settings.ini
link_config .config/gtk-4.0/settings.ini
link_config .config/wofi/config
link_config .config/wofi/style.css
link_config .config/mako/config
link_config .config/swaylock/config
link_config .config/swayidle/config
link_config .config/wlogout/layout
link_config .config/wlogout/style.css

wallpaper_source="$root/wallpapers"
wallpaper_dest="$HOME/Pictures/wallpapers"
if [[ -e "$wallpaper_dest" || -L "$wallpaper_dest" ]]; then
  if [[ "$(readlink -f "$wallpaper_dest" 2>/dev/null || true)" != "$wallpaper_source" ]]; then
    mkdir -p "$backup"
    mv -- "$wallpaper_dest" "$backup/"
  fi
fi
if [[ ! -e "$wallpaper_dest" && ! -L "$wallpaper_dest" ]]; then
  mkdir -p "$(dirname -- "$wallpaper_dest")"
  ln -s -- "$wallpaper_source" "$wallpaper_dest"
fi

nvim_dir="$HOME/.config/nvim"
if [[ ! -e "$nvim_dir" ]]; then
  git clone https://github.com/r2iz/astronvim_v5 "$nvim_dir"
elif git -C "$nvim_dir" remote get-url origin 2>/dev/null | grep -q 'github.com/r2iz/astronvim_v5'; then
  printf '%s\n' "Neovim config already present: $nvim_dir"
else
  printf '%s\n' "Neovim config exists; left untouched: $nvim_dir"
fi

printf '%s\n' 'Done. Start Hyprland and run nvim once to install AstroNvim plugins.'
[[ -d "$backup" ]] && printf 'Previous configs: %s\n' "$backup"
