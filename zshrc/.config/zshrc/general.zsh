# bindkey -v
# set -o vi

export EDITOR=nvim
export CONFIG=~/.config
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export XDG_CONFIG_HOME=$HOME/.config
export NVIM_HOME=$CONFIG/nvim
export CHROME_EXECUTABLE=/usr/bin/firefox
export ANSIBLE_NOCOWS=1
export ANSIBLE_VAULT_PASSWORD_FILE=./.vault_pass
export ANSIBLE_SSH_TRANSFER_METHOD=scp
# set -o vi

# set editing-mode vi
# set show-mode-in-prompt on
# set vi-ins-mode-string "\1\e[6 q\2"
# set vi-cmd-mode-string "\1\e[2 q\2"

# optionally:
# switch to block cursor before executing a command

# bindkey -v

eval $(thefuck --alias)

eval "$(zoxide init zsh)"

source <(fzf --zsh)

# FZF theme
# export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
#   --highlight-line \
#   --info=inline-right \
#   --ansi \
#   --layout=reverse \
#   --border=none \
#   --color=bg+:#283457 \
#   --color=bg:#16161e \
#   --color=border:#27a1b9 \
#   --color=fg:#c0caf5 \
#   --color=gutter:#16161e \
#   --color=header:#ff9e64 \
#   --color=hl+:#2ac3de \
#   --color=hl:#2ac3de \
#   --color=info:#545c7e \
#   --color=marker:#ff007c \
#   --color=pointer:#ff007c \
#   --color=prompt:#2ac3de \
#   --color=query:#c0caf5:regular \
#   --color=scrollbar:#27a1b9 \
#   --color=separator:#ff9e64 \
#   --color=spinner:#ff007c \
# "

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
    --highlight-line \
    --info=inline-right \
    --ansi \
    --layout=reverse \
    --border=none \
    --color=fg:#ebdbb2 \
    --color=bg:#282828 \
    --color=hl:#b16286 \
    --color=fg+:#689d6a \
    --color=bg+:#32302f \
    --color=hl+:#d3869b \
    --color=info:#d65d0e \
    --color=prompt:#458588 \
    --color=pointer:#fe8019\
    --color=marker:#8ec07c \
    --color=spinner:#cc241d \
    --color=header:#fabd2f \
    "
