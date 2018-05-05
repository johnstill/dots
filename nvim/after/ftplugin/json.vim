setlocal textwidth=0
setlocal formatprg=python\ -mjson.tool

" JSON gets special bright candy colors (works ok with Badwolf)
function! ReHighlightJson() abort
    highlight jsonKeyword ctermfg=154 guifg=#aeee00
    highlight jsonString ctermfg=211 guifg=#ff9eb8
    highlight jsonBoolean ctermfg=14 guifg=Cyan
endfunction

augroup jsonHiOverrides
    autocmd!
    autocmd ColorScheme * call ReHighlightJson()
augroup END
