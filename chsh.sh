#!/bin/bash
cat >> ~/.bash_profile << "HERE"

# This snippet will launch a Z Shell as your login shell no matter what chsh
# thinks your login shell should be.  Useful if your user account is pulled
# from over NFS, for example.
if [ "$SHELL" != "/usr/bin/zsh" ]; then
    export SHELL="/usr/bin/zsh";
    # -l: login shell
    exec /usr/bin/zsh -l
fi
HERE
