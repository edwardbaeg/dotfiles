" Stop using these!
noremap h <NOP>
noremap l <NOP>

"--------------------
" Core
"--------------------
set termguicolors
set mouse=a
syntax enable
filetype plugin indent on
set encoding=utf8
set clipboard=unnamedplus "integrate with mac

"--------------------
" Plugins
"--------------------
call plug#begin('~/.vim/plugged')

  " Visual
  Plug 'sjl/badwolf'
  Plug 'vim-airline/vim-airline'
  Plug 'airblade/vim-gitgutter'
  Plug 'junegunn/limelight.vim'
  Plug 'suan/vim-instant-markdown'
  Plug 'plasticboy/vim-markdown'

  " Files
  Plug 'scrooloose/nerdtree'
  Plug '/usr/local/opt/fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'tpope/vim-fugitive'

  " Shortcuts
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-commentary'
  Plug 'jiangmiao/auto-pairs'
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'

  " Utility
  Plug 'w0rp/ale'
  Plug 'Shougo/deoplete.nvim' , { 'do' : ':UpdateRemotePlugins' }
  Plug 'metakirby5/codi.vim'
  Plug 'vimwiki/vimwiki'

  Plug 'ryanoasis/vim-devicons' " leave this last

call plug#end()

"--------------------
" Plugin Options
"--------------------
" airline
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1

" NERDTree
let g:NERDTreeWinSize=25
nnoremap <Leader>t :NERDTreeToggle<CR>
nnoremap <Leader>f :NERDTreeFind<CR>
let NERDTreeQuitOnOpen = 1

" Codi
let g:codi#width=30

" Deoplete
let g:deoplete#enable_at_startup=1
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" ultisnips
let g:UltiSnipsExpandTrigger="<C-j>"
let g:UltiSnipsJumpForwardTrigger="<C-j>"
let g:UltiSnipsJumpBackwardTrigger="<C-k>"
set runtimepath+=~/.vim/UltiSnips
let g:UltiSnipsSnippetDir= ['UltiSnips', '~/.vim/UltiSnips']
" let g:UltiSnipsSnippetDir= ['~/.vim/UltiSnips']
let g:UltiSnipsSnippetDirectories=["UltiSnips"]

" fzf.vim
nnoremap <C-p> :FZF<CR>
nnoremap <C-l> :Lines<CR>

"--------------------
" Visual
"--------------------
colorscheme badwolf

" Gutter
set ruler
set number
set relativenumber " bad for performamnce

" Status
set laststatus=2 " always show status line
set cmdheight=2
set showcmd

" Text
set showmatch
set matchtime=3
set list
set listchars=tab:‣\ ,trail:•,precedes:«,extends:»
" set listchars=tab:│·,trail:•,precedes:«,extends:»,eol:¬
" set listchars=tab:│·,trail:•,precedes:«,extends:»
highlight whitespace ctermbg=white
autocmd BufRead *.txt set cole=0 "show hyperlinks in help files

" Window
set scrolloff=10
execute "set colorcolumn=" . join(range(81,335), ',')
" set colorcolumn=90
" set cursorline " bad for performance

"--------------------
" Folding
"--------------------
set foldcolumn=2
autocmd BufWinLeave *.* mkview "save folds
autocmd BufWinEnter *.* silent loadview "load folds

"--------------------
" Searching and Highlighting
"--------------------
set path+=** " recursive fuzzy search with :find
set incsearch " search realtime
set hlsearch
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
set ignorecase
set smartcase

" Center searches
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

"--------------------
" Tabbing
"--------------------
set tabstop=2
set shiftwidth=2
set smarttab
set expandtab

"--------------------
" Mappings
"--------------------
inoremap jk <esc>
nnoremap <leader>ev :split $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" move lines
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

"--------------------
" Scripts
"--------------------
noremap <A-b> :call RunNode() <cr> "build with node
function! RunNode()
  exec "! node %"
endfunction

"--------------------
" Abbreviations
"--------------------
iab @@ edwardbaeg9@gmail.com

