"                     __      ___           _____   _____
"                     \ \    / (_)         |  __ \ / ____|
"                      \ \  / / _ _ __ ___ | |__) | |
"                       \ \/ / | | '_ ` _ \|  _  /| |
"                        \  /  | | | | | | | | \ \| |____
"                         \/   |_|_| |_| |_|_|  \_\\_____|


" TOC
" 1. SETUP
" 2. SEARCH
" 3. CODE
" 4. PROSE
" 5. NAVIGATION
" 6. OTHER
" 7. RESOURCES

" ===========
" 1. SETUP
" ===========

" Removes compatabilities with vi which can cause issues
set nocompatible

" Initialize plugin manager
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" set leader
" https://medium.com/usevim/vim-101-what-is-the-leader-key-f2f5c1fa610f
nnoremap <SPACE> <Nop>
let mapleader = " "

" Plug 'NLKNguyen/papercolor-theme'
" set background=light

" Establish sensible defaults
" Plug 'tpope/vim-sensible'

" ============
" 2. SEARCH
" ============

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

" All files except dotfiles and other cruft
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --glob "!**/__pycache__/*" --glob "!**/*.swp" --glob "!**/*.swo" --glob "!**/.git/*" --glob "!**/.*"'

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
nmap <Leader>rr :MRU<CR> 

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

" ===========
" 3. CODE
" ===========

" ------------------------------------------------
" AUTOCOMPLETION
" Built in autocompletion 
" <C-x><C-n> - Simple word completion `<C-p>` goes back
" <C-x><C-]> - Complete tag
" <C-x><C-o> - language-aware completion
" https://www.reddit.com/r/vim/comments/jh0vjt/vim_autocomplete_for_python_2020/

" Augments autocompletion and reference lookup for python
" Usage: https://github.com/davidhalter/jedi-vim#features
Plug 'davidhalter/jedi-vim', { 'for': 'python' }
" Keymap ("" indicates no mapping)
let g:jedi#goto_command = '<leader>d'
let g:jedi#goto_assignments_command = '<leader>g'
let g:jedi#documentation_command = 'K'
let g:jedi#usages_command = '<leader>n'
let g:jedi#completions_command = '<C-Space>'
let g:jedi#rename_command = '<leader>r'
let g:jedi#goto_stubs_command = ''
let g:jedi#goto_definitions_command = ''
let g:jedi#rename_command_keep_name = ''
" Disables autocomplete following a dot, which is expensive
let g:jedi#popup_on_dot = 0
" ------------------------------------------------

" Copilot
" :help Copilot for mappings
Plug 'github/copilot.vim', { 'for': ['python', 'sql'] }
inoremap <C-j> <Plug>(copilot-next)
inoremap <C-k> <Plug>(copilot-previous)
inoremap <C-\> <Plug>(copilot-suggest)

" Comment out line with `gcc` or motion target with `gc`
Plug 'tpope/vim-commentary'

" Access git with `:G` or `:Git`
Plug 'tpope/vim-fugitive'

" (r)un python (f)ile from vim
" https://stackoverflow.com/questions/18948491/running-python-code-in-vim
nmap <Leader>rf :! clear; python %<CR>

" Go to "c"ommand line from vim
" running `fg` from terminal pulls vim back into foreground
" c-z accomplishes this out of the box actually
" https://towardsdatascience.com/getting-started-with-vim-and-tmux-for-python-707ec5ff747f
" https://www.reddit.com/r/vim/comments/10fboc6/how_do_you_guys_run_the_code_you_write_with_vim/
nnoremap <leader>c :stop<CR>

" Interactive debugging
" Requires `ipdb` python package
" https://towardsdatascience.com/getting-started-with-vim-and-tmux-for-python-707ec5ff747f
nmap <buffer> <leader>b oimport ipdb;ipdb.set_trace(context=5)<ESC>

" Run python interactively from vim
" <c-c><c-c> Send the current paragraph text to another tmux pane
" Ipython Cell instructions https://github.com/hanschen/vim-ipython-cell?tab=readme-ov-file#example-vim-configuration
" Source: https://stackoverflow.com/questions/64923693/running-python-code-interactively-from-vim
Plug 'jpalardy/vim-slime', { 'for': 'python' } 
Plug 'hanschen/vim-ipython-cell', { 'for': 'python' }
let g:slime_target = "tmux"
let g:slime_default_config = {
            \ 'socket_name': get(split($TMUX, ','), 0),
            \ 'target_pane': '{bottom}' }
let g:slime_python_ipython = 1
let g:slime_dont_ask_default = 1
" filetype plugin on
nnoremap <Leader>j :IPythonCellExecuteCell<CR>
" Removes ## tag to account for markdown text
" https://github.com/hanschen/vim-ipython-cell/blob/master/README.md#use-the-percent-format
let g:ipython_cell_regex = 1
let g:ipython_cell_tag = '# %%( [^[].*)?'

" Tests
Plug 'vim-test/vim-test'
Plug 'preservim/vimux'
let test#python#runner = 'pytest'
let test#strategy = "vimux"
nnoremap <leader>t :TestNearest<CR>
nnoremap <leader>T :TestFile<CR>

" Show marks TODO
" Plug 'kshenoy/vim-signature', { 'for': 'python' }
" highlight SignatureMarkText guifg=Black ctermfg=Black

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
Plug 'vim-airline/vim-airline', { 'for': 'python' }

" Pretty icons for interface
Plug 'ryanoasis/vim-devicons', { 'for': 'python' }

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


" SQL rig
function! ConfigureForSQL()
  set tabstop=2 
  set softtabstop=2 
  set shiftwidth=2
endfunction

autocmd FileType sql call ConfigureForSQL()



" ------------------------------------------------

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

" ===========
" 4. PROSE
" ===========
" https://www.bfoliver.com/2014/12/06/vimforprose/
" https://wynnnetherland.com/journal/reed-esau-s-growing-list-of-vim-plugins-for-writers/

" Distraction free writing 
" `:Goyo` and `:Goyo!` enable and disable Goyo, respectively
Plug 'junegunn/goyo.vim' " Can't selectively install and still run `ConfigureForProse`

" Color name (:help cterm-colors) or ANSI code
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240

function! ConfigureForProse()
  set linebreak " set wrap
  set nocursorline " Drop cursor line
  " set spell spelllang=en_us " Add spellcheck
  highlight LineNr ctermfg=darkgrey
  highlight CursorLineNr ctermfg=darkgrey
  highlight EndOfBuffer ctermfg=black ctermbg=black
  set foldmethod=manual
  set tabstop=2 " 2 space tabs
  set softtabstop=2 
  set shiftwidth=2
  syntax off

  " Move by visual line
  nnoremap j gj
  nnoremap k gk
  nnoremap 0 g0
  nnoremap ^ g^
  nnoremap $ g$

  " Packages
  Goyo
endfunction

" Make easy to call
nnoremap <leader>p :call ConfigureForProse()<CR> 
command! ConfigureForProse call ConfigureForProse()

" Automatically initialize buffer by file type
" autocmd FileType markdown,mkd,md,text call ConfigureForProse()
"

" ================
" 5. NAVIGATION
" ================

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

" Nerdtree sees dotfiles
let NERDTreeShowHidden=1

" Opens nerdtree with control+n
nnoremap <C-n> :NERDTreeToggle<CR> 

" Opens nerdtree expanded to current file
nnoremap <leader>n :NERDTreeFind<CR> 

" Refresh automatically when focusing the NERDTree window
autocmd BufEnter NERD_tree_* | execute 'normal R'


" Navigate between vim and tmux splits using consistent hotkeys
Plug 'christoomey/vim-tmux-navigator'

" Operate on parentheses, brackets, quotes, XML tags, and more
Plug 'tpope/vim-surround'

" Extends '.' repeat operator to other plugins
Plug 'tpope/vim-repeat'


" ===========
" 6. OTHER
" ===========

" ---------------------------------------------------------------
" EDIT VIMRC
" https://learnvimscriptthehardway.stevelosh.com/chapters/07.html
" ---------------------------------------------------------------

" Easily edit vimrc and source it to effect changes
nnoremap <leader>ev :tab split $MYVIMRC<cr>

" Sets source to vim, installs any new plugins, and quits the status bar
nnoremap <leader>sv :source $MYVIMRC<cr> <bar> :PlugInstall<cr> :PlugClean<cr>
nnoremap <leader>uv :source $MYVIMRC<cr> :PlugUpdate<cr>


" By default timeoutlen is 1000 ms
set timeoutlen=500
set ttimeoutlen=0

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

" ===============
" 7. RESOURCES
" ===============

" How to Do 90% of What Plugins Do (With Just Vim)
" https://www.youtube.com/watch?v=XA2WjJbmmoM&ab_channel=thoughtbot

" Most complete Vim cheatsheet
" https://github.com/ibhagwan/vim-cheatsheet
