setopt nolistbeep
setopt no_beep

alias vim=nvim
alias ll="ls -l"
alias la="ls -a"

export GPG_TTY=$(tty)
eval "$(starship init zsh)"
