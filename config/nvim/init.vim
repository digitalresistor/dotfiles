set nocp " We are not compatible with old vi

let g:loaded_python_provider = 0
let g:python3_host_prog = expand("~/.ve/neovim/bin/python")

" turn off arbitrary code execution
set modelines=0
set nomodeline

" This has to come before we load the plugins
let g:ale_disable_lsp = 1

" Markdown specific settings
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_toml_frontmatter = 1

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin(stdpath('config') . '/plugged')

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
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
Plug 'preservim/nerdtree', { 'on':  ['NERDTreeClose', 'NERDTreeToggle'] }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-git'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sleuth'
Plug 'jeffkreeftmeijer/vim-numbertoggle'

" Language specific plugins
Plug 'sheerun/vim-polyglot'
Plug 'stephpy/vim-yaml', { 'for': ['yaml'] }
Plug 'godlygeek/tabular', { 'for': ['markdown'] }

" Initialize plugin system
call plug#end()

lua require('configs')

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

" I like syntax highlighting, you like syntax highlight, so lets turn it on.
syntax on

" Lets use FZF
nmap <leader>m :FZF<CR>
nmap <leader>n :GFiles<CR>

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
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
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

" Show available code actions for line
nmap <silent> ga <Plug>(coc-codeaction-line)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

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
nmap <leader>b :NERDTreeClose<CR>:NERDTreeToggle<CR>
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

let g:coc_filetype_map = {
  \ 'yaml.ansible': 'ansible',
  \ }

lua << EOF
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = {
    "bash",
    "c",
    "diff",
    "gitcommit",
    "go",
    "hcl",
    "html",
    "javascript",
    "lua",
    "markdown",
    "python",
    "rst",
    "rust",
    "toml",
    "vim",
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = { },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- Disable tree-sitter when the file is too large
    -- disable = function(lang, buf)
    --     local max_filesize = 100 * 1024 -- 100 KB
    --     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    --     if ok and stats and stats.size > max_filesize then
    --         return true
    --     end
    -- end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF

if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
