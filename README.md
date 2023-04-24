# Dotfiles

Just a repo of personal dotfiles. Here are some of the sources that inspire the approach:
- [Dotfiles as a bare git repo](https://www.atlassian.com/git/tutorials/dotfiles)
- [New laptop setup](https://cpojer.net/posts/set-up-a-new-mac-fast)

## New laptop setup:

1. Install dotfiles on laptop
    1. Clone dotfiles as a bare repo: `git clone --bare https://github.com/lukearmistead/dotfiles.git $HOME/dotfiles`
    1. Define alias to deal with weird bare repo stuff: `alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME`
    1. Checkout the actual content from the bare repository to your `$HOME`: `dotfiles checkout`
1. Install all applications with Hombrew
    1. Run the command from [Homebrew's website](https://brew.sh/): `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
    1. Make sure that homebrew is in your `PATH` ([link](https://stackoverflow.com/a/68494567)): `export PATH=/opt/homebrew/bin:$PATH`
    1. Run from  `$HOME` directory: `brew bundle`
1. Vim & Tmux
    1. Install plug ```curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim```
    1. Open the `.vimrc` with `<space> ev` and download all plugins with `<space> sv`
    1. Install all tmux plugins with `<leader> I`
1. Set up Git
    1. Write your global config ([link](https://kbroman.org/github_tutorial/pages/first_time.html))
       ```
       git config --global user.name "First Last"
       git config --global user.email "username@provider.com"
       git config --global color.ui true
       git config --global core.editor vim
       ```
   1. Generate ssh keys to access GitHub ([link](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) and Gitlab ([link](https://docs.gitlab.com/ee/user/ssh.html#generate-an-ssh-key-pair))
1. Set up general python environment
    1. Install latest version `pyenv install <latest stable version>`
    1. Bind to virtual environment `pyenv virtualenv <latest stable version> science`
    1. Activate `pyenv activate science` and install packages `pip3 install -r ~/$HOME/requirements.txt`
1. Hotkeys are handled by Hammerspoon. This would be better with Karabiner for a machine without security oversight.
    1. Open Hammerspoon, right click the menu option, and reload the config
