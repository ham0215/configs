" vi互換モードを廃止
set nocompatible

" ステータスバー2行
set laststatus=2
"カーソルラインを表示する
set cursorline

"set number
set expandtab     " タブ入力を複数の空白入力に置き換える
set tabstop=2     " 画面上でタブ文字が占める幅
set shiftwidth=2  " 自動インデントでずれる幅
set softtabstop=2 " 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set autoindent    " 改行時に前の行のインデントを継続する
set smartindent   " 改行時に入力された行の末尾に合わせて次の行のインデントを増減する

" collar
syntax on

" マウスの入力を受け付ける
" set mouse=a

" インサートモードから抜けると自動的にIMEをオフにする
"set iminsert=2

"""""""""""""""""" search
"インクリメンタルサーチを有効にする
set incsearch
" 大文字小文字を区別しない
set ignorecase
" 検索文字ハイライト
set hlsearch



""""""""""" insert mode
" backspace
set backspace=indent,eol,start

" insertモードから抜ける
inoremap <silent> jj <ESC>

" 挿入モードでのカーソル移動
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-n> <Left>
inoremap <C-l> <Right>

" カーソル後の文字削除
inoremap <silent> <C-d> <Del>

"""""""""""""" neobundle
" Note: Skip initialization for vim-tiny or vim-small.
if 0 | endif

if has('vim_starting')
  if &compatible
    set nocompatible               " Be iMproved
  endif

" Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
" Refer to |:NeoBundle-examples|.
" Note: You don't set neobundle setting in .gvimrc!

call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
