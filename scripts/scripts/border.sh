#!/bin/bash

lt_corner="┏"
rt_corner="┓"
lb_corner="┗"
rb_corner="┛"
hori_line="━"
vert_line="┃"

border(){
    text=$1

    len=${#text}
    height=$(echo text | wc -l)


    hori_bar=$(printf "$hori_line%.0s" $(seq 1 $len))
    vert_bar=$(printf "$vert_line%.0s" $(seq 1 $height))

    echo " $lt_corner$hori_bar$rt_corner\n
$vert_line$text$vert_line\n
$lb_corner$hori_bar$rb_corner"
}

add-top() {
    len=$(( $1 + 2 ))
    hori_bar=$(printf "$hori_line%.0s" $(seq 1 $len))
    echo "$lt_corner$hori_bar$rt_corner"
}

add-bottom() {
    len=$(( $1 + 2 ))
    hori_bar=$(printf "$hori_line%.0s" $(seq 1 $len))
    echo "$lb_corner$hori_bar$rb_corner"
}

pad-text() {
    text=$1
    len=$2

    if [[ $(( $len & 1 )) -eq 1 && $(( ${#text} & 1 )) -eq 0 ]]; then
        text="$text "
    fi
    pad_amount=$(( $(($len - ${#text}))/2 ))
    padding=$(printf " %.0s" $(seq 0 $pad_amount))
    echo "$vert_line$padding$text$padding$vert_line"
}

get-longest() {
    longest=0
    while IFS=$'\n' read -r line; do
        if [[ ${#line} -ge ${longest} ]]; then
            longest=${#line}
        fi
    done < <(echo "$1")

    echo $longest
}

add-border() {
    longest=$(get-longest "$1")
    add-top $longest
    while IFS=$'\n' read -r line; do
        pad-text "$line" $longest
    done < <(echo "$1")
    add-bottom $longest
}

if [[ "$#" -gt 0 ]]; then
    add-border "$1"
fi
