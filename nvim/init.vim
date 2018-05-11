" Version 2.0 - nvim minimalism
" Plugins
call plug#begin('~/.local/share/nvim/plugged')
Plug 'sjl/badwolf'
Plug 'NLKNguyen/papercolor-theme'
Plug 'romainl/Apprentice'

Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-fugitive'

Plug 'elzr/vim-json'
Plug 'mxw/vim-jsx'
Plug 'ervandew/sgmlendtag'

Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
call plug#end()

augroup recolor
    autocmd!
    " Default apprentice is slightly too washed out for my taste, but I LOVE
    " the emphasis on blue-green
    autocmd ColorScheme * highlight Normal ctermbg=NONE
augroup END

colorscheme apprentice

" Syntax highlight python embedded in vimscript
let g:vimsyn_embed='P'

" These are needed to correctly setup python provider support even when I'm
" working inside of a virtual environment.  Use virtualenv (or whatever) to
" create these two virtual environments, install neovim into each one, and
" then never touch them again.
let s:ROOT_DIR=fnamemodify(expand("$MYVIMRC"), ":p:h")
let g:python_host_prog=s:ROOT_DIR . '/.env/bin/python'
let g:python3_host_prog=s:ROOT_DIR . '/.env3/bin/python'

" A number of options I used to have set are now set by default with nvim.
" `:h nvim-defaults`
set listchars=eol:¬,tab:▸\ ,trail:∙
set softtabstop=4
set shiftwidth=4
set expandtab
set shiftround

set splitright
set splitbelow

set mouse=a
set showbreak=↪
set linebreak
set breakindent

" don't force writing buffer before hiding it
set hidden

nnoremap <space>iv :set list!<cr>
xnoremap < <gv
xnoremap > >gv
tnoremap <ESC> <C-\><C-n>

" NetRW settings
" Quick Command Reference: `:h netrw-browse-maps`
let g:netrw_sizestyle='H'   " use human readable, base 1024
" Use 'a' to toggle hiding / showing these patterns. Unfortunately,
" netrw_gitignore#Hide never generates correct patterns :/
let g:netrw_list_hide='__pycache__,.*\.py[co],.*\.so'

augroup basics
    autocmd!
    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
    " Treat web technologies has being 2-space indents by default
    autocmd BufRead,BufNewFile *.{ts,js,jsx,html,css,json}
    \ setlocal softtabstop=2 shiftwidth=2 textwidth=0
augroup END

augroup trimws
    autocmd!
    " Disable this by running `:autocmd! trimws`
    " Automatically trim trailing whitespace from every kind of file except
    " whats in the filetype blacklist
    autocmd BufWritePre *
    \ if index(["markdown"], &filetype) < 0 |
    \   call utils#TrimWhiteSpace() |
    \ endif
augroup END

command! SyntaxItem echo utils#SyntaxItem()
command! TrimWhiteSpace call utils#TrimWhiteSpace()
command! TreeView call utils#ProjectTreeView()
command! Evimrc :vsplit $MYVIMRC
command! Svimrc :source $MYVIMRC
