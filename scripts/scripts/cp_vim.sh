#!/bin/bash

HOME_VIMRC=$HOME/.vimrc

check_file_sourced() {
    grep "source /etc/vim/vimrc.local" $1
}

copy_config() {
    [ ! -d "/etc/vim" ] && sudo mkdir /etc/vim
    # [ ! -d "/etc/vim" ] && echo mkdir /etc/vim
    sudo cat > /etc/vim/vimrc.local <<EOF
let mapleader = " "
set timeoutlen=500

set cc=80
set number
set relativenumber

let g:netrw_winsize=30

nnoremap <leader>dd :Explore %:p:h<CR>
nnoremap <leader>da :Explore <CR>

nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l
EOF
    echo "file copied"
}

add_sourced() {
    if ! check_file_sourced $1 && true ; then
        sudo cat >> $1 <<EOF
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif
EOF
    fi
    copy_config
}

ETC_VIMRC=/etc/vimrc
VIM_VIMRC=/etc/vim/vimrc
if [ -f $ETC_VIMRC  ]; then
    echo "Found /etc/vimrc"
    add_sourced $ETC_VIMRC
elif [ -f $VIM_VIMRC  ]; then
    echo "Found /etc/vim/vimrc"
    add_sourced $VIM_VIMRC
else
    echo "No vimrc found at /etc or /etc/vim"
fi
