" vi互換モードを廃止
set nocompatible

" ステータスバー2行
set laststatus=2
"カーソルラインを表示する
"set cursorline

"set number
set expandtab     " タブ入力を複数の空白入力に置き換える
set tabstop=2     " 画面上でタブ文字が占める幅
set shiftwidth=2  " 自動インデントでずれる幅
set softtabstop=2 " 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set autoindent    " 改行時に前の行のインデントを継続する
set smartindent   " 改行時に入力された行の末尾に合わせて次の行のインデントを増減する
"set paste         " コピペ時のずれを解消

" statusline
" set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
" set statusline=%F%m%r%h%w\%=[POS=%04l,%04v][%p%%]\ [LEN=%L]\ [ENC=%{&fileencoding}]\ %{fugitive#statusline()}

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

" <Leader>を,に変更
:let mapleader = ","

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
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
"NeoBundle 'ujihisa/unite-colorscheme'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'cohama/agit.vim'
NeoBundle 'airblade/vim-gitgutter'
"NeoBundle 'scrooloose/nerdtree'
NeoBundle 'Shougo/vimfiler.vim'
NeoBundle 'tpope/vim-rails'

NeoBundle 'basyura/unite-rails'
map <silent> <leader>c :Unite rails/controller<CR>
map <silent> <leader>v :Unite rails/view<CR>
map <silent> <leader>m :Unite rails/model<CR>

" インデントに色を付けて見やすくする
"NeoBundle 'nathanaelkane/vim-indent-guides'
" vimを立ち上げたときに、自動的にvim-indent-guidesをオンにする
"let g:indent_guides_enable_on_vim_startup = 1

" カラースキーム
"NeoBundle 'altercation/vim-colors-solarized'
"NeoBundle 'croaker/mustang-vim'
"NeoBundle 'jeffreyiacono/vim-colors-wombat'
"NeoBundle 'nanotech/jellybeans.vim'
"NeoBundle 'vim-scripts/Lucius'
"NeoBundle 'vim-scripts/Zenburn'
"NeoBundle 'mrkn/mrkn256.vim'
"NeoBundle 'jpo/vim-railscasts-theme'
"NeoBundle 'therubymug/vim-pyte'
NeoBundle 'tomasr/molokai'

" slim colors
NeoBundle 'slim-template/vim-slim'

" statusline
NeoBundle 'itchyny/lightline.vim'

" taglist
NeoBundle 'vim-scripts/taglist.vim'
let Tlist_Show_One_File = 1
let Tlist_Use_Right_Window = 1
let Tlist_Exit_OnlyWindow = 1
map <silent> <leader>l :TlistToggle<CR>

" tagsジャンプの時に複数ある時は一覧表示
nnoremap <C-]> g<C-]>

""""""""""""""""""""""""""""""
" Unit.vimの設定
""""""""""""""""""""""""""""""
" 入力モードで開始する
let g:unite_enable_start_insert=1
" history/yank有効化
let g:unite_source_history_yank_enable = 1

" バッファ一覧
noremap <C-P> :Unite buffer<CR>
" ファイル一覧
"noremap <C-N> :Unite -buffer-name=files file<CR>
noremap <C-N> :UniteWithBufferDir -buffer-name=files file<CR>
" 最近使ったファイルの一覧
noremap <C-Z> :Unite file_mru<CR>
" sourcesを「今開いているファイルのディレクトリ」とする
noremap :uff :<C-u>UniteWithBufferDir file -buffer-name=file<CR>
" history/yank
nnoremap <silent> <C-y> :Unite history/yank<CR>
" inoremap <silent> <C-s> <Esc>:Unite history/yank<CR>
" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>

""""""""""""""""""""""""""""""
" VimFilerの設定
""""""""""""""""""""""""""""""
nnoremap <C-D> :<C-u>VimFiler -split -simple -winwidth=35 -no-quit<CR>
" nnoremap <C-D> :<C-u>VimFilerBufferDir -split -simple -winwidth=35 -no-quit<CR>


""""""""""""""""""""""""""""""
" vim-gitgutter
""""""""""""""""""""""""""""""
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '->'
let g:gitgutter_sign_removed = '-'

""""""""""""""""""""""""""""""
" lightline.vim
""""""""""""""""""""""""""""""
let g:lightline = {
        \ 'colorscheme': 'wombat',
        \ 'mode_map': {'c': 'NORMAL'},
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ], ['dir'], [ 'fugitive', 'gitgutter', 'filename' ], ['readonly']],
        \   'right': [ ['rows'], ['lineinfo', 'syntastic'], ['percent'], ['fileencoding'], ['filetype'], ['fileformat']]
        \ },
        \ 'inactive': {
        \   'left': [ ['dir'], [ 'fugitive', 'gitgutter', 'filename' ], ['readonly']],
        \   'right': [ ['rows'], ['lineinfo', 'syntastic'], ['percent'], ['fileencoding'],
        \              ['filetype'], ['fileformat'], ['charcode']]
        \ },
        \ 'component_function': {
        \   'modified': 'LightLineModified',
        \   'readonly': 'LightLineReadonly',
        \   'fugitive': 'LightLineFugitive',
        \   'filename': 'LightLineFilename',
        \   'fileformat': 'LightLineFileformat',
        \   'filetype': 'LightLineFiletype',
        \   'fileencoding': 'LightLineFileencoding',
        \   'mode': 'LightLineMode',
        \   'gitgutter': 'LightLineGitGutter',
        \   'charcode': 'LightLineCharCode',
        \ }
        \ }

let g:lightline.component = {}
" file path
let g:lightline.component.dir = '%.35(%{expand("%:h:s?\\S$?\\0/?")}%)'
" Line
let g:lightline.component.rows = '%L'
" cd
"let g:lightline.component.cd = '%.35(%{fnamemodify(getcwd(), ":~")}%)'

function! LightLineModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightLineReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'x' : ''
endfunction

function! LightLineFilename()
  return ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
          \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
          \  &ft == 'unite' ? unite#get_status_string() :
          \  &ft == 'vimshell' ? vimshell#get_status_string() :
          \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
          \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

function! LightLineFugitive()
  try
    if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
      return fugitive#head()
    endif
  catch
  endtry
  return ''
endfunction

function! LightLineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightLineFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! LightLineFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! LightLineMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! LightLineGitGutter()
  if ! exists('*GitGutterGetHunkSummary')
        \ || ! get(g:, 'gitgutter_enabled', 0)
        \ || winwidth('.') <= 90
    return ''
  endif
  let symbols = [
        \ g:gitgutter_sign_added . ' ',
        \ g:gitgutter_sign_modified . ' ',
        \ g:gitgutter_sign_removed . ' '
        \ ]
  let hunks = GitGutterGetHunkSummary()
  let ret = []
  for i in [0, 1, 2]
    if hunks[i] > 0
      call add(ret, symbols[i] . hunks[i])
    endif
  endfor
  return join(ret, ' ')
endfunction

"""""""""""""""""
" Neobundle end
"""""""""""""""""
call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
"""""""""""""""""

" カラースキーム
colorscheme molokai
