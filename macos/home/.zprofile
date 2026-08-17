# Homebrew (Apple Silicon)
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Antigravity
path=("$HOME/.antigravity/antigravity/bin" $path)
export PATH

[[ -r "$HOME/.zprofile.local" ]] && source "$HOME/.zprofile.local"
