bindkey -v
set -o vi

export EDITOR=nvim
export CONFIG=~/.config

eval $(thefuck --alias)

eval "$(zoxide init zsh)"

source <(fzf --zsh)
