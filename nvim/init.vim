" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.local/share/nvim/plugged')

Plug 'sbdchd/neoformat'

" Color Theme "
Plug 'ayu-theme/ayu-vim'

Plug 'andreyorst/SimpleSnippets.vim'

" Markdown Preview "
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }

" ALE "
Plug 'dense-analysis/ale'
let b:ale_linters = ['mypy', 'flake8']

" Status Line "
Plug 'vim-airline/vim-airline'
let g:airline_powerline_fonts = 1

Plug 'scrooloose/nerdtree'

Plug 'Yggdroot/indentLine'

Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
let g:indentLine_setConceal = 2
" default ''.
" n for Normal mode
" v for Visual mode
" i for Insert mode
" c for Command line editing, for 'incsearch'
let g:indentLine_concealcursor = ""

" Intellisense "
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Linting "
Plug 'w0rp/ale'

Plug 'mattn/emmet-vim'

Plug 'airblade/vim-gitgutter'

" Multiple Cursors "
Plug 'terryma/vim-multiple-cursors/'

Plug 'alvan/vim-closetag'

Plug 'sheerun/vim-polyglot'

Plug 'Raimondi/delimitMate'

Plug 'christoomey/vim-tmux-navigator'

" Initialize plugin system "
call plug#end()

set termguicolors
let ayucolor="dark"
colorscheme ayu

set hidden

" autopep8 with neoformat config "
" https://github.com/sbdchd/neoformat#config-optional "
let g:neoformat_python_autopep8 = {
            \ 'exe': 'autopep8',
            \ 'args': ['-s 4', '-E'],
            \ 'replace': 1,
            \ 'stdin': 1,
            \ 'env': ["DEBUG=1"],
            \ 'valid_exit_codes': [0, 23],
            \ 'no_append': 1,
            \ }
let g:neoformat_enabled_python = ['autopep8']

" Show line number on the left side "
set number

" Show line numbers relative to the current line "
set relativenumber

" Activate mouse usage "
set mouse=a

" Show preview for commands "
set inccommand=split

" Set spacebar as leader key "
let mapleader="\<space>"

" Run current buffer with 'python' when F9 is pressed "
nnoremap <F9> <Esc>:w<CR>:! clear; python %<CR>

set conceallevel=2

" Spaces & Tabs {{{
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set shiftwidth=4    " number of spaces to use for autoindent
set expandtab       " tabs are space
set autoindent
set copyindent      " copy indent from the previous line
" }}} Spaces & Tabs

" Macros "

" Add ; to end of line with Space + Shift + A"
nnoremap <leader>; A;<esc>

" leader + q to exit "
nnoremap <leader>q :q<cr>

" leader + wq to save and exit "
nnoremap <leader>wq :wq<cr>

" leader + ww to save "
nnoremap <leader>ww :w<cr>

" F2 to Save "
nnoremap <f2> :w<cr>

" Open init.vim in split window with Space + ev"
nnoremap <leader>ev :vsplit ~/.config/nvim/init.vim<cr>

" Source init.vim with Space + sv"
nnoremap <leader>sv :source ~/.config/nvim/init.vim<cr> 

" Files with Ctrl + P "
nnoremap <c-p> :Files<cr>

" Remap Ctrl + W + Key to Ctrl + Key to move between windows "
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" ------ "

" Open nerdtree with C + O "
nnoremap <C-o> :NERDTreeToggle<CR>

" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

let g:SimpleSnippetsExpandOrJumpTrigger = "<Tab>"
let g:SimpleSnippetsJumpBackwardTrigger = "<S-Tab>"
let g:SimpleSnippetsJumpToLastTrigger = "<C-j>"
