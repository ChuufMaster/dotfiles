# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  github
  gradle
  docker
  docker-compose
  flutter
  fzf
  kitty
  man
  pyenv
  python
  pip
  thefuck
  tmux
  zoxide
  zsh-syntax-highlighting
  zsh-autosuggestions
)

export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh
