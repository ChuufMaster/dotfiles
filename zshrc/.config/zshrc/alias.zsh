# vim: filetype=sh
# Variables
CONFIG=$HOME/.config
DOTFILES=$HOME/dotfiles

# General aliases
alias sync_tuks="rclone copy --drive-shared-with-me --stats-one-line -v ~/TUKS TUKS:TUKS"
alias get_tuks="rclone copy --drive-shared-with-me --exclude 'node_modules/**' --stats-one-line -v TUKS:TUKS ~/TUKS"
alias lg="lazygit"
alias sz="source ~/.zshrc"
alias clr="clear"
alias kanata_reload="systemctl --user restart kanata.service && systemctl --user status kanata.service"
alias docker_clean="docker system prune -a -f && docker image prune -a -f && docker volume prune -a -f"
alias gls="ls | grep"
alias gla="la | grep"
alias gll="ll | grep"

# TMUX aliases
alias tmux="tmux -2"
alias tm="tmux attach || tmux"
alias e="exit"
alias vim=nvim
alias rvim="NVIM_APPNAME=nvim-refactor nvim"
alias lvim="NVIM_APPNAME=nvim-lazyvim nvim"

# ACT
alias act="act --secret-file .env --artifact-server-path /tmp/artifacts"

# Directory aliases
alias dot="cd ~/dotfiles"
alias config="cd ~/.config"
alias zhypr="cd $DOTFILES/hypr/.config/hypr"
alias zkitty="cd $CONFIG/kitty"
alias zvim="cd $CONFIG/nvim"
alias zwaybar="cd $CONFIG/waybar"
alias zrofi="cd $CONFIG/rofi"
alias zzsh="cd ~/.config/zshrc"
alias zswaync="cd $DOTFILES/swaync/.config/swaync"
alias ztmux="cd $CONFIG/tmux"
alias zrofi="cd $CONFIG/rofi"
alias zscript="cd ~/scripts"
alias zkanata="cd $CONFIG/kanata"
alias znotes="cd $HOME/TUKS/notes"
alias ztukes="cd $HOME/TUKS"
alias peek="cd ~/BeakPeek"
alias zpeek_dot="cd ~/BeakPeek/dotnet"
alias zpeek_front="cd ~/BeakPeek/beakpeek"

# Edit config files
alias ez="zzsh && $EDITOR"
alias ev="zvim && $EDITOR"
alias eh="zhypr && $EDITOR"
alias ew="zwaybar && $EDITOR"
alias ep="peek && $EDITOR"
alias ek="zkitty && $EDITOR"
alias es="zswaync && $EDITOR"
alias ehs="zscript && $EDITOR"
alias et="ztmux && $EDITOR"
alias er="zrofi && $EDITOR"
alias en="znotes && $EDITOR"
alias ekk="zkanata && $EDITOR"
alias epd="cd ~/BeakPeek/dotnet && $EDITOR"
alias epb="cd ~/BeakPeek/beakpeek && $EDITOR"
alias epr="cd ~/BeakPeek && $EDITOR README.md"
