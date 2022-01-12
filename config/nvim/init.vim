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
Plug 'andymass/vim-matchup', {'tag': 'v0.6.0'}
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

let mapleader=","

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

syntax on               " I like syntax highlighting, you like syntax highlight, so lets turn it on.

" Lets use FZF
nmap <leader>m :FZF<CR>

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

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

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
