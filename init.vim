" ~/.config/nvim/init.vim

" Stop using these!
" noremap h <NOP>
" noremap l <NOP>

"--------------------
" Core
"--------------------
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum" " enable italcs
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum" " enable italics
set termguicolors
set mouse=a
syntax enable
filetype plugin indent on
set encoding=utf8
set clipboard=unnamedplus " integrate with mac
set updatetime=500
set undofile " set persistent undo
set undodir=$HOME/.vim/undo
set undolevels=1000
set undoreload=10000


"--------------------
" Plugins
"--------------------
call plug#begin('~/.vim/plugged')

" Visual
"----------
  Plug 'airblade/vim-gitgutter'
  Plug 'ap/vim-css-color'
  Plug 'junegunn/goyo.vim'
  Plug 'junegunn/limelight.vim'
  Plug 'junegunn/vim-peekaboo'
  Plug 'kshenoy/vim-signature'
  Plug 'machakann/vim-highlightedyank'
  Plug 'markonm/traces.vim'
  Plug 'rrethy/vim-illuminate'
  Plug 'sjl/badwolf'
  Plug 'unblevable/quick-scope'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'psliwka/vim-smoothie'
  " Plug 'yuttie/comfortable-motion.vim'
  " Plug 'dodie/vim-fibo-indent'

" Language
"----------
  Plug 'kchmck/vim-coffee-script'
  Plug 'mattn/emmet-vim'
  Plug 'neoclide/vim-jsx-improve'
  " Plug 'MaxMEllon/vim-jsx-pretty'
  " Plug 'isRuslan/vim-es6'
  " Plug 'jelera/vim-javascript-syntax'
  " Plug 'mxw/vim-jsx'
  " Plug 'pangloss/vim-javascript'

  Plug 'tbastos/vim-lua'

  Plug 'elixir-editors/vim-elixir'


" Files
"----------
  Plug 'junegunn/fzf.vim'
  Plug 'scrooloose/nerdtree'
  Plug 'tpope/vim-fugitive'
  Plug 'mhinz/vim-startify'

  Plug '/usr/local/opt/fzf'

" Shortcuts
"----------
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
  Plug 'jiangmiao/auto-pairs'
  Plug 'machakann/vim-sandwich'
  Plug 'tommcdo/vim-exchange'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-repeat'
  Plug 'vim-scripts/mru.vim'
  Plug 'tpope/vim-surround'
  Plug 'christoomey/vim-sort-motion'

" Utility
"----------
  Plug 'Carpetsmoker/undofile_warn.vim'
  Plug 'Shougo/deoplete.nvim', { 'do' : ':UpdateRemotePlugins' }
  Plug 'tbodt/deoplete-tabnine', { 'do' : './install.sh' }
  Plug 'simnalamburt/vim-mundo'
  Plug 'suan/vim-instant-markdown'
  Plug 'vimwiki/vimwiki'
  Plug 'w0rp/ale'
  Plug 'zhimsel/vim-stay'

  Plug 'ryanoasis/vim-devicons' " leave this last

call plug#end()


"--------------------
" Plugin Options
"--------------------
" airline
"----------
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1
let g:airline_section_y = ''
let g:airline_theme='minimalist'
let g:airline_section_z = airline#section#create_right(['%p%% %l/%L %c'])

" === coc.nvim === "
nmap <silent> <leader>dd <Plug>(coc-definition)
nmap <silent> <leader>dr <Plug>(coc-references)
nmap <silent> <leader>dj <Plug>(coc-implementation)

" NERDTree
"----------
let g:NERDTreeWinSize=25
nnoremap <Leader>t :NERDTreeToggle<CR>
nnoremap <Leader>f :NERDTreeFind<CR>
let NERDTreeQuitOnOpen = 1

" Git gutter
"----------
let g:gitgutter_sign_added = '•'
let g:gitgutter_sign_modified = '•'
let g:gitgutter_sign_removed = '•'
let g:gitgutter_sign_removed_first_line = '-'
let g:gitgutter_sign_modified_removed = '••'

highlight GitGutterAdd    guifg=#009900 guibg=<X> ctermfg=2
highlight GitGutterChange guifg=#bbbb00 guibg=<X> ctermfg=3
highlight GitGutterDelete guifg=#ff2222 guibg=<X> ctermfg=1

" Codi
"----------
let g:codi#width=30

" Deoplete
"----------
let g:deoplete#enable_at_startup=1
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" ultisnips
"----------
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
" set runtimepath+=~/.vim/UltiSnips
" let g:UltiSnipsSnippetDir= ['UltiSnips', '~/.vim/UltiSnips']
" let g:UltiSnipsSnippetDir= ['~/.vim/UltiSnips']
" let g:UltiSnipsSnippetDirectories=["UltiSnips"]

" Ale
"----------
let g:ale_sign_error = '►'
let g:ale_sign_warning = '-'
highlight clear ALEErrorSign
highlight clear ALEWarningSign
highlight ALEErrorSign guifg=red
highlight ALEWarningSign guifg=orange

" fzf.vim
"----------
nnoremap <C-p> :FZF<CR>
nnoremap <C-l> :Lines<CR>
nnoremap <C-g> :Rg<CR>

" vimwiki
"----------
let g:vimwiki_hl_cb_checked = 2

" goyo
"----------
let g:goyo_width=100
" let g:goyo_height=50
let g:goyo_linenr=0
nnoremap <leader>g :Goyo<CR>

" limelight
"----------
nnoremap <leader>l :Limelight!!<CR>

" vim-commentary
"----------
augroup SyntaxForCoffee
  autocmd BufRead *.coffee setlocal filetype=coffee
  autocmd FileType coffee setlocal commentstring=#\ %s
augroup END

" Mundo
"-----------
nnoremap <leader>m :MundoToggle<CR>

" Highlighted Yank
"-----------
let g:highlightedyank_highlight_duration = 500

" emmet
"-----------
let g:user_emmet_leader_key='<C-E>'

" quick-scope
"-----------
let g:qs_max_chars=100

" vim-illuminate
"-----------
let g:Illuminate_delay = 400
hi illuminatedWord cterm=underline gui=underline

" webdevicons
"-----------
let g:webdevicons_enable_airline_statusline_fileformat_symbols=0

" vim-smoothie
"-----------
" default is 20
let g:smoothie_update_interval = 10
" default is 10
let g:smoothie_base_speed = 25

"--------------------
" Visual
"--------------------
colorscheme badwolf

" JavaScript colors
"----------
" 1, -2
highlight javascriptvalue ctermfg=brown guifg=#f4cf86
" Array, Date, Object
highlight javascripttype ctermfg=brown guifg=#f4cf86
" this, arguments
highlight javascriptspecialreference guifg=#ff9eb8 gui=italic
" !, ~, ^
highlight javascriptoperatorsymbol guifg=#ff2c4b

highlight javascriptboolean guifg=#b88853 gui=italic

highlight comment cterm=italic gui=italic
highlight statement cterm=italic gui=italic
highlight conditional cterm=italic gui=italic
highlight repeat cterm=italic gui=italic
highlight exception cterm=italic gui=italic
highlight operator cterm=italic gui=italic

" vimwiki colors
"----------
highlight vimwikiheader1 guifg=red gui=italic
highlight vimwikiheader2 guifg=lightgreen gui=italic
highlight vimwikiheader3 guifg=red gui=italic

" Gutter
"----------
set ruler
set number
set relativenumber " bad for performamnce?

" Status
"----------
set laststatus=2 " always show status line
set cmdheight=2
set showcmd

" Text
"----------
set showmatch
set matchtime=3 " multiple of 100ms
set list
set listchars=tab:‣\ ,trail:•,precedes:«,extends:»
" set listchars=tab:│·,trail:•,precedes:«,extends:»,eol:¬
" set listchars=tab:│·,trail:•,precedes:«,extends:»
highlight whitespace ctermbg=white

" Window
"----------
set scrolloff=10 " buffer top and bottom

" highlight past 80 chars
highlight OverLength guibg=black
match OverLength /\%81v.\+/
" execute "set colorcolumn=" . join(range(81,335), ',')
" set colorcolumn=90

set cursorline
set cursorcolumn
" set nocursorline
set cc=
" augroup ClearColorColumn
"   autocmd BufRead *.* set cc=""
" augroup END

" Spelling
"----------
set spelllang=en

"--------------------
" Folding
"--------------------
set foldcolumn=2

" replaced with plugin
" augroup Auto_Save_Folds
"   autocmd!
"   autocmd bufwinleave *.* mkview!
"   autocmd bufwinenter *.* silent loadview
" augroup end

"--------------------
" Searching and Highlighting
"--------------------
set path+=** " recursive fuzzy search with :find
set incsearch " search realtime
set hlsearch
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
set ignorecase
set smartcase

" Live substitutions
set inccommand=nosplit

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
" Exit insert mode
inoremap jk <esc>
inoremap kj <esc>

" Move cursor around
nnoremap <S-h> ^
nnoremap <S-l> $

" Line wrap navigation
nnoremap j gj
nnoremap k gk

" Quick edit vimrc (init.vim)
nnoremap <leader>ev :edit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Move lines
nnoremap <C-j> :move .+1<CR>==
nnoremap <C-k> :move .-2<CR>==
vnoremap <S-j> :move '>+1<CR>gv=gv
vnoremap <S-k> :move '<-2<CR>gv=gv

" Copy line, comment out, and paste below
nmap <A-d> yygccp

" Operators for text in parantheses
onoremap p i(
onoremap np :<c-u>normal! f(vi(<cr>

" Operator for text after '='
onoremap n= :<c-u>normal! f=wvg_<left><cr>

" Split into two lines
nnoremap K i<CR><ESC>

" console.log the current line
nnoremap <m-c> _iconsole.log(<ESC>A);<ESC>

" open most recents
nnoremap <C-m> :MRU<CR>


"--------------------
" Scripts
"--------------------
" view output from running in terminal
noremap <A-b> :call Build() <cr>
function! Build()
  if &filetype == "javascript"
    exec "! node %"
  elseif &filetype == "python"
    exec "! python3 %"
  endif
endfunction

" show hyperlinks in help files
augroup showHyperlinksInHelp
  autocmd BufWinEnter *.txt setlocal cole=0
augroup END

" replaced with plugin
" remove deleted marks from shada
" augroup Force_Delete_Marks
"   autocmd!
"   autocmd bufwinleave *.* wshada!
" augroup end

" Floating windows for fzf with previews
" let g:height = float2nr(&lines * 0.9)
" let g:width = float2nr(&columns * 0.95)
" let g:preview_width = float2nr(&columns * 0.7)
" let g:fzf_buffers_jump = 1
" let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"
" let $FZF_DEFAULT_OPTS=" --color=dark --color=fg:15,bg:-1,hl:1,fg+:#ffffff,bg+:0,hl+:1 --color=info:0,prompt:0,pointer:12,marker:4,spinner:11,header:-1 --layout=reverse  --margin=1,4 --preview 'if file -i {}|grep -q binary; then file -b {}; else bat --style=changes --color always --line-range :40 {}; fi' --preview-window right:" . g:preview_width
" let g:fzf_layout = { 'window': 'call FloatingFZF(' . g:width . ',' . g:height . ')' }

" Floating windows for fzf
" let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"
" let $FZF_DEFAULT_OPTS=' --color=dark --color=fg:15,bg:-1,hl:1,fg+:#ffffff,bg+:0,hl+:1 --color=info:0,prompt:0,pointer:12,marker:4,spinner:11,header:-1 --layout=reverse  --margin=1,4'
" let g:fzf_layout = { 'window': 'call FloatingFZF()' }

" function! FloatingFZF()
"   let buf = nvim_create_buf(v:false, v:true)
"   call setbufvar(buf, '&signcolumn', 'no')

"   let height = float2nr(10)
"   let width = float2nr(80)
"   let horizontal = float2nr((&columns - width) / 2)
"   let vertical = 1

"   let opts = {
"         \ 'relative': 'editor',
"         \ 'row': vertical,
"         \ 'col': horizontal,
"         \ 'width': width,
"         \ 'height': height,
"         \ 'style': 'minimal'
"         \ }

"   call nvim_open_win(buf, v:true, opts)
" endfunction


"--------------------
" Abbreviations
"--------------------
" use iab
