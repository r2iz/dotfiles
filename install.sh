#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

case $(uname -s) in
  Darwin) exec "$root/macos/install.sh" "$@" ;;
  Linux) exec "$root/linux/install.sh" "$@" ;;
  *) echo "Unsupported operating system: $(uname -s)" >&2; exit 1 ;;
esac
