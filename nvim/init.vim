" Version 3.0 - real minimalism
colorscheme retrobox
set number
set colorcolumn=80

" I used to keep special virtual environments in my nvim config directory for
" python provider support.  However, since my home directory is shared via nfs
" among several machines, the providers would only work on the machine they
" were installed with.  So now, I have to just use system specific resources
" and make sure pynvim is installed.
let g:python_host_prog='/usr/local/bin/python2'
let g:python3_host_prog='/usr/local/bin/python3'

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

" don't force writing buffer before hiding it
set hidden

" Previews the results of subsitution commands
set inccommand=split

inoremap jk <ESC>
nnoremap <space>iv :set list!<cr>

" `CTRL-W q` quits the current window. Almost never what I want.
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

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
augroup basics
    autocmd!
    autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
augroup END

" Treat web technologies has being 2-space indents by default
augroup twospacetab
    autocmd!
    autocmd BufRead,BufNewFile *.{ts,js,jsx,html,css,json,yml}
    \ setlocal softtabstop=2 shiftwidth=2 textwidth=0
augroup END

" Disable this by running `:autocmd! trimws`
" Automatically trim trailing whitespace from every kind of file except
" whats in the filetype blacklist
augroup trimws
    autocmd!
    autocmd BufWritePre *
    \ if index(["markdown"], &filetype) < 0 |
    \   call utils#TrimWhiteSpace() |
    \ endif
augroup END
