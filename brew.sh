#!/bin/bash

# Check if homebrew exists
if ! [ -x "$(command -v brew)" ]; then
  echo 'Homebrew not found.  Install with: '
  echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
  exit 1
else
  echo "Using brew at $(which brew)"
fi

brew update
brew upgrade
brew doctor

brew install coreutils binutils diffutils
# ==> Caveats
# ==> coreutils
# Commands also provided by macOS and the commands dir, dircolors, vdir have been installed with the prefix "g".
# If you need to use these commands with their normal names, you can add a "gnubin" directory to your PATH with:
#   PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
# ==> binutils
# binutils is keg-only, which means it was not symlinked into /opt/homebrew,
# because Apple's CLT provides the same tools.
#
# If you need to have binutils first in your PATH, run:
#   printf '%s\n' export\ PATH\=/opt/homebrew/opt/binutils/bin:\$PATH >> /Users/stilljm/.config/zsh/.zshrc
#
# For compilers to find binutils you may need to set:
#   export LDFLAGS=-L/opt/homebrew/opt/binutils/lib
#   export CPPFLAGS=-I/opt/homebrew/opt/binutils/include

# Some GNU things
#brew install findutils --with-default-names
#brew install grep --with-default-names
#brew install gnu-tar --with-default-names
#brew install gnu-sed --with-default-names

# Not installed by OSX at all (nvim and micromamba are most important)
brew install neovim micromamba htop tree pigz wget postgresql

# Apple has own versions installed (see variation with `brew info <package>`)
# brew install zsh git gzip ctags

brew cleanup
