# Dotfiles

Personal configuration files managed with a bare Git repository for a seamless development environment setup.

## 🚀 Quick Start

Set up a new machine with a single command:

```bash
curl -fsSL https://raw.githubusercontent.com/lukearmistead/dotfiles/main/setup.sh | bash
```

That's it! The script will automatically:
- Clone this dotfiles repository
- Install Homebrew and all packages from the Brewfile
- Configure Vim, Tmux, Git, and Python environments
- Set up Hammerspoon for custom hotkeys
- Apply macOS system preferences
- Back up any existing dotfiles before replacing them

## 📋 What's Included

- **Package Management**: Brewfile for consistent tool installation
- **Shell**: Zsh/Bash configurations and aliases
- **Editor**: Vim configuration with plugins via vim-plug
- **Terminal Multiplexer**: Tmux configuration with TPM
- **Version Control**: Git configuration and global gitignore
- **Python**: pyenv setup with virtualenv support
- **Automation**: Hammerspoon configuration for macOS
- **System Preferences**: Sensible macOS defaults

## 🔧 Manual Installation

If you prefer to review the script before running it:

```bash
# Download and inspect the script
curl -fsSL https://raw.githubusercontent.com/lukearmistead/dotfiles/main/setup.sh -o setup.sh
less setup.sh

# Run it
bash setup.sh

# Clean up
rm setup.sh
```

## 💻 Daily Usage

After initial setup, manage your dotfiles with the `dotfiles` command:

```bash
# Check status
dotfiles status

# Add a new config file
dotfiles add .vimrc
dotfiles commit -m "Update vim configuration"
dotfiles push

# Pull updates on another machine
dotfiles pull
```

The `dotfiles` command is an alias for Git that manages your home directory as a bare repository, tracking only the files you explicitly add.

## 🛠 Manual Setup (Advanced)

If you want to set things up manually or understand what the script does:

### 1. Clone the Repository

```bash
git clone --bare https://github.com/lukearmistead/dotfiles.git $HOME/dotfiles
```

### 2. Configure the Alias

```bash
alias dotfiles='/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME'
```

### 3. Checkout the Files

```bash
dotfiles config --local status.showUntrackedFiles no
dotfiles checkout
```

If you get errors about existing files, back them up first:

```bash
mkdir -p .dotfiles-backup
dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .dotfiles-backup/{}
dotfiles checkout
```

### 4. Install Dependencies

```bash
# Install Homebrew (macOS)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install packages from Brewfile
brew bundle

# Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Open Vim and install plugins
vim +PlugInstall +qall

# Install TPM (Tmux Plugin Manager)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install tmux plugins (prefix + I from within tmux)
```

## 📝 Customization

### Adding New Dotfiles

```bash
dotfiles add .config/newapp/config
dotfiles commit -m "Add newapp configuration"
dotfiles push
```

### Modifying the Brewfile

Edit `~/Brewfile` to add or remove packages:

```ruby
# Development tools
brew "git"
brew "vim"
brew "tmux"

# Cask applications
cask "visual-studio-code"
cask "docker"
```

Then run `brew bundle` to install new packages.

### Updating the Setup Script

The `setup.sh` script lives in this repository. To modify the setup process:

1. Edit `~/setup.sh`
2. Commit your changes: `dotfiles add setup.sh && dotfiles commit -m "Update setup script"`
3. Push: `dotfiles push`

## 🔄 Keeping Systems in Sync

### On the machine with changes:
```bash
dotfiles add -u
dotfiles commit -m "Update configurations"
dotfiles push
```

### On other machines:
```bash
dotfiles pull
brew bundle  # Update packages if Brewfile changed
```

## 🗂 Repository Structure

```
~/
├── .config/          # Application configurations
├── .vim/            # Vim configuration
├── .vimrc           # Vim settings
├── .tmux.conf       # Tmux configuration
├── .gitconfig       # Git configuration
├── .gitignore_global # Global gitignore
├── .zshrc           # Zsh configuration
├── .bashrc          # Bash configuration
├── Brewfile         # Homebrew packages
├── requirements.txt # Python packages
└── setup.sh         # Automated setup script
```

## 🆘 Troubleshooting

### Permission Denied Errors
```bash
chmod +x setup.sh
```

### Homebrew Not Found (Apple Silicon)
```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### Dotfiles Command Not Found
Add to your shell configuration:
```bash
echo "alias dotfiles='/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=\$HOME'" >> ~/.zshrc
source ~/.zshrc
```

### Conflicts During Checkout
The setup script automatically backs up conflicting files. Manual resolution:
```bash
mkdir -p ~/.dotfiles-backup
# Move conflicting files to backup
dotfiles checkout
```

## 🔗 Resources

- [Using a bare Git repo for dotfiles](https://www.atlassian.com/git/tutorials/dotfiles)
- [Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle)
- [Vim-Plug](https://github.com/junegunn/vim-plug)
- [TPM - Tmux Plugin Manager](https://github.com/tmux-plugins/tpm)
- [Hammerspoon](https://www.hammerspoon.org/)

## 📄 License

These dotfiles are provided as-is for anyone to use and modify.
