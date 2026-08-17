# User executables
path=(
  "$HOME/.local/bin"
  "$HOME/.volta/bin"
  "$HOME/Library/pnpm"
  /opt/homebrew/opt/llvm/bin
  $path
)
export PATH
export PNPM_HOME="$HOME/Library/pnpm"

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# Shell behavior
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt INTERACTIVE_COMMENTS
setopt NO_BEEP

# Completion
autoload -Uz compinit
compinit -d "$HOME/.zcompdump"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' use-cache true
zstyle ':completion:*' cache-path "$HOME/.cache/zsh"

# Use familiar Emacs-style editing and searchable history with arrow keys.
bindkey -e
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey '^[[A' history-beginning-search-backward-end
bindkey '^[[B' history-beginning-search-forward-end

# Prompt: current directory and Git branch, using only zsh built-ins.
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats ' %F{magenta}(%b)%f'
zstyle ':vcs_info:*' enable git
precmd_functions+=(vcs_info)
setopt PROMPT_SUBST
PROMPT='%F{cyan}%~%f${vcs_info_msg_0_}
%F{green}❯%f '

# Common shortcuts
alias ls='ls -G'
alias ll='ls -lah'
alias la='ls -A'
alias ..='cd ..'
alias ...='cd ../..'
alias g='git'
alias gs='git status --short --branch'

mkcd() {
  mkdir -p -- "$1" && cd -- "$1"
}

# Allow GPG to prompt in the current terminal.
if [[ -t 0 ]]; then
  export GPG_TTY="$(tty)"
fi

# Rust
[[ -r "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# OrbStack command-line tools and integration
source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null || :

# Keep machine-only and secret settings outside the repository.
[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
