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

brew install htop tree wget gzip pigz ctags zsh neovim git
brew install openssl readline sqlite3 xz zlib postgresql
