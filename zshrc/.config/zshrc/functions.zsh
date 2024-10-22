# vim: filetype=sh

function y()
{
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
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
