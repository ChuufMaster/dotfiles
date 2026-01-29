# vim: filetype=sh
# Variables
CONFIG=$HOME/.config
DOTFILES=$HOME/dotfiles

# General aliases
alias clr="clear"
alias docker_clean="docker system prune -a -f && docker image prune -a -f && docker volume prune -a -f"
alias get_tuks="rclone copy --drive-shared-with-me --exclude 'node_modules/**' --stats-one-line -v TUKS:TUKS ~/TUKS"
alias e="exit"
alias gls="ls | grep"
alias gla="la | grep"
alias gll="ll | grep"
alias kanata_reload="systemctl --user restart kanata.service && systemctl --user status kanata.service"
alias lg="lazygit"
alias lm="exa --long --icons --git --group-directories-first --header --octal-permissions"
alias "nvim ."=nvim
alias sync_tuks="rclone copy --drive-shared-with-me --stats-one-line -v ~/TUKS TUKS:TUKS"
alias sz="source ~/.zshrc"
# alias zsh="~/Documents/PERSONAL/projects/color_output/test.py"

# TMUX aliases
alias lvim="NVIM_APPNAME=nvim-lazyvim nvim"
alias rvim="NVIM_APPNAME=rvim nvim"
alias tmux="tmux -2"
alias tm="tmux attach || tmux"
alias vim=nvim
alias vi=/usr/bin/vim

# ACT
alias act="act --secret-file .env --artifact-server-path /tmp/artifacts"

# Directory aliases
alias dot="cd ~/dotfiles"
alias config="cd ~/.config"
alias peek="cd ~/BeakPeek"
# alias proj="cd ~/projects"
alias zhypr="cd $DOTFILES/hypr/.config/hypr"
alias zkanata="cd $CONFIG/kanata"
alias zkitty="cd $CONFIG/kitty"
alias znotes="cd $HOME/TUKS/notes"
alias zpeek_front="cd ~/BeakPeek/beakpeek"
alias zpeek_dot="cd ~/BeakPeek/dotnet"
alias zrofi="cd $CONFIG/rofi"
alias zswaync="cd $DOTFILES/swaync/.config/swaync"
alias zscript="cd ~/scripts"
alias ztmux="cd $CONFIG/tmux"
alias ztukes="cd $HOME/TUKS"
alias zvim="cd $CONFIG/nvim"
alias zwaybar="cd $CONFIG/waybar"
alias zyazi="cd $CONFIG/yazi"
alias zzsh="cd ~/.config/zshrc"

# Edit config files
alias eh="zhypr ; $EDITOR"
alias ek="zkitty ; $EDITOR"
alias ekk="zkanata ; $EDITOR"
alias en="znotes ; $EDITOR"
alias ep="proj ; $EDITOR"
alias epd="cd ~/BeakPeek/dotnet ; $EDITOR"
alias epr="cd ~/BeakPeek ; $EDITOR README.md"
alias er="zrofi ; $EDITOR"
alias es="zscript ; $EDITOR"
alias est="cd ~/.config ; $EDITOR starship.toml"
alias esw="zswaync ; $EDITOR"
alias et="ztmux ; $EDITOR"
alias ev="zvim ; $EDITOR"
alias ew="zwaybar ; $EDITOR"
alias ey="zyazi ; $EDITOR"
alias ez="zzsh ; $EDITOR"
# alias ep="peek ; $EDITOR" # removed because BeakPeek is finished
# alias epb="cd ~/BeakPeek/beakpeek ; $EDITOR" # BeakPeek archived

alias sshv='f(){ ssh "$@" -t bash -o vi }; f'

alias bak='f(){mv "$1" "$1.bak"}; f'
alias unbak='f(){mv "$1" "$(echo "$1" | sed -e 's/\.bak//g')"}; f'

alias uvansible='uv tool run --from ansible-core ansible'
alias uvansible-playbook='uv tool run --from ansible-core ansible-playbook -e "ansible_ssh_user=ivan"'
alias uvansible-galaxy='uv tool run --from ansible-core ansible-galaxy'
alias ap='ansible-playbook -e "ansible_ssh_user=ivan"'
alias ag='ansible-galaxy'
alias av='ansible-vault'

alias less='bat --plain --paging=always'
alias get_free_sans='~/Modules/COS721/exam/scripts/get_free_sans'
alias get_diff_free_sans='~/Modules/COS721/exam/scripts/get_diff_free_sans'

