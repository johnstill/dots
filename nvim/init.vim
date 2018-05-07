" Version 2.0 - nvim minimalism
" Plugins
call plug#begin('~/.local/share/nvim/plugged')
Plug 'sjl/badwolf'
Plug 'NLKNguyen/papercolor-theme'
Plug 'romainl/Apprentice'

Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-fugitive'

Plug 'elzr/vim-json',  {'for': 'json'}
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim', {'for': 'typescript'}
call plug#end()

augroup recolor
    autocmd!
    " Default apprentice is slightly too washed out for my taste, but I LOVE
    " the emphasis on blue-green
    autocmd ColorScheme * highlight Normal ctermbg=NONE
augroup END

colorscheme apprentice

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

" don't force writing buffer before dropping it
set hidden

nnoremap <space>iv :set list!<cr>
xnoremap < <gv
xnoremap > >gv
tnoremap <ESC> <C-\><C-n>

" NetRW settings
" Quick Command Reference: `vert h netrw-browse-maps`
let g:netrw_sizestyle='H'   " use human readable, base 1024

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
