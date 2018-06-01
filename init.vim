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
  Plug 'vim-airline/vim-airline-themes'
  Plug 'airblade/vim-gitgutter'
  Plug 'junegunn/limelight.vim'
  Plug 'suan/vim-instant-markdown'
  Plug 'ap/vim-css-color'
  Plug 'kshenoy/vim-signature'

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
  " Plug 'honza/vim-snippets'

" Utility
  Plug 'kchmck/vim-coffee-script'
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
let g:airline_section_z = airline#section#create_right(['%p%% %l/%L %c'])

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
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
" set runtimepath+=~/.vim/UltiSnips
" let g:UltiSnipsSnippetDir= ['UltiSnips', '~/.vim/UltiSnips']
" let g:UltiSnipsSnippetDir= ['~/.vim/UltiSnips']
" let g:UltiSnipsSnippetDirectories=["UltiSnips"]

" fzf.vim
nnoremap <C-p> :FZF<CR>
nnoremap <C-l> :Lines<CR>

" vimwiki
let g:vimwiki_hl_cb_checked = 2

" vim-commentary
" add support for coffeescript
autocmd BufRead *.coffee setlocal filetype=coffee
autocmd FileType coffee setlocal commentstring=#\ %s

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

" Window
set scrolloff=10
execute "set colorcolumn=" . join(range(81,335), ',')
" set colorcolumn=90
" set cursorline " bad for performance

"--------------------
" Folding
"--------------------
set foldcolumn=2
augroup Auto_Save_Folds
  autocmd!
  autocmd bufwinleave *.* mkview!
  autocmd bufwinenter *.* silent loadview
augroup end

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
" Quick edit vimrc (init.vim)
nnoremap <leader>ev :split $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Move lines
nnoremap <S-j> :m .+1<CR>==
nnoremap <S-k> :m .-2<CR>==
" inoremap <S-j> <Esc>:m .+1<CR>==gi
" inoremap <S-k> <Esc>:m .-2<CR>==gi
vnoremap <S-j> :m '>+1<CR>gv=gv
vnoremap <S-k> :m '<-2<CR>gv=gv

" Copy line and paste below
nmap <A-d> yygccp

" Operators for text in parantheses
onoremap p i(
onoremap np :<c-u>normal! f(vi(<cr>

" Operator for text after '='
onoremap n= :<c-u>normal! f=wvg_<left><cr>

"--------------------
" Scripts
"--------------------
noremap <A-b> :call RunNode() <cr>
function! RunNode()
  exec "! node %"
endfunction

" show hyperlinks in help files
augroup showHyperlinksInHelp
  autocmd BufRead *.txt setlocal cole=0
augroup END

"--------------------
" Abbreviations
"--------------------
" use iab

