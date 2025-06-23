# vim: filetype=sh

function y()
{
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    # cat ~/.cache/wal/sequences
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ 0n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

function randomfiglet()
{
    font="$(basename -s .flf "$(ls /usr/share/figlet/fonts/*.flf | shuf -n 1)")"
    figlet -cWp -f "$font" "$@"
}

function ssh_df()
{
    grep -rPh "^Host ([^*]+)$" $HOME/.ssh 2> /dev/null  \
    | sed "s/Host //"  \
    | cut -d " " -f 2  \
    | sort  \
    | uniq  \
    | fzf  \
    | xargs -I % ssh % 'df -h'
}
