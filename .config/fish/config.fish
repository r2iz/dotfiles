if test -r /usr/share/cachyos-fish-config/cachyos-config.fish
    source /usr/share/cachyos-fish-config/cachyos-config.fish
end

set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER less
set -gx COLORTERM truecolor

fish_add_path --path "$HOME/.local/bin"
fish_add_path --path "$HOME/.volta/bin"
fish_add_path --path "$HOME/.lmstudio/bin"

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

