set nocp " We are not compatible with old vi

let g:loaded_python_provider = 0
let g:python3_host_prog = expand("~/.ve/neovim/bin/python")

" turn off arbitrary code execution
set modelines=0
set nomodeline

" This has to come before we load the plugins
let g:ale_disable_lsp = 1

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin(stdpath('config') . '/plugged')

Plug 'Raimondi/delimitMate'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'andymass/vim-matchup'
Plug 'chriskempson/base16-vim'
Plug 'ciaranm/securemodelines'
Plug 'dense-analysis/ale'
Plug 'editorconfig/editorconfig-vim'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-git'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'jeffkreeftmeijer/vim-numbertoggle'

" Language specific plugins
Plug 'cespare/vim-toml'
Plug 'gabrielelana/vim-markdown'
Plug 'hashivim/vim-terraform', {'for': 'tf'}
Plug 'othree/html5.vim'
Plug 'rust-lang/rust.vim'
Plug 'stephpy/vim-yaml'

" Initialize plugin system
call plug#end()

filetype indent plugin on

set autoindent          " uses the indent from the previous line
set expandtab		    " use spaces, not tabs (by default)
set tabstop=4	    	" a tab is four spaces
set shiftwidth=4    	" an autoindent (with >>) is four spaces
set softtabstop=4
set ruler 		        " show the cursor position all the time
set scrolloff=10    	" have some context around the current line always on the screen
" set hidden
set relativenumber      " Relative line numbers
set number              " Also show current absolute line
set wildignore=*.swp,*.bak,*.pyc,*.class
set showcmd	        	" display incomplete commands
set history=200	    	" remember more Ex commands
set cmdheight=2         " Set heigth of commands
set noswapfile          " Disable .swp files, we save when a window loses focus and it leaves files all over the filesystem
set signcolumn=yes      " Always draw sign column. Prevent buffer moving when adding/deleting sign.
set colorcolumn=88      " and give me a colored column
set mouse=a             " Enable mouse usage (all modes) in terminals

" set the max height for the popup menu with suggestions
set pumheight=15

" Disable the scratch/preview window
set completeopt=menu,menuone,longest

set inccommand=nosplit
set background=dark
colorscheme earendel

if has("gui_running")
    set guioptions=egmt
endif

au FocusLost *: wa		" Write all upon losing focus
au TabEnter * stopinsert 	" When changing tabs, exit insert mode

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

" Set the tab name to the full path
set guitablabel=%M%f

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

" Make sure all markdown files have the correct filetype set and setup wrapping
au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn,txt} setf markdown | call s:setupWrapping()

" Mako files need to be treated correctly ...
au BufRead,BufNewFile *.mako setf html.mako

" Treat JSON files like JavaScript
au BufNewFile,BufRead *.json setf javascript

" Treat wscript (waf) files as Python
au BufNewFile,Bufread wscript setf python

" Follow Rust code style rules
au Filetype rust set colorcolumn=100

" Start with NERDTree or Session management
au vimenter * call s:NERDTreeOrSession()

syntax on               " I like syntax highlighting, you like syntax highlight, so lets turn it on.

" Lets use FZF
nmap ,m :FZF<CR>

" Configure lightline
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \   'cocstatus': 'coc#status'
      \ },
      \ }
function! LightlineFilename()
  return expand('%:t') !=# '' ? @% : '[No Name]'
endfunction

" Use autocommand to force lightline updates
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

" Configure CoC
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Open new NERD Tree window
nmap ,n :NERDTreeClose<CR>:NERDTreeToggle<CR>
"nmap ,m :NERDTreeClose<CR>:NERDTreeFind<CR>

" Set variables for Command T
let g:CommandTMaxHeight=15
let g:CommandTMinHeight=4
let g:CommandTWildIgnore=&wildignore .",*/node_modules,*/build,*/venv,*/.git/*"
let g:CommandTScanDotDirectories=1

" Don't display these kinds of files
let NERDTreeIgnore=[ '\.pyc$', '\.pyo$', '\.py\$class$', '\.obj$',
            \ '\.o$', '\.so$', '\.egg$', '^\.git$', '\.os$', '\.dylib$', '\.a$' ]

let NERDTreeShowBookmarks=1       " Show the bookmarks table on startup
let NERDTreeShowFiles=1           " Show hidden files, too
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=1          " Quit on opening files from the tree
let NERDTreeHighlightCursorline=1 " Highlight the selected entry in the tree

" Inserts a C/C++ IFNDEF/DEFINE/ENDIF guard around header code for multiple
" inclusions.
noremap <silent> [28~ :InsertGuard<CR>
inoremap <silent> [28~ :InsertGuard<CR>

" Kills empty whitespace. Makes git extremely happy.
noremap <silent> [29~ :%s/\s\+$//e<CR>

" This was bothering the fuck out of me ...
command! Q q " Bind :Q to :q
command! W w " Bind :W to :w
command! Wq wq " Bind :Wq to :wq

" UltiSnips set up

let g:UltiSnipsExpandTrigger="<C-j>"
let g:UltiSnipsJumpForwardTrigger="<C-j>"
let g:UltiSnipsJumpBackwardTrigger="<C-k>"

let g:UltiSnipsSnippetDirectories=["UltiSnips"]
let g:UltiSnipsDontReverseSearchPath="1"

" Setting up some defaults for Snipmate, these should be overriden in
" .vimrc.local

let g:snips_author = 'Charlie Root'
let g:snips_email  = 'root@localhost'
let g:snips_copyright = 'Example Corp.'

let g:ale_sign_column_always = 1
let g:ale_fixers = {
  \   'python': [
  \       'remove_trailing_lines',
  \       'trim_whitespace',
  \       'add_blank_lines_for_python_control_statements',
  \       'isort',
  \       'black',
  \   ],
  \   'rust': [
  \       'remove_trailing_lines',
  \       'trim_whitespace',
  \       'rustfmt',
  \   ],
  \   'cpp': [
  \       'trim_whitespace',
  \       'remove_trailing_lines',
  \       'clang-format',
  \   ],
  \   'terraform': [
  \       'remove_trailing_lines',
  \       'trim_whitespace',
  \       'terraform',
  \   ]
  \}
let g:ale_c_clangformat_options = '--style=webkit --sort-includes'

if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
