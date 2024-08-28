# Variables

# General aliases
alias sync_tuks='rclone copy --drive-shared-with-me --stats-one-line -v ~/TUKS TUKS:TUKS'
alias get_tuks='rclone copy --drive-shared-with-me --exclude "node_modules/**" --stats-one-line -v TUKS:TUKS ~/TUKS'
alias lg='lazygit'
alias sz='source ~/.zshrc'
alias clr='clear'

# Edit config files
alias ez='$EDITOR -p ~/.zshrc $CONFIG/zshrc/init.sh'
alias ev='$EDITOR -p $CONFIG/nvim/lua/ChuufMaster/plugins/init.lua'
alias eh='$EDITOR -p $CONFIG/hypr/hyprland.conf'
alias ew='$EDITOR -p $CONFIG/waybar/config $CONFIG/waybar/modules.json $CONFIG/waybar/style.css'

# TMUX aliases
alias tm='tmux attach || tmux'
alias e='exit'
alias vim=nvim

# Directory aliases
alias dot='cd ~/dotfiles'
alias config='cd ~/.config'
alias zhypr='cd $CONFIG/hypr'
alias zkitty='cd $CONFIG/kitty'
alias zvim='cd $CONFIG/nvim'
alias zwaybar='cd $CONFIG/waybar'
alias zrofi='cd $CONFIG/rofi'
