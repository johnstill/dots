" Version 2.0 - minimalism
call plug#begin('~/.local/share/nvim/plugged')
Plug 'sjl/badwolf'
Plug 'editorconfig/editorconfig-vim'
call plug#end()

filetype plugin on
colorscheme badwolf

inoremap jk <Esc>

set omnifunc=syntaxcomplete#Complete

set backspace=indent,eol,start

set listchars=eol:¬,tab:▸\ ,trail:∙
nnoremap <space>iv :set list!<cr>

set tabstop=8
set softtabstop=4
set shiftwidth=4
set expandtab
set shiftround

set splitright
set splitbelow

set wildmode=longest:full,full

if has('mouse')
    set mouse=a
endif

augroup basics
    autocmd!
    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
augroup END
