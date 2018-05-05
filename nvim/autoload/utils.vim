function! utils#SyntaxItem()
    return synIDattr(synID(line("."), col("."), 1), "name")
endfunction
