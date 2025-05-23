#!/bin/bash

# ssh $1 "bash -s" < ./cp_vim.sh
echo $2 | ssh -tt $1 "bash -s" < ./cp_vim.sh
