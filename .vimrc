set encoding=utf-8
language en_US.UTF-8

set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%,space:_

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

nnoremap <C-g> 1<C-g>

noremap <C-r> :%s/
cnoremap <C-r> :%s/
inoremap <C-r> <ESC>:%s/

set pastetoggle=<F10>

autocmd FileType html setlocal includeexpr=substitute(v:fname,'^\\/','','') | setlocal path+=;/
augroup vimrcEx
  au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
  \ exe "normal g`\"" | endif
augroup END

"------ Format ------"
" 対応する括弧やブレースを表示する
set showmatch
" 改行時に入力された行の末尾に合わせて次の行のインデントを増減する
set smartindent
" 改行時に前の行のインデントを継続する
set autoindent
" 行頭の余白内で Tab を打ち込むと、'shiftwidth' の数だけインデントする
set smarttab
" ファイル内の <Tab> が対応する空白の数
set tabstop=2
" シフト移動幅
set shiftwidth=2
" Tab入力時半角スペースにする
set expandtab
" カーソルが何行目の何列目に置かれているかを表示する
set ruler
" 行番号の表示する
set number
" 常にカーソル行を真ん中に
set scrolloff=999
" カレント行をハイライト
set cursorline
" 入力中のコマンドを表示する
set showcmd
" Bs で消せるものを指定する
set backspace=start,eol,indent
" 矩形選択を空白も選択できる
set virtualedit+=block
" swap ファイルを生成しない
set noswapfile
" 補完表示
set wildmenu
" 補完候補を一覧で表示
set wildmode=list:full
" ノーマルモード時にペーストモードを解除する
autocmd InsertLeave * set nopaste
" clipboard+ の時に yank でクリップボードにコピー
set clipboard=unnamed,autoselect
" ターミナル接続を高速にする
set ttyfast
" マクロを実行中は描画を中段する
set lazyredraw
" オンのときは、ウィンドウの幅より長い行は折り返され、次の行に続けて表示される
set wrap
function! s:remove_dust()
    let cursor = getpos(".")
    " 保存時に行末の空白を除去する
    %s/\s\+$//ge
    " 保存時にtabを2スペースに変換する
    %s/\t/  /ge
    call setpos(".", cursor)
    unlet cursor
endfunction
autocmd BufWritePre * call <SID>remove_dust()


"------ Search ------"
" インクリメンタルサーチ
set incsearch
" 検索時に大文字小文字を区別しない
set ignorecase
" 小文字で検索すると大文字と小文字を無視, 大文字が入ると ignorecase が無効になる
set smartcase
" 検索がファイル末尾まで進んだら、ファイル先頭から再び検索する
set wrapscan
" 検索結果のハイライト
set hlsearch
" EscEsc でハイライトを消す
nmap <Esc><Esc> :nohlsearch<CR><Esc>
au BufRead,BufNewFile *.md set filetype=markdown

"--- Vundle ---"
set nocompatible
filetype off
set rtp+=~/.vim/vundle/
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'scrooloose/syntastic'

Plugin 'cocopon/iceberg.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
set laststatus=2
set showtabline=2
set t_Co=256
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#whitespace#mixed_indent_algo = 1
let g:airline_theme = 'iceberg'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.maxlinenr = '㏑'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'Ξ'

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.maxlinenr = ''

Plugin 'edkolev/tmuxline.vim'
let g:airline#extensions#tmuxline#enabled = 0
let g:tmuxline_theme = 'iceberg'
let g:tmuxline_preset = 'full'
let g:tmuxline_powerline_separators = 0

Plugin 'scrooloose/nerdtree'
nmap <silent> <C-e> :NERDTreeToggle<CR>
let g:NERDTreeShowHidden=1



call vundle#end()
filetype plugin indent on

"--- ColorScheme ---"
colorscheme iceberg
syntax on
let g:enable_bold_font = 1

