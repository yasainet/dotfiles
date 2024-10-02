" Language
set langmenu=en_US
let $LANG = 'en_US'

" Settings
set number
set tabstop=2
set shiftwidth=2
set expandtab
set smartindent
set autoindent
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
set ruler
set backspace=indent,eol,start
set encoding=utf-8
set fileencodings=utf-8,ucs-bom,sjis,euc-jp,iso-2022-jp

" Keymap
inoremap <C-c> <ESC>
inoremap <C-b> <left>
inoremap <C-f> <right>
inoremap <C-p> <up>
inoremap <C-n> <down>
inoremap <C-h> <BS>
inoremap <C-d> <Del>
inoremap <C-e> <END>
inoremap <C-a> <HOME>

nnoremap j gj
nnoremap k gk
nnoremap <Down> gj
nnoremap <Up>   gk

nnoremap gj j
nnoremap gk k
nnoremap <F5> :<C-u>edit $MYVIMRC<Enter>
nnoremap <F6> :<C-u>source $MYVIMRC<Enter>

nnoremap j gj
nnoremap k gk
nnoremap gk k
nnoremap gj j

nnoremap U <c-r>

" Cursor
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" vim-plug
call plug#begin('~/.vim/plugged')

if empty(glob('~/.vim/autoload/plug.vim'))
 silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
  \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
 autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'itchyny/lightline.vim'
Plug 'nordtheme/vim'

call plug#end()

colorscheme nord

set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'nord',
      \ }
