" Version 2.0 - nvim minimalism
" Plugins
" Stuff
call plug#begin('~/.local/share/nvim/plugged')
Plug 'sjl/badwolf'
Plug 'NLKNguyen/papercolor-theme'
Plug 'romainl/Apprentice'

Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'
Plug 'majutsushi/tagbar', {'on': 'TagbarToggle'}
Plug 'Konfekt/FoldText'
" Plug 'Konfekt/FastFold' TODO: is this needed with Neovim (or at all?)
Plug 'haya14busa/vim-asterisk'

Plug 'ervandew/sgmlendtag'
Plug 'elzr/vim-json'
Plug 'mxw/vim-jsx'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'

" This python syntax file is actually up to date and maintained - the official
" one hasn't been updated in two years :(
Plug 'vim-python/python-syntax'
" Other python utilities
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'tmhedberg/SimpylFold'
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

" Enable all python highlighting options specified in the syntax file
let g:python_highlight_all=1
" Minimal (but correct) folding: too many folds are more hindrance than help
let g:SimpylFold_fold_import=0
" Folds are off by default; but toggle with `zi`
set nofoldenable

" Tags and tagbar
let g:tagbar_show_visibility=0

" These are needed to correctly setup python provider support even when I'm
" working inside of a virtual environment.  Use virtualenv (or whatever) to
" create these two virtual environments, install neovim into each one, and
" then never touch them again.
let s:ROOT_DIR=fnamemodify(expand("$MYVIMRC"), ":p:h")
let g:python_host_prog=s:ROOT_DIR . '/.env/bin/python'
let g:python3_host_prog=s:ROOT_DIR . '/.env3/bin/python'

" A number of options I used to have set are now set by default with nvim.
" Ref: `:h nvim-defaults`
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

" Preview subsitute commands
set inccommand=split

let g:asterisk#keeppos = 1
map *  <Plug>(asterisk-z*)
map #  <Plug>(asterisk-z#)
map g* <Plug>(asterisk-gz*)
map g# <Plug>(asterisk-gz#)

nnoremap <space>iv :set list!<cr>
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
