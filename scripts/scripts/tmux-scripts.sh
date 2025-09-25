#!/bin/bash
switch-session() {
    tmux list-windows -aF "#{window_activity} #S:#I.#P #W"  \
    | sort -r  \
    | awk '{$1=""; print substr($0,2)}'  \
    | fzf --preview="tmux capture-pane -ep -t {1}"   \
    | cut -d " " -f 1  \
    | xargs tmux switch-client -t
}

ls-fzf(){
    echo $(cd $1 && ls | fzf --preview 'eza --color=always -l {}')
}

switch-and-command()
{
    CHOICE="$1"
    SESSION="$2"
    COMMAND="$3"

    if [[ -z "$CHOICE" ]]; then
        exit 1
    fi

    EXISTS=$(tmux list-windows -t $SESSION | grep $CHOICE | wc -l)
    if [ $EXISTS -eq 1 ]; then
        tmux switch-client -t $SESSION:$CHOICE
    else
        tmux switch-client -t $SESSION
        tmux new-window -S -a -t $SESSION:1 -n $CHOICE "$COMMAND"
    fi
}

ssh-session() {
    SSH_SERVER=$(grep -rPh "^Host ([^*]+)$" $HOME/.ssh 2> /dev/null \
    | sed "s/Host //" \
    | cut -d " " -f 2 \
    | sort \
    | uniq \
    | fzf)

    switch-and-command $SSH_SERVER "ssh" "ssh $SSH_SERVER"
}

open-config() {
    TOOL=$(
        cat <(ls ~/dotfiles/) <(echo ssh) \
        | grep -v -E "\..*$" \
        | fzf --preview 'eza --color=always ~/.config/{}'
    )

    get-command(){
        if [[ $1 == "ssh" ]]; then
            echo "cd ~/.ssh && nvim"
            exit 0
        fi

        if [[ $1 == "scripts" ]]; then
            echo "cd ~/scripts && nvim"
            exit 0
        fi

        FILE=~/.config/$1
        if [ -d "$FILE" ]; then
            echo "cd $FILE && nvim"
            exit 0
        fi

        files="$FILE.*[^(bak)]"
        echo "nvim $files"

    }
    switch-and-command $TOOL "config" "$(get-command $TOOL)"
}

open-module() {
    MODULE=$(ls-fzf ~/Modules/)
    switch-and-command $MODULE "study" "cd ~/Modules/$MODULE && /bin/zsh"
}

eza-cmd(){
    eza --color=always -l
}
get-project-dir-eza(){
    if [ -d ~/projects/$1 ]; then
        eza-cmd "~/projects/$1"
    elif [ -d ~/projects/plugins/$1 ]; then
        eza-cmd "~/projects/plugins/$1"
    elif [ -d ~/projects/Ansible/$1 ]; then
        eza-cmd "~/projects/Ansible/$1"
    fi
}

get-project-dir(){
    if [ -d ~/projects/$1 ]; then
        echo "/home/chuufmaster/projects/$1"
    elif [ -d ~/projects/plugins/$1 ]; then
        echo "/home/chuufmaster/projects/plugins/$1"
    elif [ -d ~/projects/Ansible/$1 ]; then
        echo "/home/chuufmaster/projects/Ansible/$1"
    fi
}

open-project() {

    PROJECT=$(
        cat \
            <(ls ~/projects/) \
            <(ls ~/projects/plugins) \
            <(ls ~/projects/Ansible) \
            | fzf --preview 'eza --color=always -l $(source ~/scripts/tmux-scripts.sh && get-project-dir {})'
    )
    switch-and-command $PROJECT "projects" "cd $(get-project-dir $PROJECT) && nvim"
}

open-vm() {
    VM=$(ls-fzf ~/VMs/)
    switch-and-command $VM "VMs" "cd ~/VMs/$VM && /bin/zsh"
}

open-role() {
    ROLE=$(ls-fzf ~/SCS/repos/scs-ansible-repo/roles/)
    switch-and-command $ROLE "ansible" "cd ~/SCS/repos/scs-ansible-repo/roles/$ROLE && nvim"
}

open-repo() {
    REPO=$(ls-fzf ~/SCS/repos)
    switch-and-command $REPO "SCS" "cd ~/SCS/repos/$REPO && nvim"
}
