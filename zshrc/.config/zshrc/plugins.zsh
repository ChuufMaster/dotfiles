# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

export ZSH="$HOME/.oh-my-zsh"

plugins=(
  # github
  gradle
  docker
  docker-compose
  # flutter
  fzf
  # kitty
  man
  # pyenv
  # python
  # pip
  thefuck
  tmux
  zoxide
  git
  zsh-completions
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
source $ZSH/oh-my-zsh.sh
