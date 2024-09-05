" 英語化
set langmenu=en_US
let $LANG = 'en_US'

" 基本設定
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

" キーマッピング
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

" vim-plug
call plug#begin('~/.vim/plugged')

if empty(glob('~/.vim/autoload/plug.vim'))
 silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
  \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
 autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" インデント可視化
Plug 'Yggdroot/indentLine'

" git の追加、削除、変更を表示
Plug 'airblade/vim-gitgutter'

" status line
Plug 'itchyny/lightline.vim'

" Nord
Plug 'arcticicestudio/nord-vim'

call plug#end()

" Nord
colorscheme nord

" ステータスライン
set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'nord',
      \ }
