#!/bin/bash

cp gitconfig $HOME/.gitconfig

cp zsh/zprofile $HOME/.zprofile
cp zsh/zshenv $HOME/.zshenv
cp zsh/zshrc $HOME/.zshrc

mkdir -p $HOME/.config/zsh
cp -r zsh/zfunctions $HOME/.config/zsh/zfunctions
cp -r nvim/* $HOME/.config/nvim/

curl -fLo \
    "$HOME/.config/nvim/site/autoload/plug.vim" \
    --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

nvim +PlugClean +PlugInstall +qall
