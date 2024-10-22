bindkey -v
set -o vi

export EDITOR=nvim
export CONFIG=~/.config
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export XDG_CONFIG_HOME=$HOME/.config
export NVIM_HOME=$CONFIG/nvim
export CHROME_EXECUTABLE=/usr/bin/firefox

eval $(thefuck --alias)

eval "$(zoxide init zsh)"

source <(fzf --zsh)
