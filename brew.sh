#!/bin/bash

# Check if homebrew exists
if ! [ -x "$(command -v brew)" ]; then
  echo 'Homebrew not found.  Install with: '
  echo '/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'
  exit 1
else
  echo "Using brew at $(which brew)"
fi

brew update && brew upgrade

# GNU things
brew install findutils --with-default-names
brew install grep --with-default-names
brew install gnu-tar --with-default-names
brew install gnu-sed --with-default-names
# has no default name flag, requires special handling in rc file
brew install coreutils binutils diffutils

# Dev things
brew install htop tree wget nmap gzip pigz tmux ctags
brew install zsh neovim git node yarn

# Python dependencies
brew install openssl readline sqlite3 xz zlib
# Needed to build psycopg2, even if never used directly (prefer Docker)
brew install postgresql

# Get python itself from python.org, brew will complain if we use multiple versions anyways
