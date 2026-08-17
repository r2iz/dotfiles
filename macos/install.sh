#!/bin/sh
set -eu

DOTFILES_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
BREWFILE="$DOTFILES_DIR/Brewfile"
ASTRONVIM_REPO=${ASTRONVIM_REPO:-https://github.com/r2iz/astronvim_v5.git}
ASTRONVIM_DIR=${ASTRONVIM_DIR:-"$HOME/.config/nvim"}
DRY_RUN=false

if [ "${1:-}" = "--dry-run" ]; then
  DRY_RUN=true
elif [ "$#" -ne 0 ]; then
  echo "Usage: $0 [--dry-run]" >&2
  exit 2
fi

if [ "$(uname -s)" != "Darwin" ]; then
  echo "This bootstrap script supports macOS only." >&2
  exit 1
fi

if ! xcode-select -p >/dev/null 2>&1; then
  echo "Xcode Command Line Tools are required." >&2
  echo "Install them with: xcode-select --install" >&2
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is required: https://brew.sh/" >&2
  exit 1
fi

if [ "$DRY_RUN" = true ]; then
  if brew bundle check --file="$BREWFILE" >/dev/null 2>&1; then
    echo "ok      Homebrew dependencies"
  else
    echo "install Homebrew dependencies from $BREWFILE"
  fi
  echo "install Volta toolchain: node@24 and pnpm@10"
  "$DOTFILES_DIR/link.sh" --dry-run

  if git -C "$ASTRONVIM_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "update  $ASTRONVIM_DIR (fast-forward only)"
  elif [ -e "$ASTRONVIM_DIR" ] || [ -L "$ASTRONVIM_DIR" ]; then
    echo "backup  $ASTRONVIM_DIR"
    echo "clone   $ASTRONVIM_REPO -> $ASTRONVIM_DIR"
  else
    echo "clone   $ASTRONVIM_REPO -> $ASTRONVIM_DIR"
  fi
  exit 0
fi

brew bundle --file="$BREWFILE"
volta install node@24 pnpm@10
"$DOTFILES_DIR/link.sh"

if git -C "$ASTRONVIM_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git -C "$ASTRONVIM_DIR" pull --ff-only
else
  if [ -e "$ASTRONVIM_DIR" ] || [ -L "$ASTRONVIM_DIR" ]; then
    backup_dir="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$backup_dir/.config"
    mv "$ASTRONVIM_DIR" "$backup_dir/.config/nvim"
    echo "Previous Neovim configuration: $backup_dir/.config/nvim"
  fi
  mkdir -p "$(dirname "$ASTRONVIM_DIR")"
  git clone "$ASTRONVIM_REPO" "$ASTRONVIM_DIR"
fi

echo "Development environment installed."
