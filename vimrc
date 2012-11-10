set nocp                " We are not compatible with old vi

filetype off            " This fixes potential issues with pathogen and loading new filetypes.

" Use pathogen to easily modify the runtime path to include all
" plugins under the ~/.vim/bundle directory
call pathogen#infect()  " Infect our paths and load pathogen
call pathogen#helptags() " Pathogen should create helptags for all of the new bundles loaded

runtime macros/matchit.vim  " Cycle through if statements using %

filetype indent plugin on

set autoindent          " uses the indent from the previous line.
set expandtab           " use spaces, not tabs
set tabstop=4           " a tab is four spaces
set shiftwidth=4        " an autoindent (with <<) is four spaces
set softtabstop=4       "
set ruler               " show the cursor position all the time
set scrolloff=10        " have some context around the current line always on screen
"set hidden
set number              " line numbers (number|nonumber)
set wildignore=*.swp,*.bak,*.pyc,*.class
set showcmd             " display incomplete commands
set history=200         " remember more Ex commands

" Set the max height for the popup menu with suggestions
set pumheight=15

" Disable the scratch/preview window. Not sure how it works, and it annoyed
" me.
set completeopt=menu,menuone,longest

set pastetoggle=<F2>    " Turn on/off paste insertion

set background=dark

if has("gui_running")
    set guioptions=egmt
    colorscheme earendel

    if has("autocmd")
        au FocusLost * :wa          " Write all upon losing focus
        au TabEnter * stopinsert    " When changing tabs, exit insert mode
    endif

    " Map function keys to their terminal equivalent

    " Maps to InsertGuard
    map <F15> [28~
    imap <F15> [28~

    " Maps to InserGuard (laptops don't have F13 - F19)
    map <F12> [28~
    imap <F12> [28~

    " Maps to killing whitespace
    map <F16> [29~
    imap <F16> [29~

    " Maps to killing whitespace
    map <F11> [29~
    imap <F11> [29~
endif

" Sets up wrapping. Thanks @geoffgarside, calling functions from auto commands
" should have come naturally, but I never really thought about it!
function s:setupWrapping()
    set wrap
    set wrapmargin=2
    " The above two don't matter when the following is set ... but leaving it
    " for those times that I want to disable tw without disabling soft-wrap.
    set textwidth=79
endfunction

" If we get called without any arguments, pop open the SessionList. If we get
" opened with an argument we call FileExplorer, which lets NERDTree do its
" thing, if it is a directory it takes over and shows it, if it is a new file
" it does nothing. Bloody fantastic!
function s:NERDTreeOrSession()
    if !argc()
        silent! SessionList
    else
        silent! FileExplorer
    endif
endfunction

if has("autocmd")
    " Make sure all markdown files have the correct filetype set and setup wrapping
    au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn,txt} setf markdown | call s:setupWrapping()

    " Treat JSON files like JavaScript
    au BufNewFile,BufRead *.json set ft=javascript

    " Start with NERDTree or Session management
    au vimenter * call s:NERDTreeOrSession()
endif

syntax on               " I like syntax highlighting, you like syntax highlight, so lets turn it on.

" Lets use Command-T
nmap ,m :CommandT<CR>

" Open new NERD Tree window
nmap ,n :NERDTreeClose<CR>:NERDTreeToggle<CR>
"nmap ,m :NERDTreeClose<CR>:NERDTreeFind<CR>

" Set variables for Command T
let g:CommandTMaxHeight=10
let g:CommandTMinHeight=4

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

" Inserts a C/C++ IFNDEF/DEFINE/ENDIF guard around header code for multiple
" inclusions.
noremap <silent> [28~ :InsertGuard<CR>
inoremap <silent> [28~ :InsertGuard<CR>

" Kills empty whitespace. Makes git extremely happy.
noremap <silent> [29~ :%s/\s\+$//e<CR>

" Enable supertab context completion
let g:SuperTabDefaultCompletionType = "context"

" Enable some features of clang_complete
" we disable auto-complete because it isn't always necessary and supertab will
" take care of it.
let g:clang_complete_auto = 0
let g:clang_auto_select = 1
let g:clang_complete_copen = 1
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
