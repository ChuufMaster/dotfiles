#!/bin/bash
switch-session() {
    tmux list-windows -aF "#{window_activity} #S:#I.#P #W"  \
    | sort -r  \
    | awk '{$1=""; print substr($0,2)}'  \
    | fzf --preview="tmux capture-pane -ep -t {1}"   \
    | cut -d " " -f 1  \
    | xargs tmux switch-client -t
}

ssh-session() {
    SSH_SERVER=$(grep -rPh "^Host ([^*]+)$" $HOME/.ssh 2> /dev/null \
    | sed "s/Host //" \
    | cut -d " " -f 2 \
    | sort \
    | uniq \
    | fzf)
    
    if [[ -z "$SSH_SERVER" ]]; then
        exit 0
    fi

    EXISTS=$(tmux list-windows -t ssh | grep $SSH_SERVER | wc -l)

    if [ $EXISTS -eq 1 ]; then
        tmux switch-client -t ssh:$SSH_SERVER
    else
        tmux switch-client -t ssh
        tmux new-window -S -a -t ssh:1 -n $SSH_SERVER ssh $SSH_SERVER
    fi
}
