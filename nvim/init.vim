" Version 2.0 - nvim minimalism
" Plugins
call plug#begin('~/.local/share/nvim/plugged')
" Colorschemes
Plug 'sjl/badwolf'
Plug 'NLKNguyen/papercolor-theme'
Plug 'romainl/Apprentice'
" Misc Utils
Plug 'editorconfig/editorconfig-vim'
Plug 'Konfekt/FoldText'
Plug 'haya14busa/vim-asterisk'
" JS, JSX, other misc filetypes
Plug 'ervandew/sgmlendtag'
Plug 'elzr/vim-json'
Plug 'mxw/vim-jsx'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'chr4/nginx.vim'
Plug 'cespare/vim-toml'
" Python
Plug 'vim-python/python-syntax'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'tmhedberg/SimpylFold'
" Julia
Plug 'JuliaEditorSupport/julia-vim'
call plug#end()

augroup recolor
    autocmd!
    " Remove all background color
    autocmd ColorScheme * highlight Normal guibg=NONE ctermbg=NONE
augroup END
colorscheme badwolf

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

" I used to keep special virtual environments in my nvim config directory for
" python provider support.  However, since my home directory is shared via nfs
" among several machines, the providers would only work on the machine they
" were installed with.  So now, I have to just use system specific resources
" and make sure pynvim is installed.
let g:python_host_prog='/usr/local/bin/python2'
let g:python3_host_prog='/usr/local/bin/python3'

" A number of options I used to have set are now set by default with nvim.
" Ref: `:h nvim-defaults`

" Tabstops, etc
set listchars=eol:¬,tab:▸\ ,trail:∙
set softtabstop=4
set shiftwidth=4
set expandtab
set shiftround

" Position of splits
set splitright
set splitbelow

" wrapping / breaking
set showbreak=↪
set linebreak
set breakindent

" Use the mouse if able
set mouse=a

" don't force writing buffer before hiding it
set hidden

" Preview subsitute commands
set inccommand=split

let g:asterisk#keeppos = 1
map *  <Plug>(asterisk-z*)
map #  <Plug>(asterisk-z#)
map g* <Plug>(asterisk-gz*)
map g# <Plug>(asterisk-gz#)

inoremap jk <ESC>
nnoremap <space>iv :set list!<cr>

nnoremap <C-w>q <Nop>
nnoremap <C-w><C-q> <Nop>

" NetRW settings
" Quick Command Reference: `:h netrw-browse-maps`
let g:netrw_sizestyle='H'   " use human readable, base 1024
" Use 'a' to toggle hiding / showing these patterns. Unfortunately,
" netrw_gitignore#Hide never generates correct patterns :/
let g:netrw_list_hide='__pycache__,.*\.py[co],.*\.so'
" Tree view
let g:netrw_liststype=3

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
    autocmd BufRead,BufNewFile *.{ts,js,jsx,html,css,json,yml}
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

" Usefull commands for running specific types of terminal buffers
command! RunIpy :vsplit term://ipython -i %
