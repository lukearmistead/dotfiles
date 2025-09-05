# ============================================================================
# ZSH Configuration
# ============================================================================

# --------------------------------------------------------------------------
# Zsh Options
# --------------------------------------------------------------------------

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits
setopt SHARE_HISTORY             # Share history between all sessions
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file
setopt HIST_VERIFY                # Do not execute immediately upon history expansion

# Directory navigation
setopt AUTO_CD                   # Go to folder path without using cd
setopt AUTO_PUSHD                # Push the old directory onto the stack on cd
setopt PUSHD_IGNORE_DUPS         # Do not store duplicates in the stack
setopt PUSHD_SILENT              # Do not print the directory stack after pushd or popd
setopt CORRECT                   # Spelling correction
setopt CDABLE_VARS               # Change directory to a path stored in a variable
setopt EXTENDED_GLOB             # Use extended globbing syntax

# --------------------------------------------------------------------------
# Environment Variables
# --------------------------------------------------------------------------

# Set default editor
export EDITOR='vim'
export VISUAL='vim'

# Language
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

# Path configuration
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/bin:$PATH"

# Homebrew (Apple Silicon)
if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Homebrew (Intel)
if [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Man pages
export MANPAGER="less -X"

# Less configuration
export LESS='-R'
export LESSHISTFILE=-  # Disable less history

# --------------------------------------------------------------------------
# Completions
# --------------------------------------------------------------------------

# Initialize completion system
autoload -Uz compinit
compinit

# Completion options
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # Case-insensitive completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"  # Colored completion
zstyle ':completion:*' menu select  # Menu selection
zstyle ':completion:*' special-dirs true  # Complete . and .. special directories
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# --------------------------------------------------------------------------
# Key Bindings
# --------------------------------------------------------------------------

# Use emacs key bindings (or switch to 'bindkey -v' for vim bindings)
bindkey -e

# History search
bindkey '^[[A' history-search-backward  # Up arrow
bindkey '^[[B' history-search-forward   # Down arrow
bindkey '^R' history-incremental-search-backward  # Ctrl+R

# Word movement (Option+Left/Right on Mac)
bindkey '^[[1;3C' forward-word
bindkey '^[[1;3D' backward-word

# Home/End keys
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

# Delete key
bindkey '^[[3~' delete-char

# --------------------------------------------------------------------------
# Prompt
# --------------------------------------------------------------------------

# Load colors
autoload -Uz colors
colors

# Simple, informative prompt
# Customize this to your liking
PROMPT='%F{green}%n@%m%f:%F{blue}%~%f$ '

# Git prompt (optional - uncomment if you want git info in prompt)
# autoload -Uz vcs_info
# precmd() { vcs_info }
# zstyle ':vcs_info:git:*' formats '%F{yellow}(%b)%f '
# setopt PROMPT_SUBST
# PROMPT='%F{green}%n@%m%f:%F{blue}%~%f ${vcs_info_msg_0_}$ '

# --------------------------------------------------------------------------
# Aliases
# --------------------------------------------------------------------------

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# List directory contents
alias ls='ls --color=auto'
alias l='ls -lFh'
alias la='ls -lAFh'
alias ll='ls -l'
alias lt='ls -ltr'
alias ld='ls -ld */'

# Safety nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'

# Shortcuts
alias h='history'
alias j='jobs -l'
alias which='type -a'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowdate='date +"%Y-%m-%d"'

# Git shortcuts
alias g='git'
alias gs='git status'
alias gc='git commit'
alias ga='git add'
alias gd='git diff'
alias gb='git branch'
alias gl='git log --oneline --graph --decorate'
alias gco='git checkout'
alias gp='git push'
alias gpu='git pull'

# Dotfiles management
alias dotfiles='/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME'

# Editor shortcuts
alias v='vim'
alias vi='vim'

# macOS specific
if [[ "$OSTYPE" == "darwin"* ]]; then
    alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
    alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'
    alias flushdns='dscacheutil -flushcache'
    alias afk='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'
fi

# Colorize grep output
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Process management
alias psg='ps aux | grep -v grep | grep -i'
alias topmem='ps aux | sort -nk 4 | tail -10'
alias topcpu='ps aux | sort -nk 3 | tail -10'

# Network
alias myip='curl -s https://ipinfo.io/ip'
alias localip='ipconfig getifaddr en0'
alias ports='netstat -tulanp'

# Development
alias python='python3'
alias pip='pip3'
alias serve='python3 -m http.server'

# --------------------------------------------------------------------------
# Functions
# --------------------------------------------------------------------------

# Create directory and cd into it
mkd() {
    mkdir -p "$@" && cd "$_"
}

# Change to project directory
proj() {
    cd ~/Developer/projects/"$1"
}

# Extract archives
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"   ;;
            *.tar.gz)    tar xzf "$1"   ;;
            *.bz2)       bunzip2 "$1"   ;;
            *.rar)       unrar x "$1"   ;;
            *.gz)        gunzip "$1"    ;;
            *.tar)       tar xf "$1"    ;;
            *.tbz2)      tar xjf "$1"   ;;
            *.tgz)       tar xzf "$1"   ;;
            *.zip)       unzip "$1"     ;;
            *.Z)         uncompress "$1";;
            *.7z)        7z x "$1"      ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Find file by name
ff() {
    find . -type f -iname "*$1*"
}

# Find directory by name
fd() {
    find . -type d -iname "*$1*"
}

# Quick backup
backup() {
    cp "$1" "$1.backup-$(date +%Y%m%d-%H%M%S)"
}

# Weather
weather() {
    curl -s "wttr.in/${1:-}"
}

# Cheatsheet
cheat() {
    curl -s "cheat.sh/$1"
}

# --------------------------------------------------------------------------
# Development Tools
# --------------------------------------------------------------------------

# Python (pyenv)
if command -v pyenv 1>/dev/null 2>&1; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    
    # pyenv-virtualenv
    if command -v pyenv-virtualenv-init 1>/dev/null 2>&1; then
        eval "$(pyenv virtualenv-init -)"
    fi
fi

# Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Ruby Version Manager
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# Rust
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# --------------------------------------------------------------------------
# Tool Integrations
# --------------------------------------------------------------------------

# fzf - Fuzzy Finder
if [[ -f ~/.fzf.zsh ]]; then
    source ~/.fzf.zsh
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
    
    # Use ripgrep for fzf if available
    if command -v rg 1>/dev/null 2>&1; then
        export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    fi
fi

# zoxide - Better cd
if command -v zoxide 1>/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
    alias cd='z'
fi

# direnv - Directory-specific environment variables
if command -v direnv 1>/dev/null 2>&1; then
    eval "$(direnv hook zsh)"
fi

# GitHub CLI completion
if command -v gh 1>/dev/null 2>&1; then
    eval "$(gh completion -s zsh)"
fi

# --------------------------------------------------------------------------
# Local Configuration
# --------------------------------------------------------------------------

# Source local configuration if it exists
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# --------------------------------------------------------------------------
# Welcome Message
# --------------------------------------------------------------------------

# Display system info on new shell (optional - comment out if you don't want it)
if command -v fastfetch 1>/dev/null 2>&1; then
    fastfetch
elif command -v neofetch 1>/dev/null 2>&1; then
    neofetch
else
    echo "Welcome to $(hostname)"
    echo "Today is $(date)"
fi
