
" function to insert a C/C++ header file guard
function! s:InsertGuard()
    let randlen = 7
    let randnum = system("xxd -c " . randlen * 2 . " -l " . randlen . " -p /dev/urandom")
    let randnum = strpart(randnum, 0, randlen * 2)
    let fname = expand("%")
    let lastslash = strridx(fname, "/")
    if lastslash >= 0
        let fname = strpart(fname, lastslash+1)
    endif
    let fname = substitute(fname, "[^a-zA-Z0-9]", "_", "g")
    let randid = toupper(fname . "_" . randnum)
    exec 'norm O#ifndef ' . randid
    exec 'norm o#define ' . randid
    exec 'norm o'
    let origin = getpos('.')
    exec '$norm o#endif /* ' . randid . ' */'
    norm o
    -norm O
    call setpos('.', origin)
    norm w
endfunction

command! -n=0 -bar InsertGuard :call s:InsertGuard()
