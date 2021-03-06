" ~/.config/nvim/init.vim

" Stop using j/k/h/l so much
" noremap h <NOP>
" noremap l <NOP>
" noremap j <NOP>
" noremap k <NOP>

" Core ----------------------------------------------------------------------
" ---------------------------------------------------------------------------
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum" " enable italcs
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum" " enable italics

if has('termguicolors')
  set termguicolors
endif

set mouse=a
syntax enable
filetype plugin indent on
set encoding=utf8
" set clipboard=unnamedplus " integrate with mac
set clipboard=unnamed " integrate with windows
set updatetime=500
set undofile " set persistent undo
set undodir=$HOME/.vim/undo
set undolevels=500 " default is 1000
set history=500 " default is 50
set undoreload=10000
set matchpairs+=<:> " Add additional match pairs
set hidden " switch buffers without requiring a save
set autoread " automatically read modified files in buffers
set linebreak " don't break at the middle of word why is this slow sometimes lets try that again and again and again

" Spellcheck
set spelllang=en
set spell

set nostartofline


" Plugins -------------------------------------------------------------------
" ---------------------------------------------------------------------------
call plug#begin('~/.vim/plugged')

  " Visual
  " ------
  Plug 'sjl/badwolf'
  Plug 'airblade/vim-gitgutter' " git diff in the gutter
    let g:gitgutter_sign_added = '•'
    let g:gitgutter_sign_modified = '•'
    let g:gitgutter_sign_removed = '•'
    let g:gitgutter_sign_removed_first_line = '-'
    let g:gitgutter_sign_modified_removed = '••'
    highlight GitGutterAdd    guifg=#009900 guibg=<X> ctermfg=2
    highlight GitGutterChange guifg=#bbbb00 guibg=<X> ctermfg=3
    highlight GitGutterDelete guifg=#ff2222 guibg=<X> ctermfg=1
  Plug 'ap/vim-css-color' " preview of css colors
  Plug 'junegunn/goyo.vim' " distraction free writing in vim
    let g:goyo_width=100
    " let g:goyo_height=50
    let g:goyo_linenr=0
    nnoremap <leader>g :Goyo<CR>
  Plug 'junegunn/limelight.vim' " hyperfocus writing
    nnoremap <leader>l :Limelight!!<CR>
  Plug 'junegunn/vim-peekaboo' " see \" and @ registry contents
  Plug 'kshenoy/vim-signature' " toggle, display, and navigate marks
  Plug 'machakann/vim-highlightedyank' " show yanked region
    let g:highlightedyank_highlight_duration = 500
  " Plug 'markonm/traces.vim' " range, pattern, and substitute preview for vim
  Plug 'rrethy/vim-illuminate' "highlight other word under cursor
    let g:Illuminate_delay = 250 " Default is 250
    let g:Illuminate_highlightUnderCursor = 0 " don't highlight under cursor with 0
    " hi illuminatedWord cterm=cursorline gui=cursorline
    hi illuminatedWord cterm=underline ctermfg=none ctermbg=none gui=underline guifg=none guibg=none
  Plug 'unblevable/quick-scope' " see f/t targets
    let g:qs_max_chars=120
    let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
  Plug 'vim-airline/vim-airline' " lightweight statusbar
  Plug 'vim-airline/vim-airline-themes'
    let g:airline_powerline_fonts=1
    let g:airline#extensions#tabline#enabled=1
    let g:airline_section_y = ''
    let g:airline_theme='minimalist'
    let g:airline#extensions#tabline#formatter = 'jsformatter'
    let g:airline#extensions#branch#displayed_head_limit = 10 " truncate branch name
    let g:airline#extensions#branch#format = 1 " only show tail of branch name
  " Plug 'psliwka/vim-smoothie' " smooth scrolling
  "   let g:smoothie_base_speed = 30 " default is 10
  "   let g:smoothie_update_interval = 12 " default is 20
  " Plug 'yuttie/comfortable-motion.vim'

  " Lsp
  " --------
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  " Find files using Telescope command-line sugar.
  Plug 'nvim-telescope/telescope.nvim'
  nnoremap <leader>ff <cmd>Telescope find_files<cr>
  nnoremap <leader>fg <cmd>Telescope live_grep<cr>
  nnoremap <leader>fb <cmd>Telescope buffers<cr>
  nnoremap <leader>fh <cmd>Telescope help_tags<cr>
  nnoremap <c-p> <cmd>Telescope find_files<cr>
  nnoremap <c-b> <cmd>Telescope buffers<cr>
  nnoremap <c-l> <cmd>Telescope current_buffer_fuzzy_find<cr>
  nnoremap <c-h> <cmd>Telescope jumplist<cr>
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'kyazdani42/nvim-tree.lua'
  nnoremap <c-n> :NvimTreeToggle<cr>

  " Language
  " --------
  " Javascript
  Plug 'mattn/emmet-vim', { 'for': 'javascript' }
    let g:user_emmet_leader_key='<C-E>' " and then press `,`
  Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
  " Plug 'jelera/vim-javascript-syntax'
  " Plug 'isRuslan/vim-es6'
  Plug 'yardnsm/vim-import-cost', { 'do': 'npm install', 'for': 'javascript' }

  " Jsx/Tsx
  Plug 'neoclide/vim-jsx-improve', { 'for': 'javascript' }
  Plug 'MaxMEllon/vim-jsx-pretty', { 'for': 'javascript' }
  " Plug 'peitalin/vim-jsx-typescript'
  " Plug 'mxw/vim-jsx'

  " Misc
  Plug 'elixir-editors/vim-elixir', { 'for': 'elixir' }
  Plug 'jparise/vim-graphql', { 'for': 'graphql' }
  Plug 'tbastos/vim-lua', { 'for': 'lua' }


  " Files
  " -----
  " Plug 'junegunn/fzf.vim' " integrate with fzf
  " Plug '/usr/local/opt/fzf'
  "   " Use a centered floating window, requires tmux >3.2
  "   " if exists('$TMUX')
  "   "   let g:fzf_layout = { 'tmux': '-p90%,60%' }
  "   " else
  "   "   let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.5, 'yoffset': 0.90 } }
  "   " endif

  "   let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.5, 'yoffset': 0.90 } }
  "   " let g:fzf_preview_window = 'right:60%' " Always show preview

  "   " :GFiles respects .gitignore (over :FZF or :Files)
  "   nnoremap <C-p> :GFiles<CR>
  "   nnoremap <C-l> :Lines<CR>
  "   nnoremap <C-g> :Rg<CR>
  "   nnoremap <C-b> :Buffers<CR>
  " Plug 'scrooloose/nerdtree' , { 'on': 'NERDTreeToggle' } " interactive file explorer
  "   let g:NERDTreeWinSize=25
  "   nnoremap <Leader>n :NERDTreeToggle<CR>
  "   " nnoremap <Leader>f :NERDTreeFind<CR>
  "   let NERDTreeQuitOnOpen = 1
  Plug 'tpope/vim-fugitive'
  " Plug 'mhinz/vim-startify'
  "   " let g:startify_custom_header = 'startify#pad(startify#fortune#quote())'
  "   let g:startify_custom_header = ''

  " Shortcuts
  " ---------
  Plug 'SirVer/ultisnips'
    let g:UltiSnipsExpandTrigger="<c-j>"
    let g:UltiSnipsJumpForwardTrigger="<c-j>"
    let g:UltiSnipsJumpBackwardTrigger="<c-k>"
    " set runtimepath+=~/.vim/UltiSnips
    " let g:UltiSnipsSnippetDir= ['UltiSnips', '~/.vim/UltiSnips']
    " let g:UltiSnipsSnippetDir= ['~/.vim/UltiSnips']
    " let g:UltiSnipsSnippetDirectories=["UltiSnips"]
  Plug 'honza/vim-snippets'
  Plug 'jiangmiao/auto-pairs'

  " TODO: just take b bracket motion from here
  Plug 'machakann/vim-sandwich'

  Plug 'tommcdo/vim-exchange' " adds switch motion
  Plug 'tpope/vim-commentary' " comments
  Plug 'tpope/vim-repeat' " extends power of repeat motion
  Plug 'vim-scripts/mru.vim' " shows most recently used screen
  Plug 'tpope/vim-surround' " adds surround motions
  Plug 'christoomey/vim-sort-motion' " sort alphabetically
  " Plug 'mg979/vim-visual-multi', { 'branch': 'master' } " multi cursor suppport

  " Utility
  " -------
  Plug 'Carpetsmoker/undofile_warn.vim'
  " Plug 'Shougo/deoplete.nvim', { 'do' : ':UpdateRemotePlugins' }
  " Plug 'tbodt/deoplete-tabnine', { 'do' : './install.sh' }
  "   let g:deoplete#enable_at_startup=1
  "   inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
  Plug 'simnalamburt/vim-mundo', { 'on': 'MundoToggle' }
    nnoremap <leader>m :MundoToggle<CR>
  Plug 'vimwiki/vimwiki'
    let g:vimwiki_hl_cb_checked = 2
    highlight vimwikiheader1 guifg=red gui=italic
    highlight vimwikiheader2 guifg=lightgreen gui=italic
    highlight vimwikiheader3 guifg=red gui=italic
  Plug 'w0rp/ale'
    let g:ale_sign_error = '►'
    let g:ale_sign_warning = '-'
    highlight clear ALEErrorSign
    highlight clear ALEWarningSign
    highlight ALEErrorSign guifg=red
    highlight ALEWarningSign guifg=orange
    nnoremap ge :ALENextWrap<cr>
  Plug 'farmergreg/vim-lastplace'
  " Live markdown preview in browser
  Plug 'suan/vim-instant-markdown', { 'for': 'markdown' }
    let g:instant_markdown_autostart = 0
    " let g:floaterm_wintype='floating'
    let g:floaterm_wintitle=v:false " hide foaterm info 'floaterm: 1/1'
    let g:floaterm_width=0.8 " as percentage of width
    let g:floaterm_winblend=0 " alpha for window transparency
    let g:floaterm_borderchars=['─', '│', '─', '│', '╭', '╮', '╯', '╰']
    let g:floaterm_autoclose=v:true
    let g:floaterm_keymap_toggle='<C-T>'
    highlight Floaterm guibg=black
    nnoremap <C-T> :FloatermToggle<CR>
    autocmd! User term.vim echom 'floaterm is now loaded'

    " use Ranger wrapper
    command! Ranger FloatermNew ranger
    nnoremap <Leader>r :Ranger<CR>
  Plug 'semanser/vim-outdated-plugins'
    " do not show message if all plugins are up to date
    let g:outdated_plugins_silent_mode = 1
  Plug 'dstein64/vim-startuptime'
  " Plug 'neoclide/coc.nvim', { 'branch': 'release' }

  " Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] } " emacs style which key keybinding popups
  Plug 'liuchengxu/vim-which-key' " emacs style which key keybinding popups
    " set timeoutlen=500
    nnoremap <silent> <leader> :<c-u>WhichKey '\'<CR>

  " Leave this last
  " Plug 'ryanoasis/vim-devicons', { 'on': 'NERDTreeToggle' }
  "   autocmd! User floaterm.vim echom 'floaterm is now loaded'
  "   let g:webdevicons_enable_airline_statusline_fileformat_symbols=0

call plug#end()

  " leave these here
  colorscheme badwolf
  let g:airline_section_z = airline#section#create_right(['%p%% %l/%L %c'])

" Visual --------------------------------------------------------------------
" ---------------------------------------------------------------------------
"
" Keys
" #ff2c4b
" #ff9eb8
" #f4cf86
" #9edf1c

" JavaScript colors
" ---------- ------
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
" new
highlight jsOperatorKeyword cterm=italic gui=italic guifg=#ff2c4b
" const let
highlight jsStorageClass cterm=italic gui=italic guifg=#ff2c4b

highlight comment cterm=italic gui=italic
highlight statement cterm=italic gui=italic
highlight conditional cterm=italic gui=italic
highlight repeat cterm=italic gui=italic
highlight exception cterm=italic gui=italic
" highlight operator cterm=italic gui=italic

" https://github.com/pangloss/vim-javascript/blob/master/syntax/javascript.vim
highlight jsNull guifg=#ff9eb8 cterm=italic gui=italic
highlight jsThis guifg=#ff9eb8 cterm=italic gui=italic
highlight jsUndefined guifg=#ff9eb8 cterm=italic gui=italic
highlight jsFunction guifg=#ff9eb8 cterm=italic gui=italic

highlight jsImport guifg=#9edf1c cterm=italic gui=italic
highlight jsFrom guifg=#9edf1c cterm=italic gui=italic
highlight jsExport guifg=#9edf1c cterm=italic gui=italic
highlight jsModuleAs guifg=#9edf1c cterm=italic gui=italic

highlight jsAsyncKeyword guifg=#ff2c4b cterm=italic gui=italic


" Gutter
" ------
set ruler
set number "nu
" relativenumber potentially causes performance issues
" set relativenumber " rnu

" Status
" ------
set laststatus=2 " always show status line
set cmdheight=2
set showcmd

" Text
" ----
set showmatch
set matchtime=3 " multiple of 100ms
set list
set listchars=tab:‣\ ,trail:•,precedes:«,extends:»
" set listchars=tab:│·,trail:•,precedes:«,extends:»,eol:¬
" set listchars=tab:│·,trail:•,precedes:«,extends:»
highlight whitespace ctermbg=white

" Window
"
" let view_height = &lines / 4
" echo view_height
set scrolloff=24 " buffer top and bottom

" Highlight past 80 chars
highlight OverLength guibg=black
match OverLength /\%81v.\+/
" set colorcolumn=90

set cursorline
set cursorcolumn

" highlight CursorLine guibg=none ctermbg=none
" highlight CursorLine guifg=white guibg=darkblue ctermfg=white ctermbg=darkblue

" Only show cursorlines on active window and in normal mode
" NOTE: esc does not trigger InsertLeave by default
inoremap <c-c> <esc>
augroup ShowLines
  autocmd!
  autocmd InsertLeave * set cursorline
  autocmd InsertLeave * set cursorcolumn
augroup END

augroup HideLines
  autocmd!
  autocmd InsertEnter * set nocursorcolumn
  autocmd InsertEnter * set nocursorline
augroup END

" Folding -------------------------------------------------------------------
" ---------------------------------------------------------------------------
set foldcolumn=2

" -- Searching and Highlighting ------------------------------------------------
" ---------------------------------------------------------------------------
set path+=** " recursive fuzzy search with :find
set incsearch " search realtime
set hlsearch
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
set ignorecase
set smartcase
set inccommand=nosplit " live substitutions

" Center searches
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" Center after jumps
nnoremap g; g;zz
nnoremap gi gi<esc>zzi

" Tabbing ------------------------------------------------------------------
" ---------------------------------------------------------------------------
set tabstop=2
set shiftwidth=2
set smarttab
set expandtab

" Mappings ------------------------------------------------------------------
" ---------------------------------------------------------------------------
" Exit insert mode with jk
inoremap jk <esc>
" inoremap kj <esc>

" Remap move cursor to ends of lines H / L
noremap <S-h> ^
noremap <S-l> $

" Line wrap navigation
nnoremap j gj
nnoremap k gk

" Quick edit configs
nnoremap <leader>ev :edit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>et :edit ~/.tmux.conf<cr>
nnoremap <leader>ez :edit ~/.zshrc<cr>
nnoremap <leader>ef :edit ~/.config/fish/fish.config<cr>
nnoremap <leader>eh :edit ~/.hammerspoon/init.lua<cr>

" Move lines
nnoremap <C-j> :move .+1<CR>==
nnoremap <C-k> :move .-2<CR>==
vnoremap <S-j> :move '>+1<CR>gv=gv
vnoremap <S-k> :move '<-2<CR>gv=gv

" Copy line, comment out, and paste below
nmap <A-d> yygccp

" Operators for text in parentheses
onoremap p i(
onoremap np :<c-u>normal! f(vi(<cr>

" Operator for text after '='
onoremap n= :<c-u>normal! f=wvg_<left><cr>

" Split into two lines
nnoremap K i<CR><ESC>

" console.log the current line
nnoremap <m-c> _iconsole.log(<ESC>A);<ESC>

" Open most recents
nnoremap <C-m> :MRU<CR>

" Use smart command line history navigation with ctrl-p/n
" this doesn't work!!
cnoremap <c-p> <up>
cnoremap <c-n> <down>

" Don't lose selection when using > or < to shift text
" NOTE: this conflicts with .
" xnoremap < <gv
" xnoremap > >gv

" Delete without copying to register
nnoremap s "_d
nnoremap S "_d

" Make Y consistent with C and D
nnoremap Y y$

" Add empty space with enter
nnoremap <cr> o<esc>

" Don't interfere with command-line enter
autocmd CmdwinEnter * nnoremap <CR> <CR>
autocmd BufReadPost quickfix nnoremap <CR> <CR>

" Visual select previously pasted text
nnoremap gp `[v`]

" Scripts ----------------------------------------------------------------------
" ---------------------------------------------------------------------------
" View output from running in terminal
noremap <A-b> :call Build() <cr>
function! Build()
  if &filetype == "javascript"
    exec "! node %"
  elseif &filetype == "python"
  elseif &filetpe == "sh"
  elseif &filetype == "sh"
    exec "!bash %"
  endif
endfunction

" Show hyperlinks in help files
augroup showHyperlinksInHelp
  autocmd BufWinEnter *.txt setlocal cole=0
augroup END

" Outputs highlight group below cursor with leader hi
nmap <leader>hi :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" Abbreviations -------------------------------------------------------------
" ---------------------------------------------------------------------------
" use iab


" VIM Notes -----------------------------------------------------------------
" ---------------------------------------------------------------------------
" Maps
" - Check the keymapping with :map <key>
" Folding
" Spelling
" - use `zg` to add to dictionary
" Filetypes
" - check current with `set filetype?`

lua << EOF
  require("telescope").setup {
    defaults = {
      -- Your defaults config goes in here
    },
    pickers = {
      -- Your special builtin config goes in here
      buffers = {
        sort_lastused = true,
        theme = "dropdown",
        previewer = false,
        mappings = {
          i = {
            ["<c-d>"] = require("telescope.actions").delete_buffer,
            -- or right hand side can also be a the name of the action as string
            ["<c-d>"] = "delete_buffer",
            },
          n = {
            ["<c-d>"] = require("telescope.actions").delete_buffer,
            }
          }
        },
      find_files = {
        -- theme = "dropdown"
        }
      },
    extensions = {
      -- your extension config goes in here
      }
    }

  require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = {
      enable = false,              -- false will disable the whole extension
      disable = { "c", "rust" },  -- list of language that will be disabled
    },
  }
EOF
