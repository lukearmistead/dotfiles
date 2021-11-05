"                     __      ___           _____   _____
"                     \ \    / (_)         |  __ \ / ____|
"                      \ \  / / _ _ __ ___ | |__) | |
"                       \ \/ / | | '_ ` _ \|  _  /| |
"                        \  /  | | | | | | | | \ \| |____
"                         \/   |_|_| |_| |_|_|  \_\\_____|
                                      
                                      
"  ___      _
" / __| ___| |_ _  _ _ __
" \__ \/ -_)  _| || | '_ \
" |___/\___|\__|\_,_| .__/
"                   |_|

" Initialize plugin manager
call plug#begin('~/.vim/plugged')

" set leader
" https://medium.com/usevim/vim-101-what-is-the-leader-key-f2f5c1fa610f
let mapleader=","

" Estbalish sensible defaults
Plug 'tpope/vim-sensible'

" Removes compatabilities with vi which can cause issues
set nocompatible



"  ___
" / __| ___ __ _ _ _ __| |_
" \__ \/ -_) _` | '_/ _| ' \
" |___/\___\__,_|_| \__|_||_|

" Search as characters are entered
set incsearch

" Highlight matches
set hlsearch

" Clear search
nnoremap <leader><space> :nohlsearch<CR>

" -------------------
" ACK SEARCH FOR TEXT
" -------------------

Plug 'mileszs/ack.vim'

" Configures vimgrep
" https://www.freecodecamp.org/news/how-to-search-project-wide-vim-ripgrep-ack/
let g:ackprg = 'rg --vimgrep --type-not sql --smart-case'

" Auto close the Quickfix list after pressing '<enter>' on a list item
let g:ack_autoclose = 1

" Any empty ack search will search for the work the cursor is on
let g:ack_use_cword_for_empty_search = 1

" Don't jump to first match
cnoreabbrev Ack Ack!
"
" Maps <leader>/ so we're ready to type the search keyword
nnoremap <Leader>/ :Ack!<Space>

"-----------------------
" FUZZY SEARCH FOR FILES
"-----------------------

" https://jesseleite.com/posts/2/its-dangerous-to-vim-alone-take-fzf
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" All files 
nmap <Leader>f :Files<CR>

" Lines in current buffer
nmap <Leader>l :BLines<CR> 

" Lines in loaded buffers
nmap <Leader>L :Lines<CR>

" Most Recently Used (MRU) plugin provides an easy access to a list of recently opened/edited files in Vim
" https://github.com/yegappan/mru
nmap <Leader>r :MRU<CR> 
Plug 'yegappan/mru'

" ------------------------------------------------
" GUTENTAGS SEARCH FOR  DEFINITIONS AND REFERENCES
" ------------------------------------------------

" TODO - Broken
Plug 'ludovicchabant/vim-gutentags'

" Tags
" https://ricostacruz.com/til/navigate-code-with-ctags
" https://andrew.stwrt.ca/posts/vim-ctags/#fnref:1
" To jump to definition instead of first occurrence: https://stackoverflow.com/questions/1054701/get-ctags-in-vim-to-go-to-definition-not-declaration
"" nnoremap <leader>ct :!ctags -R -f ./.git/tags .<CR>
"" set tags=./tags;/       " look in the current directory for "tags", and work up the tree towards root until one is found. https://stackoverflow.com/questions/563616/vim-and-ctags-tips-and-tricks

set statusline+=%{gutentags#statusline()}



"  ___     _            __
" |_ _|_ _| |_ ___ _ _ / _|__ _ __ ___
"  | || ' \  _/ -_) '_|  _/ _` / _/ -_)
" |___|_||_\__\___|_| |_| \__,_\__\___|


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

" space open/closes folds
nnoremap <space> za

" fold based on indent level
set foldmethod=indent



" __      __   _ _   _
" \ \    / / _(_) |_(_)_ _  __ _
"  \ \/\/ / '_| |  _| | ' \/ _` |
"   \_/\_/|_| |_|\__|_|_||_\__, |
"                          |___/

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
" PROSE
" https://www.bfoliver.com/2014/12/06/vimforprose/
" https://wynnnetherland.com/journal/reed-esau-s-growing-list-of-vim-plugins-for-writers/
" ------------------------------------------------

" Words wrap nicely, cursor skips through lines not paragraphs.
Plug 'reedes/vim-pencil' 

" Distraction free writing 
" `:Goyo` and `:Goyo!` enable and disable Goyo, respectively
Plug 'junegunn/goyo.vim'

" Maps spellcheck
"" nnoremap <leader>sp :set spell spelllang=en_us<cr>

" When in a markdown press Ctrl-p is pressed, this plugin will either open a preview in your browser
Plug 'JamshedVesuna/vim-markdown-preview' 

" Extends Vim's built-in spell-checking and thesaurus/dictionary completion
Plug 'preservim/vim-lexical'

" Lightweigh autocorrection (teh => the)
Plug 'preservim/vim-litecorrect'

" Initializes plugins for prose-oriented files
function! Prose()
  call pencil#init()
  syntax disable
  call lexical#init()
  call litecorrect#init()
  set nocursorline
  :syntax off
  :Goyo
endfunction

" Automatically initialize buffer by file type
autocmd FileType markdown,md,mkd,text,txt call Prose()

"  _  _          _           _   _
" | \| |__ ___ _(_)__ _ __ _| |_(_)___ _ _
" | .` / _` \ V / / _` / _` |  _| / _ \ ' \
" |_|\_\__,_|\_/|_\__, \__,_|\__|_\___/_||_|
"                 |___/

" move vertically by visual line
"" nnoremap j gj
"" nnoremap k gk

" highlight last inserted text
nnoremap gV `[v`]

" Nerd Tree
Plug 'scrooloose/nerdtree'
map <C-n> :NERDTreeToggle<CR> " Opens nerdtree with control+n

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

" ---------------------------------------------------------------
" EDIT VIMRC
" https://learnvimscriptthehardway.stevelosh.com/chapters/07.html
" ---------------------------------------------------------------
"
" Easily edit vimrc and source it to effect changes
nnoremap <leader>ev :split $MYVIMRC<cr>

" Sets source to vim, installs any new plugins, and quits the status bar
nnoremap <leader>sv :source $MYVIMRC<cr> <bar> :PlugInstall<cr>


" copy to global clipboard
set clipboard=unnamed
nmap - :res<CR>:vertical res<CR>$


" load filetype-specific indent files
filetype indent on

" visual autocomplete for command menu
set wildmenu

" redraw only when we need to.
set lazyredraw

" Navigate quickfix list with ease
nnoremap <silent> [q :cprevious<CR>
nnoremap <silent> ]q :cnext<CR>


" End of document - this line lets the plugin manager know we're done
call plug#end()
