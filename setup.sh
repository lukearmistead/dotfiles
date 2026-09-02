#!/usr/bin/env bash

#==============================================================================
# AUTOMATED LAPTOP SETUP SCRIPT
# This script automates the entire laptop setup process including:
# - Dotfiles management via bare git repo
# - Homebrew and application installation
# - Development environment setup (Python, Git, Vim, Tmux)
# - macOS system preferences
#==============================================================================

set -euo pipefail  # Exit on error, undefined vars, and pipe failures
IFS=$'\n\t'       # Set Internal Field Separator for better handling

# Color output for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration variables
DOTFILES_REPO="https://github.com/lukearmistead/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

#==============================================================================
# Helper Functions
#==============================================================================

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

prompt_yes_no() {
    local prompt="$1"
    local response
    
    while true; do
        read -rp "$prompt (y/n): " response
        case "$response" in
            [yY][eE][sS]|[yY]) return 0 ;;
            [nN][oO]|[nN]) return 1 ;;
            *) echo "Please answer yes or no." ;;
        esac
    done
}

check_command() {
    if command -v "$1" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

detect_os() {
    case "$(uname -s)" in
        Darwin*)
            OS="macOS"
            ;;
        Linux*)
            OS="Linux"
            if [ -f /etc/os-release ]; then
                . /etc/os-release
                DISTRO=$ID
            fi
            ;;
        *)
            error "Unsupported operating system"
            exit 1
            ;;
    esac
    info "Detected OS: $OS"
}

#==============================================================================
# Main Setup Functions
#==============================================================================

setup_xcode_tools() {
    if [ "$OS" = "macOS" ]; then
        log "Checking for Xcode Command Line Tools..."
        if ! xcode-select -p &> /dev/null; then
            log "Installing Xcode Command Line Tools..."
            xcode-select --install
            
            # Wait for installation to complete
            until xcode-select -p &> /dev/null; do
                sleep 5
            done
            log "Xcode Command Line Tools installed successfully"
        else
            info "Xcode Command Line Tools already installed"
        fi
    fi
}

setup_homebrew() {
    if [ "$OS" = "macOS" ]; then
        log "Setting up Homebrew..."
        
        if ! check_command brew; then
            log "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            
            # Add Homebrew to PATH for Apple Silicon Macs
            if [[ $(uname -m) == "arm64" ]]; then
                echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
                eval "$(/opt/homebrew/bin/brew shellenv)"
            else
                echo 'eval "$(/usr/local/bin/brew shellenv)"' >> "$HOME/.zprofile"
                eval "$(/usr/local/bin/brew shellenv)"
            fi
        else
            info "Homebrew already installed"
        fi
        
        # Update Homebrew
        log "Updating Homebrew..."
        brew update
    elif [ "$OS" = "Linux" ]; then
        # Optional: Add support for Linuxbrew if needed
        warning "Homebrew installation on Linux not implemented in this script"
    fi
}

backup_existing_dotfiles() {
    log "Backing up existing dotfiles..."
    
    # List of common dotfiles to backup
    local dotfiles=(
        ".bashrc"
        ".bash_profile"
        ".zshrc"
        ".vimrc"
        ".vim"
        ".tmux.conf"
        ".gitconfig"
        ".gitignore_global"
    )
    
    local backup_needed=false
    for file in "${dotfiles[@]}"; do
        if [ -e "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
            backup_needed=true
            break
        fi
    done
    
    if [ "$backup_needed" = true ]; then
        mkdir -p "$BACKUP_DIR"
        for file in "${dotfiles[@]}"; do
            if [ -e "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
                log "Backing up $file to $BACKUP_DIR/"
                mv "$HOME/$file" "$BACKUP_DIR/"
            fi
        done
        info "Existing dotfiles backed up to: $BACKUP_DIR"
    else
        info "No existing dotfiles need backing up"
    fi
}

setup_dotfiles() {
    log "Setting up dotfiles..."
    
    # Clone dotfiles as a bare repository
    if [ ! -d "$DOTFILES_DIR" ]; then
        log "Cloning dotfiles repository..."
        git clone --bare "$DOTFILES_REPO" "$DOTFILES_DIR"
    else
        info "Dotfiles repository already exists"
    fi
    
    # Define the dotfiles alias
    alias dotfiles="/usr/bin/git --git-dir=$DOTFILES_DIR --work-tree=$HOME"
    
    # Add alias to shell config
    local shell_config
    if [ -n "${ZSH_VERSION:-}" ]; then
        shell_config="$HOME/.zshrc"
    else
        shell_config="$HOME/.bashrc"
    fi
    
    if ! grep -q "alias dotfiles=" "$shell_config" 2>/dev/null; then
        echo "alias dotfiles='/usr/bin/git --git-dir=$DOTFILES_DIR --work-tree=$HOME'" >> "$shell_config"
    fi
    
    # Checkout dotfiles
    log "Checking out dotfiles..."
    if ! /usr/bin/git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" checkout 2>/dev/null; then
        warning "Some files would be overwritten. Backing them up first..."
        backup_existing_dotfiles
        /usr/bin/git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" checkout --force
    fi
    
    # Configure the repository
    log "Configuring dotfiles repository..."
    /usr/bin/git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" config --local status.showUntrackedFiles no
    
    log "Dotfiles setup complete"
}

install_homebrew_packages() {
    if [ "$OS" = "macOS" ] && check_command brew; then
        log "Installing Homebrew packages..."
        
        # Check if Brewfile exists
        if [ -f "$HOME/Brewfile" ]; then
            log "Installing packages from Brewfile..."
            brew bundle install --file="$HOME/Brewfile"
            log "Homebrew packages installed successfully"
        else
            warning "No Brewfile found at $HOME/Brewfile"
            warning "Skipping Homebrew package installation"
            info "Run 'brew bundle' manually after your Brewfile is available"
        fi
    fi
}

setup_vim() {
    log "Setting up Vim..."
    
    # Install vim-plug
    if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
        log "Installing vim-plug..."
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    else
        info "vim-plug already installed"
    fi
    
    # Install Vim plugins
    if check_command vim; then
        log "Installing Vim plugins..."
        vim +PlugInstall +qall
    fi
}

setup_tmux() {
    log "Setting up Tmux..."
    
    # Install Tmux Plugin Manager (TPM)
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        log "Installing Tmux Plugin Manager..."
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    else
        info "TPM already installed"
    fi
    
    # Install tmux plugins
    if check_command tmux; then
        log "Installing tmux plugins..."
        # Start a tmux server but don't attach to it
        tmux start-server
        # Create a new session but don't attach to it
        tmux new-session -d
        # Install plugins
        ~/.tmux/plugins/tpm/scripts/install_plugins.sh
        # Kill the tmux server
        tmux kill-server
    fi
}

setup_git() {
    log "Setting up Git..."
    
    # Check if git config is already set
    if [ -z "$(git config --global user.name)" ]; then
        read -rp "Enter your Git user name: " git_username
        git config --global user.name "$git_username"
    fi
    
    if [ -z "$(git config --global user.email)" ]; then
        read -rp "Enter your Git email: " git_email
        git config --global user.email "$git_email"
    fi
    
    # Set default configurations
    git config --global color.ui true
    git config --global core.editor vim
    git config --global init.defaultBranch main
    
    info "Git configuration complete"
}

setup_python() {
    log "Setting up Python environment..."
    
    # Install pyenv
    if ! check_command pyenv; then
        if [ "$OS" = "macOS" ] && check_command brew; then
            log "Installing pyenv..."
            brew install pyenv pyenv-virtualenv
        else
            log "Installing pyenv via git..."
            git clone https://github.com/pyenv/pyenv.git ~/.pyenv
            git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
        fi
        
        # Add pyenv to PATH
        echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
        echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
        echo 'eval "$(pyenv init -)"' >> ~/.zshrc
        echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.zshrc
        
        # Load pyenv for current session
        export PYENV_ROOT="$HOME/.pyenv"
        export PATH="$PYENV_ROOT/bin:$PATH"
        eval "$(pyenv init -)"
        eval "$(pyenv virtualenv-init -)"
    else
        info "pyenv already installed"
    fi
    
    # Install latest stable Python
    if check_command pyenv; then
        log "Checking for latest Python version..."
        latest_python=$(pyenv install --list | grep -E "^\s*[0-9]+\.[0-9]+\.[0-9]+$" | tail -1 | xargs)
        
        if ! pyenv versions | grep -q "$latest_python"; then
            log "Installing Python $latest_python..."
            pyenv install "$latest_python"
            pyenv global "$latest_python"
        else
            info "Python $latest_python already installed"
        fi
        
        # Install Python packages from requirements.txt if it exists
        if [ -f "$HOME/requirements.txt" ]; then
            log "Installing Python packages from requirements.txt..."
            pip3 install -r "$HOME/requirements.txt"
        fi
    fi
}

setup_hammerspoon() {
    if [ "$OS" = "macOS" ]; then
        log "Setting up Hammerspoon..."
        
        # Install Hammerspoon if not already installed
        if ! [ -d "/Applications/Hammerspoon.app" ]; then
            if check_command brew; then
                log "Installing Hammerspoon..."
                brew install --cask hammerspoon
            fi
        else
            info "Hammerspoon already installed"
        fi
        
        # Reload Hammerspoon config
        if [ -d "/Applications/Hammerspoon.app" ]; then
            log "Reloading Hammerspoon configuration..."
            osascript -e 'tell application "Hammerspoon" to reload config'
        fi
    fi
}

setup_macos_defaults() {
    if [ "$OS" = "macOS" ]; then
        if prompt_yes_no "Do you want to apply macOS system defaults?"; then
            log "Applying macOS defaults..."
            
            # If there's a .macos file in the dotfiles, run it
            if [ -f "$HOME/.macos" ]; then
                bash "$HOME/.macos"
            else
                # Apply some sensible defaults
                
                # Dock
                defaults write com.apple.dock autohide -bool true
                defaults write com.apple.dock show-recents -bool false
                defaults write com.apple.dock minimize-to-application -bool true
                
                # Finder
                defaults write com.apple.finder ShowPathbar -bool true
                defaults write com.apple.finder ShowStatusBar -bool true
                defaults write com.apple.finder AppleShowAllFiles -bool true
                
                # Screenshots
                defaults write com.apple.screencapture location -string "$HOME/Desktop/Screenshots"
                mkdir -p "$HOME/Desktop/Screenshots"
                
                # Trackpad
                defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
                defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
                
                # Restart affected applications
                for app in "Dock" "Finder"; do
                    killall "${app}" &> /dev/null || true
                done
            fi
            
            log "macOS defaults applied"
        fi
    fi
}

create_directory_structure() {
    log "Creating directory structure..."
    
    local directories=(
        "$HOME/Developer"
        "$HOME/Developer/projects"
        "$HOME/Developer/scripts"
        "$HOME/.config"
        "$HOME/.local/bin"
    )
    
    for dir in "${directories[@]}"; do
        if [ ! -d "$dir" ]; then
            mkdir -p "$dir"
            log "Created directory: $dir"
        fi
    done
}

#==============================================================================
# Main Script Execution
#==============================================================================

main() {
    echo -e "${MAGENTA}"
    echo "╔══════════════════════════════════════════╗"
    echo "║     AUTOMATED LAPTOP SETUP SCRIPT        ║"
    echo "╚══════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Detect if we're running from a pipe (curl)
    if [ "$RUNNING_FROM_CURL" = true ]; then
        info "Running from remote execution (curl)"
        info "Interactive prompts will be skipped"
    fi
    
    # Detect operating system
    detect_os
    
    # Ask for sudo password upfront (if not running from curl)
    if [ "$OS" = "macOS" ]; then
        if [ "$RUNNING_FROM_CURL" = false ]; then
            log "Requesting sudo access (you may need to enter your password)..."
            sudo -v
            # Keep sudo alive
            while true; do sudo -n true; sleep 60; kill -0 "$" || exit; done 2>/dev/null &
        else
            warning "Running from curl - skipping sudo setup"
            info "You may be prompted for sudo password during installation"
        fi
    fi
    
    # Run setup steps
    info "Starting setup process..."
    
    setup_xcode_tools
    setup_homebrew
    setup_dotfiles  # This now handles cloning if needed
    install_homebrew_packages
    setup_vim
    setup_tmux
    setup_git
    setup_python
    setup_hammerspoon
    create_directory_structure
    setup_macos_defaults
    
    # Final message
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════╗"
    echo "║       SETUP COMPLETED SUCCESSFULLY!      ║"
    echo "╚══════════════════════════════════════════╝"
    echo -e "${NC}"
    
    info "Please restart your terminal or run: source ~/.zshrc"
    
    if [ "$RUNNING_FROM_CURL" = true ]; then
        info ""
        info "Since this was run from curl, please complete these manual steps:"
        info "  1. Configure git: git config --global user.name 'Your Name'"
        info "  2. Configure git: git config --global user.email 'your@email.com'"
        info "  3. Open Hammerspoon and reload config"
        info "  4. In tmux, install plugins with: <prefix> + I"
    else
        info "You may need to manually:"
        info "  - Open Hammerspoon and reload config"
        info "  - Install tmux plugins with: <prefix> + I"
    fi
    
    if [ -d "$BACKUP_DIR" ]; then
        warning "Your original dotfiles were backed up to: $BACKUP_DIR"
    fi
    
    # If the script was downloaded, offer to clean it up
    if [ "$RUNNING_FROM_CURL" = false ] && [ -f "$0" ]; then
        if [ "$(basename "$0")" = "setup.sh" ] && [ "$(dirname "$0")" = "." ]; then
            info ""
            info "This setup script can be safely deleted now"
            info "It's also available in your dotfiles repo"
        fi
    fi
}

# Run main function
main "$@"
