#!/bin/bash

cp gitconfig $HOME/.gitconfig
cp zsh/zshrc $HOME/.zshrc

mkdir -p $HOME/.config/zsh
mkdir -p $HOME/.config/nvim
mkdir -p $HOME/.config/htop
cp -r zsh/zfunctions $HOME/.config/zsh/zfunctions
cp -r nvim/* $HOME/.config/nvim/
cp htop/htoprc $HOME/.config/htop/htoprc
