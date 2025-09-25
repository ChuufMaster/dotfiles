# vim: filetype=sh
CONFIGS=$HOME/.config
CONFIG_ZSH=$CONFIGS/zshrc

source $CONFIG_ZSH/init.zsh
source $CONFIG_ZSH/path.zsh
source $CONFIG_ZSH/init.zsh
source $CONFIG_ZSH/alias.zsh
source $CONFIG_ZSH/functions.zsh
source $CONFIG_ZSH/general.zsh
source $CONFIG_ZSH/plugins.zsh
source $CONFIG_ZSH/completions.zsh
source $CONFIG_ZSH/after.zsh
# ~/projects/color_output/test.py

fpath+=~/.zfunc; autoload -Uz compinit; compinit

zstyle ':completion:*' menu select
