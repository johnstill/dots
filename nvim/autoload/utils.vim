function! utils#SyntaxItem()
    return synIDattr(synID(line("."), col("."), 1), "name")
endfunction

" Trims trailing whitespaces
function! utils#TrimWhiteSpace()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
endfunction

function! utils#ProjectTreeView() abort
    let l:oldspr = &splitright
    set nosplitright
    35vnew
    setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
    call termopen('tree -CFa -I ".git"')
    let &splitright = oldspr
endfunction
