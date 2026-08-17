if test -r /usr/share/cachyos-fish-config/cachyos-config.fish
    source /usr/share/cachyos-fish-config/cachyos-config.fish
end

set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER less
set -gx COLORTERM truecolor

set -gx VOLTA_HOME "$HOME/.volta"
set -gx GOPATH "$HOME/go"

# fish_add_path is idempotent, so nested shells do not accumulate duplicates.
# Never prepend to $PATH with `set -gx PATH ... $PATH` here: config.fish is
# sourced by every nested shell, and that form grows PATH once per level.
fish_add_path --path "$HOME/.local/bin"
fish_add_path --path "$HOME/.volta/bin"
fish_add_path --path "$HOME/.lmstudio/bin"
fish_add_path --path "$HOME/.local/go/bin"
fish_add_path --path "$GOPATH/bin"

alias c clear
alias e nvim
alias v nvim
alias g git
alias gs 'git status'
alias gd 'git diff'
alias ga 'git add'
alias gc 'git commit'
alias gp 'git push'
alias ll 'ls -lah'
alias la 'ls -A'

function fish_greeting
end

if status is-interactive; and type -q starship
    starship init fish | source
end
