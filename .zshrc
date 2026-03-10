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
export EDITOR='nvim'
export VISUAL='nvim'

# Language
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

# Path configuration
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/bin:$PATH"

# Homebrew
if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Personal environment
export HOMEBREW_AUTO_UPDATE_SECS=604800
export GPG_AGENT_INFO=$HOME/.gnupg/S.gpg-agent
export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/bin:$PATH"

# Man pages
export MANPAGER="less -X"

# Less configuration
export LESS='-R'
export LESSHISTFILE=-  # Disable less history

# --------------------------------------------------------------------------
# Completions
# --------------------------------------------------------------------------

# Initialize completion system (rebuild cache once daily)
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# Completion options
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # Case-insensitive completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"  # Colored completion
zstyle ':completion:*' menu select  # Menu selection
zstyle ':completion:*' special-dirs true  # Complete . and .. special directories
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# --------------------------------------------------------------------------
# Key Bindings
# --------------------------------------------------------------------------

# Vi key bindings
bindkey -v

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
# Aliases
# --------------------------------------------------------------------------

# List directory contents
alias ls='ls -AG'
alias ll='ls -lA'

# Safety nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'

# Shortcuts
alias which='type -a'

# Git shortcuts
alias g='git'
alias gst='git status'
alias gc='git commit'
alias gcm='git commit --message'
alias gfa='git commit --fixup'
alias ga='git add'
alias gd='git diff'
alias gb='git branch'
alias gl='git log --oneline --graph --decorate'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcom='git checkout main'
alias 'g^'='git push origin HEAD'
alias gv='git pull --rebase'
alias gm='git merge --no-ff'
alias gma='git merge --abort'
alias gmc='git merge --continue'
alias gr='git rebase'
alias gri='git rebase --interactive'
alias gsta='git stash apply'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'

# Dotfiles management
alias dotfiles='/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME'

# Personal shortcuts
alias n='notes'
alias v='nvim'
alias vi='nvim'

# macOS specific
if [[ "$OSTYPE" == "darwin"* ]]; then
    alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
    alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'
    alias flushdns='dscacheutil -flushcache'
    alias afk='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'
fi

# Network
alias myip='curl -s https://ipinfo.io/ip'
alias localip='ipconfig getifaddr en0'

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
    alias j='z'
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

# Symlink notes directory
[[ ! -L "$HOME/dev/notes" ]] && ln -s "$HOME/Dropbox/notes/" "$HOME/dev/notes/"

# Source local configuration if it exists
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

alias claude="/Users/luke/.claude/local/claude"

# Starship prompt (must be last)
eval "$(starship init zsh)"

