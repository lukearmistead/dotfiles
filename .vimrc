"------------------------------------------------------------------------------
 " __      _______ __  __ _____   _____ 
 " \ \    / /_   _|  \/  |  __ \ / ____|
 "  \ \  / /  | | | \  / | |__) | |     
 "   \ \/ /   | | | |\/| |  _  /| |     
 "    \  /   _| |_| |  | | | \ \| |____ 
 "     \/   |_____|_|  |_|_|  \_\\_____|
"------------------------------------------------------------------------------
                                      
                                      

"SETUP-------------------------------------------------------------------------

call plug#begin('~/.vim/plugged')

" set leader
" https://medium.com/usevim/vim-101-what-is-the-leader-key-f2f5c1fa610f
let mapleader=","
Plug 'tpope/vim-sensible'

"------------------------------------------------------------------------------



"SEARCH-----------------------------------------------------------------------

set incsearch           " search as characters are entered
set hlsearch            " highlight matches
nnoremap <leader><space> :nohlsearch<CR>

" Search for text
Plug 'mileszs/ack.vim'
" Search text
" https://www.freecodecamp.org/news/how-to-search-project-wide-vim-ripgrep-ack/
let g:ackprg = 'rg --vimgrep --type-not sql --smart-case'
" Auto close the Quickfix list after pressing '<enter>' on a list item
let g:ack_autoclose = 1
" Any empty ack search will search for the work the cursor is on
let g:ack_use_cword_for_empty_search = 1
" Don't jump to first match
cnoreabbrev Ack Ack!
" Maps <leader>/ so we're ready to type the search keyword
nnoremap <Leader>/ :Ack!<Space>

" Search for files uzing fuzzy search
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

" Gutentags to quickly find definitions and references
Plug 'ludovicchabant/vim-gutentags'
" Tags
" https://ricostacruz.com/til/navigate-code-with-ctags
" https://andrew.stwrt.ca/posts/vim-ctags/#fnref:1
" To jump to definition instead of first occurrence: https://stackoverflow.com/questions/1054701/get-ctags-in-vim-to-go-to-definition-not-declaration
" nnoremap <leader>ct :!ctags -R -f ./.git/tags .<CR>
" set tags=./tags;/       " look in the current directory for "tags", and work up the tree towards root until one is found. https://stackoverflow.com/questions/563616/vim-and-ctags-tips-and-tricks
set statusline+=%{gutentags#statusline()}

"------------------------------------------------------------------------------


"PROSE------------------------------------------------------------------------

" Words wrap nicely (you choose hard or soft wrapping or choose nothing if you don’t care) & the cursor skips through lines not paragraphs.
Plug 'reedes/vim-pencil' 
" Distraction free writing https://www.bfoliver.com/2014/12/06/vimforprose/
Plug 'junegunn/goyo.vim'
nnoremap <leader>sp :set spell spelllang=en_us<cr>
Plug 'JamshedVesuna/vim-markdown-preview' " When in a markdown press Ctrl-p is pressed, this plugin will either open a preview in your browser



"APPEARANCE--------------------------------------------------------------------

syntax enable           " enable syntax highlighting
set encoding=UTF-8
set number              " show line numbers
set cursorline          " highlight current line
set relativenumber      " relative line numbers
set showcmd             " show (partial) command in status line
set ruler               " show line and column number
set showmatch           " highlight matching [{()}]

" Folding http://vim.wikia.com/wiki/Folding
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
" space open/closes folds
nnoremap <space> za
set foldmethod=indent   " fold based on indent level

" Informative status line
Plug 'vim-airline/vim-airline'         
Plug 'ryanoasis/vim-devicons'  

"------------------------------------------------------------------------------



"TEXT MANIPULATION-------------------------------------------------------------
" PEP 8 friendly formatting
" http://henry.precheur.org/vim/python.html
set tabstop=4           " number of visual spaces per TAB
set softtabstop=4       " number of spaces in tab when editing
set expandtab           " tabs are spaces
set shiftwidth=4        " number of spaces for auto indent
set autoindent          " new line tab mirrors that of previous line
set backspace=indent,eol,start 

"------------------------------------------------------------------------------



"NAVIGATION--------------------------------------------------------------------
"
" move vertically by visual line
" nnoremap j gj
" nnoremap k gk
" highlight last inserted text
nnoremap gV `[v`]

" Nerd Tree
Plug 'scrooloose/nerdtree'
map <C-n> :NERDTreeToggle<CR> " Opens nerdtree with control+n

Plug 'christoomey/vim-tmux-navigator'
" Operate on parentheses, brackets, quotes, XML tags, and more
Plug 'tpope/vim-surround'       
Plug 'tpope/vim-repeat'         " Extends '.' repeat operator to other plugins
"
"------------------------------------------------------------------------------



"OTHER-------------------------------------------------------------------------
"
" Easily edit vimrc and source it to effect changes
" https://learnvimscriptthehardway.stevelosh.com/chapters/07.html
nnoremap <leader>ev :split $MYVIMRC<cr>
" Sets source to vim, installs any new plugins, and quits the status bar
nnoremap <leader>sv :source $MYVIMRC<cr> <bar> :PlugInstall<cr>
set clipboard=unnamed   " copy to global clipboard
nmap - :res<CR>:vertical res<CR>$
filetype indent on      " load filetype-specific indent files
set wildmenu            " visual autocomplete for command menu
set lazyredraw          " redraw only when we need to.
" Navigate quickfix list with ease
nnoremap <silent> [q :cprevious<CR>
nnoremap <silent> ]q :cnext<CR>

"------------------------------------------------------------------------------
call plug#end()
