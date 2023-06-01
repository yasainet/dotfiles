set number
set ruler
" set showcmd
" set cursorline
set backspace=indent,eol,start
set virtualedit+=block
set wildmenu
set wildmode=list:full
set autoindent
set expandtab
set tabstop=2
set shiftwidth=2
set incsearch
set hlsearch
set showmatch
set smartcase
set smartindent
set smarttab
set clipboard+=unnamed

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

set laststatus=2

colorscheme nord
let g:lightline = {
      \ 'colorscheme': 'nord',
      \ }

call plug#begin()
" Copilot
Plug 'github/copilot.vim'

" git 操作
Plug 'tpope/vim-fugitive'

" ファイル検索
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" インデント可視化
Plug 'Yggdroot/indentLine'

" git の追加、削除、変更を表示
Plug 'airblade/vim-gitgutter'

" 補完系
Plug 'Shougo/ddc.vim'
Plug 'vim-denops/denops.vim'
 
" Install your UIs
Plug 'Shougo/ddc-ui-native'

" Install your sources
Plug 'Shougo/ddc-source-around'

" Install your filters
Plug 'Shougo/ddc-matcher_head'
Plug 'Shougo/ddc-sorter_rank'

" status line 
Plug 'itchyny/lightline.vim'

call plug#end()

" Customize global settings

" You must set the default ui.
" Note: native ui
" https://github.com/Shougo/ddc-ui-native
call ddc#custom#patch_global('ui', 'native')

" Use around source.
" https://github.com/Shougo/ddc-source-around
call ddc#custom#patch_global('sources', ['around'])

" Use matcher_head and sorter_rank.
" https://github.com/Shougo/ddc-matcher_head
" https://github.com/Shougo/ddc-sorter_rank
call ddc#custom#patch_global('sourceOptions', #{
      \ _: #{
      \   matchers: ['matcher_head'],
      \   sorters: ['sorter_rank']},
      \ })

" Change source options
call ddc#custom#patch_global('sourceOptions', #{
      \   around: #{ mark: 'A' },
      \ })
call ddc#custom#patch_global('sourceParams', #{
      \   around: #{ maxSize: 500 },
      \ })

" Customize settings on a filetype
call ddc#custom#patch_filetype(['c', 'cpp'], 'sources',
      \ ['around', 'clangd'])
call ddc#custom#patch_filetype(['c', 'cpp'], 'sourceOptions', #{
      \   clangd: #{ mark: 'C' },
      \ })
call ddc#custom#patch_filetype('markdown', 'sourceParams', #{
      \   around: #{ maxSize: 100 },
      \ })

" Mappings

" <TAB>: completion.
inoremap <silent><expr> <TAB>
\ pumvisible() ? '<C-n>' :
\ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
\ '<TAB>' : ddc#map#manual_complete()

" <S-TAB>: completion back.
inoremap <expr><S-TAB>  pumvisible() ? '<C-p>' : '<C-h>'

" Use ddc.
call ddc#enable()
