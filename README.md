# Dotfiles

Rapidly setup new laptops just-so [with a bare git repo](https://www.atlassian.com/git/tutorials/dotfiles). ✨

```bash
# Clone dotfiles as a bare repo
git clone --bare https://github.com/lukearmistead/dotfiles.git $HOME/dotfiles`

# Define alias to interact with configuration repo
alias dotfiles='/usr/bin/git --git-dir=$HOME/ --work-tree=$HOME'

# Remove clutter of untracked files
dotfiles config --local status.showUntrackedFiles no

# Checkout the actual content from the bare repository to your `$HOME`
dotfiles checkout
```
    
[Install all applications with Hombrew](https://cpojer.net/posts/set-up-a-new-mac-fast)



1. [Install Homebrew's website](https://brew.sh/)
1. If you're using Apple silicon, [make sure that homebrew is in your `PATH`](https://stackoverflow.com/a/68494567): `export PATH=/opt/homebrew/bin:$PATH`
1. Install applications by running `brew bundle` from `$HOME` directory

Outfit Vim & Tmux



```bash
# Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

1. Open the `.vimrc` with `<space> ev` and download all plugins with `<space> sv`
1. Install all tmux plugins with `<leader> I`

Setup Git

1. [Write your global config](https://kbroman.org/github_tutorial/pages/first_time.html)
```
git config --global user.name "First Last"
git config --global user.email "username@provider.com"
git config --global color.ui true
git config --global core.editor vim
```
1. Generate ssh keys to access [GitHub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) and [Gitlab](https://docs.gitlab.com/ee/user/ssh.html#generate-an-ssh-key-pair)
1. Setup general python environment
```
# Install latest version
pyenv install <latest stable version>

# Bind to virtual environment
pyenv virtualenv <latest stable version> <memorable name for env>

# Activate pyenv activate
<memorable name for env>

# Install packages
pip3 install -r ~/$HOME/requirements.txt
```

Setup hotkeys

Hotkeys are handled by Hammerspoon. This would be better with Karabiner for a machine without security oversight.
    1. Open Hammerspoon, right click the menu option, and reload the config

Other resources

- [Github dotfiles](https://dotfiles.github.io)

Ideas
- [Add homebrew install script](https://cpojer.net/posts/set-up-a-new-mac-fast))
- [Auto-install vim-plug](https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation)
