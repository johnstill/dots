###############################################################################
###   _                   _       _    __       _                           ###
###  (_)_ __ ___  ___  __| |_   _| |  / /______| |__  _ __ ___              ###
###  | | '_ ` _ \/ __|/ _` \ \ / / | / /_  / __| '_ \| '__/ __|             ###
###  | | | | | | \__ \ (_| |\ V /| |/ / / /\__ \ | | | | | (__              ###
### _/ |_| |_| |_|___/\__,_| \_/ |_/_/ /___|___/_| |_|_|  \___|             ###
###|__/                                                                     ###
###############################################################################

# Sets & Creates (if necessary) the XDG Spec dirs and some config dirs
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export VIMDIR="$XDG_CONFIG_HOME/nvim"

mkdir -p \
    $XDG_CONFIG_HOME \
    $XDG_DATA_HOME \
    $XDG_CACHE_HOME \
    $ZDOTDIR \
    $VIMDIR

# Check if a command exists
function has_command () {
    if (( ${#argv} != 1 )); then
        printf 'Usage: has_command <command>\n' >&2
        return 1
    fi
    command -v $1 > /dev/null 2>&1
    return $?
}

# Sets the editor to the first available of: nvim, vim, vi
# and aliases `vv` to edit the appropriate vimrc
if has_command nvim; then
    export EDITOR=nvim
    alias vv="nvim $XDG_CONFIG_HOME/nvim/init.vim"
elif has_command vim; then
    export EDITOR=vim
    alias vv="vim $HOME/.vim/vimrc"
else
    export EDITOR=vi
fi

# convenience mappings to edit / source critical dotfiles quickly
alias zv="$EDITOR $ZDOTDIR/.zshrc"
alias sz="source $ZDOTDIR/.zshrc"

function isDarwin() { [[ $(uname -s) = 'Darwin' ]]; }
function isLinux()  { [[ $(uname -s) = 'Linux'  ]]; }

# display PID when suspending a process
setopt longlistjobs

# report status of background jobs
setopt notify

# NO BEEPING! NO NO NO!
setopt nobeep

# make Man be reasonable
export MANWIDTH=80

# support colors in less (really in Man)
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

export COLORTERM='yes'

# set vi-mode by default
bindkey -v

#
setopt prompt_subst
autoload -Uz colors && colors


##########  History n Dirstack ################################################
# History:
#   All zsh sessions share a history and append that history to the history
#   file; the history will ignore commands that start with a space and remove
#   commands that are duplicated (useful to pruning the history of commands that
#   I spam a a a lot, like `ls`)
# Where to store the history and how much of it to save
HISTFILE=$ZDOTDIR/.zhistory
HISTSIZE=999
SAVEHIST=999

# Bindings are for <UP>, <DOWN>, and <C-R>
bindkey '^[[A'  history-beginning-search-backward
bindkey '^[[B'  history-beginning-search-forward
bindkey '^R'	history-incremental-pattern-search-backward

setopt append_history
setopt share_history
setopt extended_history
setopt hist_ignore_all_dups
setopt hist_ignore_space


# If I enter the name of directory and that name doesn't shadow a command, just
# go to that directory.  Furthermore, `cd` automatically pushes the last
# directory onto the directory stack (unless its already there)
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups


##########  Completion  #######################################################
# always rehash the whole command path when a command completion is attempted
setopt hash_list_all
setopt completeinword

# glob with #, ~, and ^ but NEVER match dotfiles
setopt extendedglob
setopt noglobdots

# MOST of this is ripped almost verbatim from grml-etc-core /etc/zsh/zshrc
# TODO: comb through all this crud and
#   (A) figure out what the hell it means
#   (B) decide if I really _want_ that behavior
zstyle :compinstall filename "$ZDOTDIR/.zshrc"
autoload -Uz compinit && compinit

#   https://github.com/grml/grml-etc-core/blob/master/etc/zsh/zshrc
for mod in parameter complist deltochar mathfunc ; do
    zmodload -i zsh/${mod} 2>/dev/null || print "Notice: no ${mod} available :("
done && builtin unset -v mod

# allow one error for every three characters typed in approximate completer
zstyle ':completion:*:approximate:'    max-errors 'reply=( $((($#PREFIX+$#SUFFIX)/3 )) numeric )'

# don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '(aptitude-*|*\~)'

# start menu completion only if it could find no unambiguous initial string
zstyle ':completion:*:correct:*'       insert-unambiguous true
zstyle ':completion:*:corrections'     format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}'
zstyle ':completion:*:correct:*'       original true

# activate color-completion
zstyle ':completion:*:default'         list-colors ${(s.:.)LS_COLORS}
# format on completion
zstyle ':completion:*:descriptions'    format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'

# automatically complete 'cd -<tab>' and 'cd -<ctrl-d>' with menu
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select

# insert all expansions for expand completer
zstyle ':completion:*:expand:*'        tag-order all-expansions
zstyle ':completion:*:history-words'   list false

# activate menu
zstyle ':completion:*:history-words'   menu yes

# ignore duplicate entries
zstyle ':completion:*:history-words'   remove-all-dups yes
zstyle ':completion:*:history-words'   stop yes

# match uppercase from lowercase
zstyle ':completion:*'                 matcher-list 'm:{a-z}={A-Z}'

# separate matches into groups
zstyle ':completion:*:matches'         group 'yes'
zstyle ':completion:*'                 group-name ''

# if there are more than 5 options allow selecting from a menu
zstyle ':completion:*'               menu select=5

zstyle ':completion:*:messages'        format '%d'
zstyle ':completion:*:options'         auto-description '%d'

# describe options in full
zstyle ':completion:*:options'         description 'yes'

# on processes completion complete all user processes
zstyle ':completion:*:processes'       command 'ps -au$USER'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# provide verbose completion information
zstyle ':completion:*'                 verbose true

# recent (as of Dec 2007) zsh versions are able to provide descriptions
# for commands (read: 1st word in the line) that it will list for the user
# to choose from. The following disables that, because it's not exactly fast.
zstyle ':completion:*:-command-:*:'    verbose false

# set format for warnings
zstyle ':completion:*:warnings'        format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d'

# define files to ignore for zcompile
zstyle ':completion:*:*:zcompile:*'    ignored-patterns '(*~|*.zwc)'
zstyle ':completion:correct:'          prompt 'correct to: %e'

# Ignore completion functions for commands you don't have:
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'

# Provide more processes in completion of programs like killall:
zstyle ':completion:*:processes-names' command 'ps c -u ${USER} -o command | uniq'

# complete manual by their section
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true
zstyle ':completion:*:man:*'      menu yes select

# Search path for sudo completion
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin \
                                            /usr/local/bin  \
                                            /usr/sbin       \
                                            /usr/bin        \
                                            /sbin           \
                                            /bin            \
                                            /usr/X11R6/bin

# provide .. as a completion
zstyle ':completion:*' special-dirs ..

# run rehash on completion so new installed program are found automatically:
function _force_rehash () {
    (( CURRENT == 1 )) && rehash
    return 1
}

# Spelling correction
setopt correct
zstyle -e ':completion:*' completer '
    if [[ $_last_try != "$HISTNO$BUFFER$CURSOR" ]] ; then
        _last_try="$HISTNO$BUFFER$CURSOR"
        reply=(_complete _match _ignored _prefix _files)
    else
        if [[ $words[1] == (rm|mv) ]] ; then
            reply=(_complete _files)
        else
            reply=(_oldlist _expand _force_rehash _complete _ignored _correct _approximate _files)
        fi
    fi'

# command for process lists, the local web server details and host completion
zstyle ':completion:*:urls' local 'www' '/var/www/' 'public_html'

# Use a cache to speed up some completion functions
zstyle ':completion:*' use-cache  yes
zstyle ':completion:*:complete:*' cache-path "${ZDOTDIR:-HOME}/.cache"

# use generic completion system for programs not yet defined; (_gnu_generic works
# with commands that provide a --help option with "standard" gnu-like output.)
for compcom in cp deborphan df feh fetchipac gpasswd head hnb ipacsum mv \
                pal stow uname ; do
    [[ -z ${_comps[$compcom]} ]] && compdef _gnu_generic ${compcom}
done; unset compcom

# I work with Vim and Python a lot, and I have never, ever once wanted to run
# `vim __pycache__` or `vim *.py[c|o]`.  This line prevents autocompletion from
# ever suggesting such a thing.
zstyle ':completion:*:*:vim:*' file-patterns '^(*.py(c|o)|__pycache__):source-files' '*:all-files'
zstyle ':completion:*:*:nvim:*' file-patterns '^(*.py(c|o)|__pycache__):source-files' '*:all-files'

# Shift-Tab (BackTab) moves backwards through a menu
bindkey -M menuselect '^[[Z' reverse-menu-complete
# These all accept a menu option but remain in the menu
bindkey -M menuselect '+' accept-and-menu-complete

# Autogenerated by `pip completion --zsh`
# pip zsh completion start
function _pip_completion {
  local words cword
  read -Ac words
  read -cn cword
  reply=( $( COMP_WORDS="$words[*]" \
             COMP_CWORD=$(( cword-1 )) \
             PIP_AUTO_COMPLETE=1 $words[1] ) )
}
compctl -K _pip_completion pip
# pip zsh completion end


##########  Line-Editing & Keybindings  #######################################
# NOTE BENE: to get a key-code, run cat and see what it does /shrug

# some vi-mode-related bindings
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey 'jk' vi-cmd-mode



# TODO:
#   see note above on the completion stuff - I'm pretty sure this widget is
#   important to the (totally awesome) completion stuff grml has going on, but
#   also can do some other stuff... need to dig into this more.
#
# accept-line:
# This widget can prevent unwanted autocorrections from command-name
# to _command-name, rehash automatically on enter and call any number
# of builtin and user-defined widgets in different contexts.
#
# For a broader description, see:
# <http://bewatermyfriend.org/posts/2007/12-26.11-50-38-tooltime.html>
#
# The code is imported from the file 'zsh/functions/accept-line' from
# <http://ft.bewatermyfriend.org/comp/zsh/zsh-dotfiles.tar.bz2>, which
# distributed under the same terms as zsh itself.

# A newly added command will may not be found or will cause false
# correction attempts, if you got auto-correction set. By setting the
# following style, we force accept-line() to rehash, if it cannot
# find the first word on the command line in the $command[] hash.
zstyle ':acceptline:*' rehash true

function Accept-Line () {
    setopt localoptions noksharrays
    local -a subs
    local -xi aldone
    local sub
    local alcontext=${1:-$alcontext}

    zstyle -a ":acceptline:${alcontext}" actions subs

    (( ${#subs} < 1 )) && return 0

    (( aldone = 0 ))
    for sub in ${subs} ; do
        [[ ${sub} == 'accept-line' ]] && sub='.accept-line'
        zle ${sub}

        (( aldone > 0 )) && break
    done
}

function Accept-Line-getdefault () {
    emulate -L zsh
    local default_action

    zstyle -s ":acceptline:${alcontext}" default_action default_action
    case ${default_action} in
        ((accept-line|))
            printf ".accept-line"
            ;;
        (*)
            printf ${default_action}
            ;;
    esac
}

function Accept-Line-HandleContext () {
    zle Accept-Line

    default_action=$(Accept-Line-getdefault)
    zstyle -T ":acceptline:${alcontext}" call_default \
        && zle ${default_action}
}

function accept-line () {
    setopt localoptions noksharrays
    local -a cmdline
    local -x alcontext
    local buf com fname format msg default_action

    alcontext='default'
    buf="${BUFFER}"
    cmdline=(${(z)BUFFER})
    com="${cmdline[1]}"
    fname="_${com}"

    Accept-Line 'preprocess'

    zstyle -t ":acceptline:${alcontext}" rehash \
        && [[ -z ${commands[$com]} ]]           \
        && rehash

    if    [[ -n ${com}               ]] \
       && [[ -n ${reswords[(r)$com]} ]] \
       || [[ -n ${aliases[$com]}     ]] \
       || [[ -n ${functions[$com]}   ]] \
       || [[ -n ${builtins[$com]}    ]] \
       || [[ -n ${commands[$com]}    ]] ; then

        # there is something sensible to execute, just do it.
        alcontext='normal'
        Accept-Line-HandleContext

        return
    fi

    if    [[ -o correct              ]] \
       || [[ -o correctall           ]] \
       && [[ -n ${functions[$fname]} ]] ; then

        # nothing there to execute but there is a function called
        # _command_name; a completion widget. Makes no sense to
        # call it on the commandline, but the correct{,all} options
        # will ask for it nevertheless, so warn the user.
        if [[ ${LASTWIDGET} == 'accept-line' ]] ; then
            # Okay, we warned the user before, he called us again,
            # so have it his way.
            alcontext='force'
            Accept-Line-HandleContext

            return
        fi

        if zstyle -t ":acceptline:${alcontext}" nocompwarn ; then
            alcontext='normal'
            Accept-Line-HandleContext
        else
            # prepare warning message for the user, configurable via zstyle.
            zstyle -s ":acceptline:${alcontext}" compwarnfmt msg

            if [[ -z ${msg} ]] ; then
                msg="%c will not execute and completion %f exists."
            fi

            zformat -f msg "${msg}" "c:${com}" "f:${fname}"

            zle -M -- "${msg}"
        fi
        return
    elif [[ -n ${buf//[$' \t\n']##/} ]] ; then
        # If we are here, the commandline contains something that is not
        # executable, which is neither subject to _command_name correction
        # and is not empty. might be a variable assignment
        alcontext='misc'
        Accept-Line-HandleContext

        return
    fi

    # If we got this far, the commandline only contains whitespace, or is empty.
    alcontext='empty'
    Accept-Line-HandleContext
}

zle -N accept-line
zle -N Accept-Line
zle -N Accept-Line-HandleContext


##########  Main Prompt  F U N.  ##############################################

# secondary prompt, printed when the shell needs more information to complete a
# command.
PS2='\`%_> '
# selection prompt used within a select loop.
PS3='?# '
# the execution trace prompt (setopt xtrace). default: '+%N:%i>'
PS4='+%N:%i:%_> '

# If the last command had a non-zero status, display it
PS1='%(?..[%F{red}%?%f])'
PS1+='%B%F{cyan}%n%f%b'             # username
PS1+="@"                            # *nix traditions...
PS1+='%B%F{white}%m%f%b '           # hostname
PS1+='%F{cyan}%20<..<%~%<<%f '      # the CWD truncated to 20 chars
PS1+='[%!]'                         # Current history event number
PS1+='${VIMODE}'                    # ZLE's current edit mode

# Here we define a function that gets called every time the line editor is
# either initialized or a new keymap is selected (i.e.: every time our entry
# MODE changes) - we parse what mode we're in (viins or vicmd) and return a
# useful indicator.  Otherwise it's like trying to edit a file without knowing
# if you're in Normal vs Insert vs Replace mode.  Ugh.
# NOTE: the symbols are
#   '$' for normal insert mode
#   a big red 'I' for command mode - to me this is 'NOT insert' because red
function zle-line-init zle-keymap-select {
    DOLLAR='%B%F{green}$%f%b '
    GIANT_I='%B%F{red}I%f%b '
    VIMODE="${${KEYMAP/vicmd/$GIANT_I}/(main|viins)/$DOLLAR}"
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select


##########  Right Prompt (Git info)  ##########################################
# TODO: go through all zsh's docs on vcs_info and see if its worth rewriting
#   this to use their funcs
#
# Sets the right side prompt to be a disappearing VCS indicator, assuming I'm in
# a git-controlled directory
GIT_PROMPT_SYMBOL="%{$fg[cyan]%}±"
GIT_PROMPT_PREFIX="%{$fg[green]%}[%{$reset_color%}"
GIT_PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%}"
GIT_PROMPT_AHEAD="%{$fg[red]%}ANUM%{$reset_color%}"
GIT_PROMPT_BEHIND="%{$fg[cyan]%}BNUM%{$reset_color%}"
GIT_PROMPT_MERGING="%{$fg_bold[magenta]%}⚡︎%{$reset_color%}"
GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}●%{$reset_color%}"
GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%}●%{$reset_color%}"
GIT_PROMPT_STAGED="%{$fg_bold[green]%}●%{$reset_color%}"
#
# Show Git branch/tag, or name-rev if on detached head
parse_git_branch() {
  (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}

# Show different symbols as appropriate for various Git repository states
parse_git_state() {
  # Compose this value via multiple conditional appends.
  local GIT_STATE=""

  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_AHEAD" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}
  fi

  local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_BEHIND" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}
  fi

  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
  fi

  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
  fi

  if ! git diff --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
  fi

  if ! git diff --cached --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
  fi

  if [[ -n $GIT_STATE ]]; then
    echo "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
  fi
}

# If inside a Git repository, print its branch and state
git_prompt_string() {
  local git_where="$(parse_git_branch)"
  [ -n "$git_where" ] && echo  "$GIT_PROMPT_SYMBOL$(parse_git_state)$GIT_PROMPT_PREFIX%{$fg[white]%}${git_where#(refs/heads/|tags/)}$GIT_PROMPT_SUFFIX"
}
# Set the right-hand prompt
RPS1='$(git_prompt_string)'


##########  Aliases and Convenience Functions  ################################

autoload -U zmv

pyclean() {
    # kill all the *.pyc *.pyo __pycache__, but don't spend forever digging
    # around in directories that we shouldn't have to care about
    print -l (^node_modules/)#* | grep -E "(__pycache__|\.pyc|\.pyo)" | xargs rm -rf
}

wstrim() {
    sed -i'' -e's//[[:space:]]*$//' $1
}

mdman() { pandoc -s -f markdown -t man "$*" | man -l -; }
rstman() { pandoc -s -f rst -t man "$*" | man -l -; }

# Pocket Reference for Globbing
function H-Glob () {
    echo -e "
    /      directories
    .      plain files
    @      symbolic links
    =      sockets
    p      named pipes (FIFOs)
    *      executable plain files (0100)
    %      device files (character or block special)
    %b     block special files
    %c     character special files
    r      owner-readable files (0400)
    w      owner-writable files (0200)
    x      owner-executable files (0100)
    A      group-readable files (0040)
    I      group-writable files (0020)
    E      group-executable files (0010)
    R      world-readable files (0004)
    W      world-writable files (0002)
    X      world-executable files (0001)
    s      setuid files (04000)
    S      setgid files (02000)
    t      files with the sticky bit (01000)

  print *(m-1)          # Files modified up to a day ago
  print *(a1)           # Files accessed a day ago
  print *(@)            # Just symlinks
  print *(Lk+50)        # Files bigger than 50 kilobytes
  print *(Lk-50)        # Files smaller than 50 kilobytes
  print **/*.c          # All *.c files recursively starting in \$PWD
  print **/*.c~file.c   # Same as above, but excluding 'file.c'
  print (foo|bar).*     # Files starting with 'foo' or 'bar'
  print *~*.*           # All Files that do not contain a dot
  chmod 644 *(.^x)      # make all plain non-executable files publically readable
  print -l *(.c|.h)     # Lists *.c and *.h
  print **/*(g:users:)  # Recursively match all files that are owned by group 'users'
  echo /proc/*/cwd(:h:t:s/self//) # Analogous to >ps ax | awk '{print $1}'<"
}
alias help-zshglob=H-Glob

# listing and navigation standards  (thanks again, grml!)
# Standard listing is in color, with human readable sizes, and symbols
# BSD Colors
export LSCOLORS='Gxfxexdxcxegedabagacad'
# Linux Colors
export LS_COLORS='di=1;36:ln=35:so=34:pi=33:ex=32:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
# Use brew installed coreutils (needs OS X check)
alias ls='gls -hF --color=auto --group-directories-first'
alias l='ls '
# list EVERYTHING
alias la='ls -la'
# list everything but the dots
alias ll='ls -l'
# only dot dirs
alias lad='ls -d .*(/)'
# only dot files
alias lsa='ls -a .*(.)'
# only sym-links
alias lsl='ls -l *(@)'
# only executables
alias lsx='-l *(*)'
# grep should use colors if it can
alias grep="grep --color=auto"
# default `tree` has colors and NEVER lists .git or node_modules
alias tree='tree -CFI ".git|node_modules"'
# ltree gives a listing similar to ls -la
alias ltree='tree -phFugr --dirsfirst'
# This is the equivalent to shoving everything off the desk and then unrolling
# a map on it -- at least if the project is small /shrug
alias ctree='clear; tree'
alias cltree='clear; ltree'

# smart cd function, allows switching to /etc when running 'cd /etc/fstab'
function cd () {
    if (( ${#argv} == 1 )) && [[ -f ${1} ]]; then
        [[ ! -e ${1:h} ]] && return 1
        print "Correcting ${1} to ${1:h}"
        builtin cd ${1:h}
    else
        builtin cd "$@"
    fi
}

# git & other vcs stuff
alias gst='git status'
alias gd='git diff'
alias gc='git checkout'
# Take me to the git project root dir, please
alias cdg='cd $(git rev-parse --show-toplevel)'
alias cdp='cd ${PROJECT_HOME:-${HOME}}'

# Package mgmt
# Removes all orphaned packages
alias prune-orphans='sudo pacman -Rns $(pacman -Qtdq)'

# docker
# quick listing of basic stuff
alias dp='docker ps'
alias da='docker ps -a'
alias dv='docker volume ls'
alias dn='docker network ls'
# docker ps "short"
alias dps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.RunningFor}}"'
# docker container network topology
alias dnet='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}\t{{.Networks}}"'
# ...this one needs to be followed by a container ID
alias docker-ip='docker inspect --format "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}"'

alias di='docker images'
# Danger!
alias dip='docker image prune'
alias dsp='docker system prune'
alias dck='docker-compose'

# remember all my dumb docker aliases
alias dh='alias | grep "docker"'

# 1337
alias star-wars='telnet towel.blinkenlights.nl'


# PATH
export WORKON_HOME="$HOME/.snakefarm"  # SNAaAaAaKES
export PROJECT_HOME=$HOME/projects/
mkdir -p $WORKON_HOME
mkdir -p $PROJECT_HOME
path+=$HOME/bin
path+=$HOME/.local/bin
path+=$HOME/.local/scripts
# OS X
if isDarwin; then
    [[ -v ITERM_SESSION_ID ]] && source ~/.vim/bundle/gruvbox/gruvbox_256palette_osx.sh
    path+=$HOME/Library/Python/3.6/bin
    source $HOME/Library/Python/3.6/bin/virtualenvwrapper.sh
fi
export VIRTUALENVWRAPPER_PYTHON=$(which python3)
export VIRTUALENVWRAPPER_VIRTUALENV=$(which virtualenv)
# Google SDK stuff
for fname in "completion", "path"; do
    filePath="$HOME/gcloud/google-cloud-sdk/$fname.zsh.inc"
    [[ -e $filePath ]] && source $filePath
done

# Set JAVA_HOME if we have java
[[ -x /usr/libexec/java_home ]] && export JAVA_HOME=$(/usr/libexec/java_home)

# The first line removes empty elements from the array, the second line removes
# duplicates (-U for "unique", basically)
path=( "${path[@]:#}" )
typeset -U path PATH fpath FPATH

export TIMEFMT='%J   %U  user %S system %P cpu %*E total'$'\n'\
'avg shared (code):         %X KB'$'\n'\
'avg unshared (data/stack): %D KB'$'\n'\
'total (sum):               %K KB'$'\n'\
'max memory:                %M MB'$'\n'\
'page faults from disk:     %F'$'\n'\
'other page faults:         %R'
