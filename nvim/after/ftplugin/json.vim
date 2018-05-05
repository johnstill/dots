setlocal textwidth=0
setlocal formatprg=python\ -mjson.tool

" JSON gets special bright candy colors (works ok with Badwolf)
hi jsonKeyword ctermfg=154 guifg=#aeee00
hi jsonString ctermfg=211 guifg=#ff9eb8
hi jsonBoolean ctermfg=14 guifg=Cyan
