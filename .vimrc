"                     __      ___           _____   _____
"                     \ \    / (_)         |  __ \ / ____|
"                      \ \  / / _ _ __ ___ | |__) | |
"                       \ \/ / | | '_ ` _ \|  _  /| |
"                        \  /  | | | | | | | | \ \| |____
"                         \/   |_|_| |_| |_|_|  \_\\_____|


" TOC
" 1. Setup
" 2. Search
" 3. Interface
" 4. Writing
" 5. Navigation
" 6. Other
" 7. Resources

"  ___      _
" / __| ___| |_ _  _ _ __
" \__ \/ -_)  _| || | '_ \
" |___/\___|\__|\_,_| .__/
"                   |_|
" 1. Setup

" Initialize plugin manager
call plug#begin('~/.vim/plugged')

" set leader
" https://medium.com/usevim/vim-101-what-is-the-leader-key-f2f5c1fa610f
nnoremap <SPACE> <Nop>
let mapleader=" "

" Estbalish sensible defaults
" Plug 'tpope/vim-sensible'

" Removes compatabilities with vi which can cause issues
set nocompatible



"  ___
" / __| ___ __ _ _ _ __| |_
" \__ \/ -_) _` | '_/ _| ' \
" |___/\___\__,_|_| \__|_||_|

" 2. Search

" Search as characters are entered
set incsearch

" Clear search
nnoremap <leader><esc> :nohlsearch<CR>

" Highlight matches
set hlsearch

" Press one key to jump directly to search target
" Plug 'easymotion/vim-easymotion'
" map <Leader> <Plug>(easymotion-prefix)

"-------------------------------------------------------------------
" FUZZY SEARCH FOR FILES
" https://jesseleite.com/posts/2/its-dangerous-to-vim-alone-take-fzf
"-------------------------------------------------------------------

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" All files 
nmap <Leader>f :Files<CR>

" Tags
nmap <Leader>t :Tags<CR>

" Lines in current buffer
nmap <Leader>l :BLines<CR> 

" Lines in loaded buffers
nmap <Leader>L :Lines<CR>

" Search within project
nmap <Leader>/ :Rg<CR>

Plug 'yegappan/mru'
nmap <Leader>r :MRU<CR> 

"---------------------------------------------------------------------
" VIM-ONLY SEARCH
" https://github.com/changemewtf/no_plugins/blob/master/no_plugins.vim
"---------------------------------------------------------------------

" Make find easy
" nnoremap <Leader>f :find 

" Search down in subfolders
set path+=**

" autocompletes partially typed items in command menu
set wildmenu

" - Hit tab to :find by partial match
" - Use * to make it fuzzy
"
" --------------------------------------------------------------
" EXUBERANT TAGS TO SEARCH FOR DEFINITIONS
" Use git hooks to auto-update tags
" https://tbaggery.com/2011/08/08/effortless-ctags-with-git.html 
" --------------------------------------------------------------

" Create the `tags` file
" https://www.youtube.com/watch?v=XA2WjJbmmoM&t=974s&ab_channel=thoughtbot
command! MakeTags !ctags -R .
" - Use ^] to jump to tag under cursor
" - Use g^] for ambiguous tags
" - Use ^t to jump back up the tag stack
" - Navigate back and forth with ^o and ^i


"  ___     _            __
" |_ _|_ _| |_ ___ _ _ / _|__ _ __ ___
"  | || ' \  _/ -_) '_|  _/ _` / _/ -_)
" |___|_||_\__\___|_| |_| \__,_\__\___|

" 3. Interface

" run python file from vim
" https://stackoverflow.com/questions/18948491/running-python-code-in-vim
nmap <Leader>r :! clear; python %<CR>

" Go to "c"ommand line from vim
" running `fg` from terminal pulls vim back into foreground
" c-z accomplishes this out of the box actually
" https://towardsdatascience.com/getting-started-with-vim-and-tmux-for-python-707ec5ff747f
" https://www.reddit.com/r/vim/comments/10fboc6/how_do_you_guys_run_the_code_you_write_with_vim/
nnoremap <leader>c :stop<CR>

" https://github.com/tpope/vim-dispatch
" Leverage the power of Vim's compiler plugins without being bound by synchronicity. Kick off builds and test suites using one of several asynchronous adapters (including tmux, screen, iTerm, Windows, and a headless mode), and when the job completes, errors will be loaded and parsed automatically.

" Interactive debugging
" Requires `ipdb` python package
" https://towardsdatascience.com/getting-started-with-vim-and-tmux-for-python-707ec5ff747f
nmap <buffer> <leader>b oimport ipdb;ipdb.set_trace(context=5)<ESC>

" run python interactively from vim
Plug 'jpalardy/vim-slime'
let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": get(split($TMUX, ","), 0), "target_pane": ":.1"}

" Jupyter Vim
" https://github.com/jupyter-vim/jupyter-vim

" enable syntax highlighting
syntax enable
set encoding=UTF-8

" show line numbers
set number

" highlight current line
set cursorline

" relative line numbers
set relativenumber

" show (partial) command in status line
set showcmd

" show line and column number
set ruler

" highlight matching [{()}]
set showmatch

" turn off annoying bell
set belloff=all

" Informative status line
Plug 'vim-airline/vim-airline' 

" Pretty icons for interface
Plug 'ryanoasis/vim-devicons'  

" ---------------------------------
" Folding 
" http://vim.wikia.com/wiki/Folding
" ---------------------------------

" enable folding
set foldenable 

" open most folds by default
set foldlevelstart=10

" 10 nested fold max
set foldnestmax=10

" fold based on indent level
set foldmethod=indent


" __      __   _ _   _
" \ \    / / _(_) |_(_)_ _  __ _
"  \ \/\/ / '_| |  _| | ' \/ _` |
"   \_/\_/|_| |_|\__|_|_||_\__, |
"                          |___/
" 4. Writing

" Comment out line with `gcc` or motion target with `gc`
Plug 'tpope/vim-commentary'

" -----------------------------------------
" PEP 8 FORMATTING
" http://henry.precheur.org/vim/python.html
" -----------------------------------------

" Number of visual spaces per TAB
set tabstop=4

" Number of spaces in tab when editing
set softtabstop=4

" Tabs are spaces
set expandtab

" number of spaces for auto indent
set shiftwidth=4

" new line tab mirrors that of previous line
set autoindent

set backspace=indent,eol,start

" ------------------------------------------------
" AUTOCOMPLETION
" Use built in autocompletion 
" <C-x><C-n> - Simple word completion `<C-p>` goes back
" <C-x><C-]> - Complete tag
" <C-x><C-o> - language-aware completion
" https://www.reddit.com/r/vim/comments/jh0vjt/vim_autocomplete_for_python_2020/

" Augments autocompletion and reference  lookup for python
" Usage: https://github.com/davidhalter/jedi-vim#features
Plug 'davidhalter/jedi-vim'
" Disables autocomplete following a dot, which is expensive
let g:jedi#popup_on_dot = 0
" ------------------------------------------------
" 

" ------------------------------------------------
" PROSE
" https://www.bfoliver.com/2014/12/06/vimforprose/
" https://wynnnetherland.com/journal/reed-esau-s-growing-list-of-vim-plugins-for-writers/
" ------------------------------------------------

" Distraction free writing 
" `:Goyo` and `:Goyo!` enable and disable Goyo, respectively
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

" Color name (:help cterm-colors) or ANSI code
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240

" Markdown
" https://vim.works/2019/03/16/using-markdown-in-vim/
" Also need to run this to set up `npm install -g instant-markdown-d`
Plug 'instant-markdown/vim-instant-markdown', {'for': 'markdown', 'do': 'yarn install'}


function! ConfigureForProse()
  " Autoformat dictionary keys: 0=disable, 1=enable
  " Wrap text
  " set wrap
  set linebreak
  " Drop cursor line
  set nocursorline
  " Add spellcheck
  set spell spelllang=en_us
  " Move by visual line
  set foldmethod=indent
  nnoremap j gj
  nnoremap k gk
  nnoremap 0 g0
  nnoremap ^ g^
  nnoremap $ g$
  Goyo
endfunction

" Automatically initialize buffer by file type
autocmd FileType markdown,mkd,text call ConfigureForProse()



"  _  _          _           _   _
" | \| |__ ___ _(_)__ _ __ _| |_(_)___ _ _
" | .` / _` \ V / / _` / _` |  _| / _ \ ' \
" |_|\_\__,_|\_/|_\__, \__,_|\__|_\___/_||_|
"                 |___/
" 5. Navigation

" Hard Mode: Disables hjkl, page up, and page down keys
" noremap h <NOP>
" noremap j <NOP>
" noremap k <NOP>
" noremap l <NOP>
" noremap <Up> <NOP>
" noremap <Down> <NOP>
" noremap <Left> <NOP>
" noremap <Right> <NOP>
" noremap <C-u> <NOP>
" noremap <C-d> <NOP>

" Medium Mode: Adds delay after hjkl keys
" noremap hh <nop>
" noremap jj <nop>
" noremap kk <nop>
" noremap ll <nop>

" Visually navigate file tree
Plug 'scrooloose/nerdtree'

" Opens nerdtree with control+n
nnoremap <C-n> :NERDTreeToggle<CR> 

" Opens nerdtree expanded to current file
nnoremap <leader>n :NERDTreeFind<CR> 

" Navigate between vim and tmux splits using consistent hotkeys
Plug 'christoomey/vim-tmux-navigator'

" Operate on parentheses, brackets, quotes, XML tags, and more
Plug 'tpope/vim-surround'

" Extends '.' repeat operator to other plugins
Plug 'tpope/vim-repeat'



"   ___  _   _
"  / _ \| |_| |_  ___ _ _
" | (_) |  _| ' \/ -_) '_|
"  \___/ \__|_||_\___|_|

" 6. Other

" ---------------------------------------------------------------
" EDIT VIMRC
" https://learnvimscriptthehardway.stevelosh.com/chapters/07.html
" ---------------------------------------------------------------

" Easily edit vimrc and source it to effect changes
nnoremap <leader>ev :tab split $MYVIMRC<cr>

" Sets source to vim, installs any new plugins, and quits the status bar
nnoremap <leader>sv :source $MYVIMRC<cr> <bar> :PlugInstall<cr>

" By default timeoutlen is 1000 ms
set timeoutlen=500

" copy to global clipboard
set clipboard=unnamed
nmap - :res<CR>:vertical res<CR>$


" load filetype-specific indent files
filetype indent on


" redraw only when we need to.
set lazyredraw

" Navigate quickfix list with ease
nnoremap <silent> [q :cprevious<CR>
nnoremap <silent> ]q :cnext<CR>


" End of document - this line lets the plugin manager know we're done
call plug#end()

"  ___
" | _ \___ ___ ___ _  _ _ _ __ ___ ___
" |   / -_|_-</ _ \ || | '_/ _/ -_|_-<
" |_|_\___/__/\___/\_,_|_| \__\___/__/

" 7. Resources

" How to Do 90% of What Plugins Do (With Just Vim)
" https://www.youtube.com/watch?v=XA2WjJbmmoM&ab_channel=thoughtbot

" Most complete Vim cheatsheet
" https://github.com/ibhagwan/vim-cheatsheet
