" TODO
" autocomplete

" Colors
syntax enable           " enable syntax processing

" Dealing with tabs
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set expandtab       " tabs are spaces
" PEP 8 friendly stuff: http://henry.precheur.org/vim/python.html
set shiftwidth=4    " number of spaces for auto indent
" set textwidth=80    " breaks lines at 80 characters
set autoindent      " new line tab mirrors that of previous line
set backspace=indent,eol,start 

" UI
" copy to global clipboard
set clipboard=unnamed

set number              " show line numbers
set cursorline          " highlight current line
filetype indent on      " load filetype-specific indent files
set wildmenu            " visual autocomplete for command menu
set lazyredraw          " redraw only when we need to.
set showmatch           " highlight matching [{()}]
set relativenumber      " relative line numbers
set number              " current line is absolute number 
set ruler               " show line and column number
set showcmd             " show (partial) command in status line


" Searching
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
nnoremap <leader><space> :nohlsearch<CR>

" Tags
" https://ricostacruz.com/til/navigate-code-with-ctags
" https://andrew.stwrt.ca/posts/vim-ctags/#fnref:1
" To jump to definition instead of first occurrence: https://stackoverflow.com/questions/1054701/get-ctags-in-vim-to-go-to-definition-not-declaration
"
" nnoremap <leader>ct :!ctags -R -f ./.git/tags .<CR>
" set tags=./tags;/       " look in the current directory for "tags", and work up the tree towards root until one is found. https://stackoverflow.com/questions/563616/vim-and-ctags-tips-and-tricks
set statusline+=%{gutentags#statusline()}

" Folding http://vim.wikia.com/wiki/Folding
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
" space open/closes folds
nnoremap <space> za
set foldmethod=indent   " fold based on indent level

" Movement
" move vertically by visual line
nnoremap j gj
nnoremap k gk
" move to beginning/end of line
nnoremap B ^
nnoremap E $
" highlight last inserted text
nnoremap gV `[v`]

" Map keys
" set leader: https://medium.com/usevim/vim-101-what-is-the-leader-key-f2f5c1fa610f
let mapleader=","
vmap <space> viw " Space selects word

" Easily edit vimrc and source it to effect changes
" https://learnvimscriptthehardway.stevelosh.com/chapters/07.html
nnoremap <leader>ev :split $MYVIMRC<cr>
" Sets source to vim, installs any new plugins, and quits the status bar
nnoremap <leader>sv :source $MYVIMRC<cr> <bar> :PlugInstall<cr>

" Switch from esc to jk
" https://learnvimscriptthehardway.stevelosh.com/chapters/10.html
" inoremap jk <esc>
" inoremap <esc> <nop>

" Plugins 

" Opens nerdtree
map <C-n> :NERDTreeToggle<CR>

" Calls Fuzzy finder https://jesseleite.com/posts/2/its-dangerous-to-vim-alone-take-fzf
" All files 
nmap <Leader>f :Files<CR>
" Lines in current buffer
nmap <Leader>l :BLines<CR>         
" Lines in loaded buffers
nmap <Leader>L :Lines<CR>
" Search for projects"Calls MRU
nmap <Leader>/ :Ag<Space>
" Opens MRU 
nmap <Leader>r :MRU<CR> 



call plug#begin('~/.vim/plugged')
"NERDTree file tree
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-sensible'
Plug 'christoomey/vim-tmux-navigator'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'yegappan/mru'
Plug 'ludovicchabant/vim-gutentags'
" Initialize plugin system
call plug#end()
" Make sure you use single quotes

