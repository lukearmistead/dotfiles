# Connects to dotfiles
source "$HOME/workspace/dotfiles/dotfiles.sh"
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Aliases and exports
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export MYVIMRC="~/.vimrc"
alias k="knowledge_repo"
export KNOWLEDGE_REPO=~/workspace/science
alias w="curl wttr.in"

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

# alias vstag="export VAULT_TOKEN=$(vault login -address=$vault_stag_addr -method=oidc 2>/dev/null | grep -E 'token +s' | rev | cut -d ' ' -f 1 | rev)"
# alias vinfra=" export VAULT_TOKEN=$(vault login -address=$vault_infra_addr -method=oidc 2>/dev/null | grep -E 'token +s' | rev | cut -d ' ' -f 1 | rev)"
# alias vprod="export VAULT_TOKEN=$(vault login -address=$vault_prod_addr -method=oidc 2>/dev/null | grep -E 'token +s' | rev | cut -d ' ' -f 1 | rev)"

# Source
# https://sanctum.geek.nz/arabesque/better-bash-history/
# http://stefaanlippens.net/my_bashrc_aliases_profile_and_other_stuff/

alias py3='pyenv activate py37'
alias py2='pyenv activate py2'
alias jl='jupyter lab'
export PYENV_ROOT=/usr/local/var/pyenv

# http://akbaribrahim.com/managing-multiple-python-versions-with-pyenv/
# if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
source /path/to/git-subrepo/.rc
alias logos='$(pwd)'/logos/scripts/lazy.sh $@
alias logos='$(pwd)'/logos/scripts/lazy.sh $@
alias logos='$(pwd)'/logos/scripts/lazy.sh $@
