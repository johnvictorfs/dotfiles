" vim:fileencoding=utf-8:foldmethod=marker

" Plugin Installs {{{
call plug#begin('~/.local/share/nvim/plugged')

Plug 'sbdchd/neoformat'

" Colors besides hex/rgb codes "
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }

" Latex preview " 
Plug 'lervag/vimtex'

" Color Theme "
Plug 'ayu-theme/ayu-vim'

Plug 'andreyorst/SimpleSnippets.vim'

" Markdown Preview "
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }

" ALE "
Plug 'dense-analysis/ale'
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'typescript': ['eslint'],
\   'python': ['mypy', 'flake8']
\}
let g:ale_fixers = {
\   'typescript': ['eslint'],
\   'javascript': ['eslint'],
\   'python': ['autopep8']
\}
let g:ale_sign_error = ''
let g:ale_sign_warning = ''
let g:ale_fix_on_save = 1

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

let g:vimtex_fold_enabled = 1
let g:vimtex_fold_types = {
      \ 'markers' : {'enabled': 0},
      \ 'sections' : {'parse_levels': 1},
      \}
let g:vimtex_format_enabled = 1
let g:vimtex_view_method = 'zathura'
let g:vimtex_view_automatic = 0
let g:vimtex_view_forward_search_on_start = 0
let g:vimtex_toc_config = {
      \ 'split_pos' : 'full',
      \ 'mode' : 2,
      \ 'fold_enable' : 1,
      \ 'hotkeys_enabled' : 1,
      \ 'hotkeys_leader' : '',
      \ 'refresh_always' : 0,
      \}
let g:vimtex_quickfix_open_on_warning = 0
let g:vimtex_quickfix_autoclose_after_keystrokes = 3
let g:vimtex_imaps_enabled = 0
let g:vimtex_complete_img_use_tail = 1
let g:vimtex_complete_bib = {
      \ 'simple' : 1,
      \ 'menu_fmt' : '@year, @author_short, @title',
      \}
let g:vimtex_echo_verbose_input = 0

if has('nvim')
  let g:vimtex_compiler_progname = 'nvr'
endif

" Intellisense "
Plug 'neoclide/coc.nvim', {'branch': 'release'}

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

" }}}

" Theme and Visual Settings {{{
set termguicolors
let ayucolor="dark"
colorscheme ayu

" Hexokinase color hints "
let g:Hexokinase_highlighters = [ 'virtual' ]

set hidden
set conceallevel=2
" }}}

" Python Settings {{{

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
" }}}

" Editor Settings {{{

" Show line number on the left side "
set number

" Show line numbers relative to the current line "
set relativenumber

" Activate mouse usage "
set mouse=a

" Show preview for commands "
set inccommand=split

" }}}

" Spaces & Tabs {{{
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set shiftwidth=4    " number of spaces to use for autoindent
set expandtab       " tabs are space
set autoindent
set copyindent      " copy indent from the previous line
" }}} Spaces & Tabs

" Keybindings {{{

" Set spacebar as leader  and localleader key "
let mapleader="\<space>"

autocmd FileType tex nnoremap <leader>ç :VimtexCompile<cr>

" Copy and paste from/to clipboard with Ctrl + C and Ctrl + V
vnoremap <C-c> "+y
map <C-v> "+p

" Run current buffer with 'python' when F9 is pressed "
nnoremap <F9> <Esc>:w<CR>:! clear; python %<CR>

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

" }}}

" Plugin key-mappings {{{
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" Open nerdtree with C + O "
nnoremap <C-o> :NERDTreeToggle<CR>

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

let g:SimpleSnippetsExpandOrJumpTrigger = "<Tab>"
let g:SimpleSnippetsJumpBackwardTrigger = "<S-Tab>"
let g:SimpleSnippetsJumpToLastTrigger = "<C-j>"

" }}}

