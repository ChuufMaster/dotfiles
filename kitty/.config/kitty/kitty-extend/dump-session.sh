#!/usr/bin/env bash

set -eou pipefail

KITTY_HOME=$HOME/.config/kitty

#kitty @ ls | ./kitty-convert-dump.py > session.conf

kitty @ ls |  $KITTY_HOME/kitty-extend/kitty-convert-dump.py > $KITTY_HOME/session.conf

echo "kitty session dumped"

echo; read -r -p "Press Enter to exit"; echo ""



