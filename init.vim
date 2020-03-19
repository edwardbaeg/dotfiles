" ~/.config/nvim/init.vim

" Stop using these!
" noremap h <NOP>
" noremap l <NOP>
" noremap j <NOP>
" noremap k <NOP>

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
  Plug 'sjl/badwolf'

  Plug 'airblade/vim-gitgutter'
  Plug 'ap/vim-css-color'
  Plug 'junegunn/goyo.vim'
  Plug 'junegunn/limelight.vim'
  Plug 'junegunn/vim-peekaboo'
  Plug 'kshenoy/vim-signature'
  Plug 'machakann/vim-highlightedyank'
  Plug 'markonm/traces.vim'
  Plug 'rrethy/vim-illuminate'
  " Plug 'itchyny/vim-cursorword'
  Plug 'unblevable/quick-scope'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'psliwka/vim-smoothie'
  " Plug 'yuttie/comfortable-motion.vim'
  " Plug 'dodie/vim-fibo-indent'

" Language
"----------
  " Javascript/Typescript
  Plug 'elixir-editors/vim-elixir'
  " Plug 'kchmck/vim-coffee-script'
  Plug 'mattn/emmet-vim'
  " Plug 'jelera/vim-javascript-syntax'
  " Plug 'isRuslan/vim-es6'
  Plug 'pangloss/vim-javascript'

  " Jsx/Tsx
  Plug 'neoclide/vim-jsx-improve'
  " Plug 'leafgarland/typescript-vim'
  " Plug 'peitalin/vim-jsx-typescript'
  Plug 'MaxMEllon/vim-jsx-pretty'
  " Plug 'mxw/vim-jsx'

  " Misc
  Plug 'elixir-editors/vim-elixir'
  Plug 'jparise/vim-graphql'
  " Plug 'kchmck/vim-coffee-script'

  Plug 'tbastos/vim-lua'

  Plug 'elixir-editors/vim-elixir'


" Files
"----------
  " Integrate with fzf
  Plug 'junegunn/fzf.vim'

  " Use a centered floating window
  let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.5, 'yoffset': 0.95 } }
  " let g:fzf_layout = { 'window': 'call CreateCenteredFloatingWindow()' }
  "
  " :GFiles respects .gitignore (over :FZF or :Files)
  nnoremap <C-p> :GFiles<CR>
  nnoremap <C-l> :Lines<CR>
  nnoremap <C-g> :Rg<CR>
  nnoremap <C-b> :Buffers<CR>

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
  Plug 'vimwiki/vimwiki'
  Plug 'w0rp/ale'
  Plug 'zhimsel/vim-stay'
  Plug 'suan/vim-instant-markdown'

  Plug 'yardnsm/vim-import-cost', { 'do': 'npm install' }

  Plug 'semanser/vim-outdated-plugins'
  " do not show message if all plugins are up to date
  let g:outdated_plugins_silent_mode = 1

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
let g:Illuminate_delay = 250 " Default is 250
let g:Illuminate_highlightUnderCursor = 0 " don't highlight under cursor with 0
" hi illuminatedWord cterm=cursorline gui=cursorline
hi illuminatedWord cterm=underline ctermfg=none ctermbg=none gui=underline guifg=none guibg=none

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
" #ff2c4b
" #ff9eb8
" #f4cf86
" #9edf1c

" 1, -2
highlight javascriptvalue ctermfg=brown guifg=#f4cf86
" Array, Date, Object
highlight javascripttype ctermfg=brown guifg=#f4cf86
" this, arguments
highlight javascriptspecialreference guifg=#ff9eb8 gui=italic
" !, ~, ^
highlight javascriptoperatorsymbol guifg=#ff2c4b
" true false
highlight javascriptboolean guifg=#ff2c4b gui=italic

highlight comment cterm=italic gui=italic
highlight statement cterm=italic gui=italic
highlight conditional cterm=italic gui=italic
highlight repeat cterm=italic gui=italic
highlight exception cterm=italic gui=italic
" highlight operator cterm=italic gui=italic

highlight jsNull guifg=#ff9eb8 cterm=italic gui=italic
highlight jsThis guifg=#ff9eb8 cterm=italic gui=italic
highlight jsUndefined guifg=#ff9eb8 cterm=italic gui=italic

highlight jsImport guifg=#9edf1c cterm=italic gui=italic
highlight jsFrom guifg=#9edf1c cterm=italic gui=italic
highlight jsExport guifg=#9edf1c cterm=italic gui=italic

" new
highlight jsOperatorKeyword cterm=italic gui=italic guifg=#ff2c4b

" const let
highlight jsStorageClass cterm=italic gui=italic guifg=#ff2c4b

" tsx colors
"----------
" dark red
" hi tsxTagName guifg=#E06C75

" " orange
" hi tsxCloseString guifg=#F99575
" hi tsxCloseTag guifg=#F99575
" hi tsxAttributeBraces guifg=#F99575
" hi tsxEqual guifg=#F99575

" " yellow
" hi tsxAttrib guifg=#F8BD7F cterm=italic

" vimwiki colors
"----------
highlight vimwikiheader1 guifg=red gui=italic
highlight vimwikiheader2 guifg=lightgreen gui=italic
highlight vimwikiheader3 guifg=red gui=italic

" Gutter
"----------
set ruler
set number "nu
set relativenumber " rnu

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
" inoremap kj <esc>

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

" outputs highlight group below cursor with leader hi
nmap <leader>hi :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" properly set filetype for tsx files
" augroup SyntaxSettings
"   autocmd!
"   autocmd BufNewFile,BufRead *.tsx set filetype=typescript
" augroup END

"--------------------
" Abbreviations
"--------------------
" use iab
