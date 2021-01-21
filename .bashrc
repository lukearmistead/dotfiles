# Connects to remote dotfiles repo
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Aliases and exports
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export MYVIMRC="~/.vimrc"
alias k="knowledge_repo"
export KNOWLEDGE_REPO=~/workspace/science
alias w="curl wttr.in"


# Suppress bash deprecation warning
# https://www.loekvandenouweland.com/content/the-default-interactive-shell-is-now-zsh.html
export BASH_SILENCE_DEPRECATION_WARNING=1

# Bash auto-completion
# https://sourabhbajaj.com/mac-setup/BashCompletion/
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
# Autojump
# https://github.com/wting/autojump
[ -f $(brew --prefix)/etc/profile.d/autojump.sh ] && . $(brew --prefix)/etc/profile.d/autojump.sh


# Command line prompt formatting
# https://thucnc.medium.com/how-to-show-current-git-branch-with-colors-in-bash-prompt-380d05a24745
# parse_git_branch() {
#     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
# }
# export PS1="\[\e[32m\]\w \[\e[91m\]\$(parse_git_branch)\[\e[00m\] ∆ "

# Set the default editor to vim.
export EDITOR=vim
alias v="vim"
# Increases history file size
HISTFILESIZE=10000000
HISTSIZE=10000000


# History ignores duplicates, ls's, and commands that start with a space 
HISTCONTROL=ignoreboth
HISTIGNORE='ls:bg:fg:history'

# Append commands to the bash command history file (~/.bash_history)
# instead of overwriting it.
shopt -s histappend

# Store history immediately
PROMPT_COMMAND='history -a'

# Pyenv stuff: https://medium.com/@henriquebastos/the-definitive-guide-to-setup-my-python-workspace-628d68552e14
export WORKON_HOME=~/.ve
export PROJECT_HOME=~/workspace
eval "$(pyenv init -)"
export PIPENV_PYTHON=$PYENV_ROOT/shims/python
#pyenv virtualenvwrapper_lazy

# Get Vault token
# Default to infra environment (not staging or prod)

alias vault_stag_addr='export VAULT_ADDR=https://vault.staging.omadahealth.net'
alias vault_infra_addr='export VAULT_ADDR=https://vault.infra.omadahealth.net'
alias vault_prod_addr='export VAULT_ADDR=https://vault.prod.omadahealth.net'


# Source
# https://sanctum.geek.nz/arabesque/better-bash-history/
# http://stefaanlippens.net/my_bashrc_aliases_profile_and_other_stuff/

alias py3='pyenv activate py3'
alias kno='pyenv activate kno'
alias jl='jupyter lab'
export PYENV_ROOT=/usr/local/var/pyenv
 
# Git aliases & functions
# https://jonsuh.com/blog/git-command-line-shortcuts/
alias ga='git add'
alias gaa='git add .'
alias gaaa='git add --all'
alias gau='git add --update'
alias gb='git branch'
alias gbd='git branch --delete '
alias gc='git commit'
alias gcm='git commit --message'
alias gcf='git commit --fixup'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcom='git checkout main'
alias gcos='git checkout staging'
alias gcod='git checkout develop'
alias gd='git diff'
alias gda='git diff HEAD'
alias gi='git init'
alias glg='git log --graph --oneline --decorate --all'
alias gld='git log --pretty=format:"%h %ad %s" --date=short --all'
alias gm='git merge --no-ff'
alias gma='git merge --abort'
alias gmc='git merge --continue'
alias gp='git pull'
alias gv='git pull --rebase'
alias g^='git push origin'
alias gr='git rebase'
alias gri='git rebase --interactive'
alias gs='git status'
alias gss='git status --short'
alias gst='git stash'
alias gsta='git stash apply'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash save'
# Git log find by commit message
function glf() { git log --all --grep="$1"; }

# Bash aliases
alias ....="cd ../../.."
alias ...="cd ../.."
alias ..="cd .."
alias l='ls -al'
alias ll='ls -l'

# Use Starship to customize prompt
# Based on this guide https://towardsdatascience.com/the-ultimate-guide-to-your-terminal-makeover-e11f9b87ac99
# And some tips borrowed from this one: https://medium.com/@Clovis_app/configuration-of-a-beautiful-efficient-terminal-and-prompt-on-osx-in-7-minutes-827c29391961
eval "$(starship init bash)"
