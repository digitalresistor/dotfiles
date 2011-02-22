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
set shiftwidth=4
set softtabstop=4
set ruler
set scrolloff=10
"set hidden
set number
set wildignore=*.swp,*.bak,*.pyc,*.class
set title

set pastetoggle=<F2>

set background=dark

if has("gui_running")
    set guioptions=egmt
    colorscheme earendel
    au FocusLost * :wa
    au BufAdd,BufNewFile * :set noinsertmode
    imap <F14> [26~
    imap <F13> [25~
    map <F15> [28~
    imap <F15> [28~
endif

syntax on

nmap ,n :NERDTreeClose<CR>:NERDTreeToggle<CR>
nmap ,m :NERDTreeClose<CR>:NERDTreeFind<CR>
nmap ,N :NERDTreeClose<CR>

" Store the bookmarks file
let NERDTreeBookmarksFile=expand("$HOME/.vim/NERDTreeBookmarks")

" Don't display these kinds of files
let NERDTreeIgnore=[ '\.pyc$', '\.pyo$', '\.py\$class$', '\.obj$',
            \ '\.o$', '\.so$', '\.egg$', '^\.git$' ]

let NERDTreeShowBookmarks=1       " Show the bookmarks table on startup
let NERDTreeShowFiles=1           " Show hidden files, too
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=1          " Quit on opening files from the tree
let NERDTreeHighlightCursorline=1 " Highlight the selected entry in the tree

inoremap <silent> [26~ <Esc>:set paste<CR>:insert<CR>/** $Id$ */<CR>/**<CR> * @file <C-R>=expand("%:t")<CR><CR> * @author Bert JW Regeer (bert.regeer@ip3corp.com)<CR> * @author iP3<CR> * @date <C-R>=strftime("%Y-%m-%d")<CR><CR> */<CR>/****************************************************************************<CR> ** Copyright (C) 2009-2010 ip3 Corporation. All rights reserved.          **<CR> ****************************************************************************/<CR><CR>.<CR>:set nopaste<CR>i
inoremap <silent> [25~ /**<CR>@brief<CR>@details<CR>@param<CR>@returns<CR>/<CR>

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
