#!/bin/sh
set -eu

DOTFILES_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
COMMON_HOME=$(CDPATH= cd -- "$DOTFILES_DIR/../common/home" && pwd)
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
DRY_RUN=false

if [ "${1:-}" = "--dry-run" ]; then
  DRY_RUN=true
elif [ "$#" -ne 0 ]; then
  echo "Usage: $0 [--dry-run]" >&2
  exit 2
fi

for SOURCE_DIR in "$DOTFILES_DIR/home" "$COMMON_HOME"; do
  find "$SOURCE_DIR" -type f | while IFS= read -r source; do
  relative=${source#"$SOURCE_DIR"/}
  target="$HOME/$relative"

  if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
    printf 'ok      %s\n' "$target"
    continue
  fi

  if [ -e "$target" ] || [ -L "$target" ]; then
    printf 'backup  %s -> %s/%s\n' "$target" "$BACKUP_DIR" "$relative"
    if [ "$DRY_RUN" = false ]; then
      mkdir -p "$BACKUP_DIR/$(dirname "$relative")"
      mv "$target" "$BACKUP_DIR/$relative"
    fi
  fi

  printf 'link    %s -> %s\n' "$target" "$source"
  if [ "$DRY_RUN" = false ]; then
    mkdir -p "$(dirname "$target")"
    ln -s "$source" "$target"
  fi
  done
done

if [ "$DRY_RUN" = false ]; then
  echo "Dotfiles installed."
  if [ -d "$BACKUP_DIR" ]; then
    echo "Previous files: $BACKUP_DIR"
  fi
fi
