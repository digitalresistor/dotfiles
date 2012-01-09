set nocp

filetype off

" Use pathogen to easily modify the runtime path to include all
" plugins under the ~/.vim/bundle directory
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

filetype indent plugin on

set autoindent
set smartindent
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set ruler
set scrolloff=10
"set hidden
set number
set wildignore=*.swp,*.bak,*.pyc,*.class
set title

" Set the max height for the popup menu with suggestions
set pumheight=15

" Disable the scratch/preview window. Not sure how it works, and it annoyed
" me.
set completeopt=menu,menuone,longest

set pastetoggle=<F2>

set background=dark

if has("gui_running")
    set guioptions=egmt
    colorscheme earendel
    au FocusLost * :wa
    au BufAdd,BufNewFile * :set noinsertmode
    " Map function keys to their terminal equivalent
    map <F15> [28~
    imap <F15> [28~
    map <F12> [28~
    imap <F12> [28~
    map <F16> [29~
    imap <F16> [29~
endif

syntax on

nmap ,n :NERDTreeClose<CR>:NERDTreeToggle<CR>
nmap ,m :NERDTreeClose<CR>:NERDTreeFind<CR>
nmap ,N :NERDTreeClose<CR>

nmap ,l :BufExplorer<CR>

" Store the bookmarks file
let NERDTreeBookmarksFile=expand("~/.vim/NERDTreeBookmarks")

" Don't display these kinds of files
let NERDTreeIgnore=[ '\.pyc$', '\.pyo$', '\.py\$class$', '\.obj$',
            \ '\.o$', '\.so$', '\.egg$', '^\.git$', '\.os$', '\.dylib$', '\.a$' ]

let NERDTreeShowBookmarks=1       " Show the bookmarks table on startup
let NERDTreeShowFiles=1           " Show hidden files, too
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=1          " Quit on opening files from the tree
let NERDTreeHighlightCursorline=1 " Highlight the selected entry in the tree

map ,t <Plug>TaskList

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

noremap <silent> [28~ :call <SID>InsertGuard()<CR>
inoremap <silent> [28~ <Esc>:call <SID>InsertGuard()<CR>

noremap <silent> [29~ :%s/\s\+$//e<CR>

" Enable supertab context completion
let g:SuperTabDefaultCompletionType = "context"

" Enable some features of clang_complete
" we disable auto-complete because it isn't always necessary and supertab will
" take care of it.
let g:clang_complete_auto = 0
let g:clang_auto_select = 1
let g:clang_complete_copen = 0
"let g:clang_library_path = "/Developer/usr/clang-ide/lib/"
"let g:clang_use_library = 1

" Setting up some defaults for Snipmate, these should be overriden in
" .vimrc.local

let g:snips_author = 'Charlie Root'
let g:snips_email  = 'root@localhost'
let g:snips_copyright = 'Example Corp.'

if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local"
endif
