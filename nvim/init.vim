" Version 2.0 - nvim minimalism

" Plugins
call plug#begin('~/.local/share/nvim/plugged')
Plug 'sjl/badwolf'
Plug 'editorconfig/editorconfig-vim'
Plug 'elzr/vim-json',  { 'for': 'json' }
call plug#end()

colorscheme badwolf

set listchars=eol:¬,tab:▸\ ,trail:∙
set softtabstop=4
set shiftwidth=4
set expandtab
set shiftround

set splitright
set splitbelow
set mouse=a

inoremap jk <Esc>
nnoremap <space>iv :set list!<cr>
xnoremap < <gv
xnoremap > >gv
tnoremap <ESC> <C-\><C-n>

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
    autocmd BufRead,BufNewFile *.{ts,js,jsx,html,css} 
    \ setlocal softtabstop=2 shiftwidth=2 nowrap
augroup END
