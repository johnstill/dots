function! utils#SyntaxItem()
    return synIDattr(synID(line("."), col("."), 1), "name")
endfunction

" Trims trailing whitespaces
function! utils#TrimWhiteSpace()
  let l:save = winsaveview()
  %s/\s\+$//e
  call winrestview(l:save)
endfunction
