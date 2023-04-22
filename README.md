# Dotfiles

Just a repo of personal dotfiles. Here are some of the sources that inspire the approach:
- [Dotfiles as a bare git repo](https://www.atlassian.com/git/tutorials/dotfiles).
- [New laptop setup](https://cpojer.net/posts/set-up-a-new-mac-fast)

## New laptop setup:

1. Install dotfiles on laptop 
    1. Clone dotfiles as a bare repo: `git clone --bare https://github.com/lukearmistead/dotfiles.git $HOME/dotfiles`
    1. Define alias to deal with weird bare repo stuff: `alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
    1. Checkout the actual content from the bare repository to your `$HOME`: `dotfiles checkout`
1. Install Homebrew
    1. Run the command from [Homebrew's website](https://brew.sh/): `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
    1. Make sure that homebrew is in your `PATH` ([source](https://stackoverflow.com/a/68494567)): `export PATH=/opt/homebrew/bin:$PATH`
1. Install applications 
    1. Run from  `$HOME` directory: `brew bundle`
1. Vim
    1. Install plug ```curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim```
    1. Open the `.vimrc` with `<space> ev` and download all plugins with `<space> sv`
1. Hotkeys are handled by Hammerspoon. This would be better with Karabiner for a machine without security oversight.
