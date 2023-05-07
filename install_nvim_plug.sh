#!/bin/bash

curl -fLo \
    "$XDG_DATA_HOME/nvim/site/autoload/plug.vim" \
    --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

nvim +PlugClean +PlugInstall +qall
