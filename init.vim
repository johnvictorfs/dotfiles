" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged') 

" gruvbox Color Theme "
Plug 'morhetz/gruvbox'

Plug 'andreyorst/SimpleSnippets.vim'

" Status Line "
Plug 'vim-airline/vim-airline'
let g:airline_powerline_fonts = 1

Plug 'scrooloose/nerdtree'

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1
Plug 'Yggdroot/indentLine'

Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'

" Intellisense "
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}

" Linting "
Plug 'w0rp/ale'

Plug 'mattn/emmet-vim'

Plug 'airblade/vim-gitgutter'

" Multiple Cursors "
Plug 'terryma/vim-multiple-cursors/'

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1

Plug 'alvan/vim-closetag'

Plug 'sheerun/vim-polyglot'

Plug 'Raimondi/delimitMate'

Plug 'christoomey/vim-tmux-navigator'

" Initialize plugin system "
call plug#end()

colorscheme gruvbox
set background=dark

set hidden

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

" Open init.vim in split window with Space + ev"
nnoremap <leader>ev :vsplit ~/.config/nvim/init.vim<cr>

" Source init.vim with Space + sv"
nnoremap <leader>sv :source ~/.config/nvim/init.vim<cr> 

" Files with Ctrl + P "
nnoremap <c-p> :Files<cr>

" Remap Ctrl + W + Key to Ctrl + Key to move between windows "
" nnoremap <C-h> <C-w>h
" nnoremap <C-j> <C-w>j
" nnoremap <C-k> <C-w>k
" nnoremap <C-l> <C-w>l
" ------ "

" Open nerdtree with C + O "
nnoremap <C-o> :NERDTreeToggle<CR>

" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

let g:SimpleSnippetsExpandOrJumpTrigger = "<Tab>"
let g:SimpleSnippetsJumpBackwardTrigger = "<S-Tab>"
let g:SimpleSnippetsJumpToLastTrigger = "<C-j>"
