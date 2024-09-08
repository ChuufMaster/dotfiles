bindkey -v
set -o vi

export EDITOR=nvim
export CONFIG=~/.config
export XDG_RUNTIME_DIR="/run/user/$(id -u)"

eval $(thefuck --alias)

eval "$(zoxide init zsh)"

source <(fzf --zsh)
