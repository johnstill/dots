filetype off
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()
Plugin 'VundleVim/Vundle.vim'                               " vundle manage vundle; required

" Misc Utilities
Plugin 'ervandew/supertab'
Plugin 'itchyny/lightline.vim'
Plugin 'editorconfig/editorconfig-vim'

Plugin 'Yggdroot/indentLine'
Plugin 'lilydjwg/colorizer'                                 " Colors Hex Codes in Vim

" Javascript Syntax Etc
Plugin 'pangloss/vim-javascript'
Plugin 'elzr/vim-json'
Plugin 'mxw/vim-jsx'
Plugin '1995eaton/vim-better-javascript-completion'
Plugin 'leafgarland/typescript-vim'

" Python and related
Plugin 'hynek/vim-python-pep8-indent'
Plugin 'mitsuhiko/vim-jinja'

" Various Markup Syntax Files Etc
Plugin 'gregsexton/MatchTag'
Plugin 'ervandew/sgmlendtag'

" Colorschemes
Plugin 'morhetz/gruvbox'
call vundle#end()

filetype plugin indent on
syntax enable

" Basics
scriptencoding utf-8
set encoding=utf-8

let mapleader=","
let maplocalleader="//"

inoremap jk <ESC>

set laststatus=2
set ruler " show the cursor position all the time
set number " show the line number all the time
set splitright
set splitbelow
set autowrite
set autoread
set hidden
set history=1000 " keep 1000 lines of command line history
set scrolloff=3
set sidescrolloff=4 " should never be needed because wrap is set, but... why not
set nobackup
set nowritebackup
set noswapfile
let g:netrw_liststyle=4

" Theming
set background=dark
let g:gruvbox_termcolors=256

let g:gruvbox_italic=1
let g:gruvbox_bold=1
let g:gruvbox_contrast_dark="hard"
colorscheme gruvbox
hi! normal ctermbg=NONE

" If in a Python Virtualenv, get its name
function! VirtualEnv()
  if !empty($VIRTUAL_ENV)
    return join(['(', split($VIRTUAL_ENV, '/')[-1], ')'], "")
  else
    return ''
  endif
endfunction

" Trims trailing whitespaces
function! TrimWhiteSpace()
  let l:save = winsaveview()
  %s/\s\+$//e
  call winrestview(l:save)
endfunction
command! TrimWhiteSpace call TrimWhiteSpace()

" Statusline setup
let g:lightline = {
\ 'colorscheme': 'gruvbox',
\ 'active': {
\   'left': [ [ 'mode', 'paste' ],
\             [ 'virtualenv', 'readonly', 'absolutepath', 'modified' ] ]
\ },
\ 'component_function': {
\   'virtualenv': 'VirtualEnv'
\ }
\}

" Misc
let g:indentLine_enabled = 0
nnoremap <leader>st :LeadingSpaceToggle<cr>
nnoremap <leader>ig :IndentLinesToggle<cr>
" jsx is allowed in js files (mxw/vim-jsx)
let g:jsx_ext_required = 0
" Stop undoing everything all the time - I never use the capital version anyhow
nnoremap U <nop>
" Quickly create a timestamp
iabbrev  <expr> dts strftime('%c')
" rapidly edit vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Searching
set wildmenu
set wildmode=longest,full
set showcmd " display incomplete commands
set incsearch " searches incrementally
set smartcase " Don't ignore case (if term includes uppercase char)
set wrapscan " searches wrap around the end of the file

" Invisibles
set backspace=indent,eol,start
set listchars=eol:¬,tab:▸\ ,trail:∙
nnoremap <leader>iv :set list!<cr>

" Tabs
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set shiftround

" Line Lengths
set wrap
set linebreak
set textwidth=79
" Hightlight column 80 on each line if a char is there
call matchadd('ColorColumn', '\%80v', 100)

" Window Navigation
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
" mode navigation
noremap H ^
noremap L $
nnoremap <cr> o<esc>

" Stay centered on screen when jumping through search results
nnoremap n nzzzv
nnoremap N Nzzzv
" Emulate behavior of `#` command but with whatever text is visually selected
vnoremap # y/\V<C-R>"<CR>

" on by default
set hlsearch
" toggle search highlighting
nnoremap <leader>h :set hlsearch!<cr>
" easy open/close folds
nnoremap <space> za
" always start without folds
set foldlevel=99
" quick repeat of character under cursor
nnoremap rr vyp

augroup file_triggers
  " Resets the autocmds to make sure we don't define things twice
  autocmd!

  " PEP wants comments & docstrings to stop at 72, code at 79.
  " autocmd Filetype python :highlight ColorColumn ctermbg=235
  " autocmd Filetype python setlocal colorcolumn=73,80
  " autocmd Filetype python setlocal foldmethod=indent

  " For all these types of files, set tabs to be expanded to 2 spaces
  autocmd FileType xml,html,htmljinja,htmldjango,javascript,js,jsx,css,json,vim,yaml,typescript,groovy
  \ setlocal shiftwidth=2 tabstop=2 softtabstop=2 textwidth=0

  " On every write, strip trailing whitespaces
  autocmd BufWritePre * call TrimWhiteSpace()

  autocmd FileType java set tags+=$VIMDIR/tags/jdk8.tags

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

  " Set cursorline only for the active buffer
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

if has('langmap') && exists('+langnoremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If unset (default), this may break plugins (but it's backward
  " compatible).
  set langnoremap
endif
