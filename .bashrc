# Connects to remote dotfiles repo
alias dotfiles='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
alias rc='vim ~/.bashrc'
set -o vi

# Omada dotfiles and secrets
export DFS_AUTO_UPDATE=1
source "$HOME/workspace/dotfiles/dotfiles.sh"
source "$HOME/.data_eng_secrets"

# SQLFluff

# Aliases and exports
export PATH=/opt/homebrew/bin:$PATH
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export MYVIMRC="~/.vimrc"
alias k="knowledge_repo"
export KNOWLEDGE_REPO=~/workspace/science
alias serverless-sandbox="serverless deploy --aws-profile sandbox --stage sandbox --verbose"
alias w="curl http://wttr.in/Tahoe+City?format=3"
alias jl='jupyter lab'
alias sp='brew services restart spotifyd; spt;'
alias h2='how2 -l python'
export PATH=$PATH:/usr/local/opt/imagemagick@6/bin

# gcalcli https://github.com/insanum/gcalcli
alias gcal='gcalcli --calendar Work#white --calendar Personal#green'
alias agenda='gcalcli --calendar Work#white --calendar Personal#green agenda'
alias week='gcalcli --calendar Work#white --calendar Personal#green calw'
alias month='gcalcli --calendar Work#white --calendar Personal#green calm'

# searching file contents with grep
# https://alligator.io/workflow/command-line-basics-searching-file-contents/

quick_text_note() {
  NOTEDIRECTORY="$HOME/workspace/notes/"
  DATE=$(date + "%Y-%m-%d-")
  TITLE=$1
  EXT=".md"
  vim ${NOTEDIRECTORY}${DATE}${TITLE}${EXT}
}
alias n=quick_text_note

# Links to dropbox notes directory
ln -s $HOME/Dropbox/notes/ $HOME/

convert_markdown_to_office_file_type() {
    # Converts filetypes and outputs to Desktop
    MARKDOWN_INPUT_PATH=$1
    FILENAME=$(basename "${MARKDOWN_INPUT_PATH}" .md)
    OFFICE_OUTPUT_DIR="$HOME/Desktop/"
    OFFICE_OUTPUT_PATH="${OFFICE_OUTPUT_DIR}${FILENAME}".odt
    OFFICE_STYLE_FORMAT_PATH="$HOME/.pandoc/custom-reference.odt"
    pandoc ${MARKDOWN_INPUT_PATH} --from markdown --to odt --output ${OFFICE_OUTPUT_PATH} --reference-doc ${OFFICE_STYLE_FORMAT_PATH} --verbose
}
alias office=convert_markdown_to_office_file_type

quick_email_to_self() {
  SUBJECT=$1
  EMAIL="armistead.luke@gmail.com"
  mutt -s "$SUBJECT" ${EMAIL} < /dev/null
}
alias e=quick_email_to_self

# Find
search_non_dotfiles_in_this_directory() {
  SEARCH_KEYWORD=$1
  find . "$SEARCH_KEYWORD" -not -path '*/\.*'
}
alias f=search_non_dotfiles_in_this_directory

# Enables not logging in for 
export GPG_AGENT_INFO=$HOME/.gnupg/S.gpg-agent

# Opens todo file
alias td='vim $HOME/workspace/log/todo.txt'

# Gets today's date
alias dt='date  +"%Y-%m-%d"'

# Suppress bash deprecation warning
# https://www.loekvandenouweland.com/content/the-default-interactive-shell-is-now-zsh.html
export BASH_SILENCE_DEPRECATION_WARNING=1


# Autojump https://github.com/wting/autojump
[ -f $(brew --prefix)/etc/profile.d/autojump.sh ] && . $(brew --prefix)/etc/profile.d/autojump.sh


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
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ;} history -a"


# Get Vault token Default to infra environment (not staging or prod)
alias vault_stag_addr='export VAULT_ADDR=https://vault.staging.omadahealth.net'
alias vault_infra_addr='export VAULT_ADDR=https://vault.infra.omadahealth.net'
alias vault_prod_addr='export VAULT_ADDR=https://vault.prod.omadahealth.net'


# Source
# https://sanctum.geek.nz/arabesque/better-bash-history/

 
# Git aliases & functions
# https://jonsuh.com/blog/git-command-line-shortcuts/
alias ga='git add'
alias gaa='git add .'
alias gaaa='git add --all'
alias gau='git add --update'
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit" # https://coderwall.com/p/euwpig/a-better-git-log
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
alias gcor='git checkout --track' # https://stackoverflow.com/questions/9537392/git-fetch-remote-branch
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
alias g^='git push origin HEAD'
alias gr='git rebase'
alias gri='git rebase --interactive'
alias gst='git status'
alias gss='git status --short'
# alias gst='git stash'
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


# Pyenv stuff
# Primary source: https://medium.com/@henriquebastos/the-definitive-guide-to-setup-my-python-workspace-628d68552e14
# Connect to jupyter https://albertauyeung.github.io/2020/08/17/pyenv-jupyter.html
alias sci='pyenv activate science'
alias kno='pyenv activate kno'
export WORKON_HOME=~/.ve
export PROJECT_HOME=~/workspace

export PYENV_ROOT="$HOME/.pyenv"
# export PIPENV_PYTHON=$PYENV_ROOT/shims/python
export PATH="$PYENV_ROOT/bin:$PATH" 
eval "$(pyenv init -)" # May need to contain `--path` flag following 2021 update of pyenv package https://stackoverflow.com/a/68228627/4447670
eval "$(pyenv virtualenv-init -)"

#pyenv virtualenvwrapper_lazy
# Don't forget to run this to make the pyenv env available to jupyter `ipython kernel install --name py3`
# https://stackoverflow.com/questions/36382508/packages-from-conda-env-not-found-in-jupyer-notebook/36395096#36395096

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/luke.armistead/Downloads/google-cloud-sdk/path.bash.inc' ]; then . '/Users/luke.armistead/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/luke.armistead/Downloads/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/luke.armistead/Downloads/google-cloud-sdk/completion.bash.inc'; fi
