#!/usr/bin/env bash

#==============================================================================
# AUTOMATED LAPTOP SETUP SCRIPT
# This script automates the core laptop bootstrap process:
# - Dotfiles checkout via bare git repo
# - Homebrew and package installation (see Brewfile)
# - Tmux plugin installation
# - Directory scaffolding
#
# Anything one-time, opinionated, or better left to human judgment (git
# identity, macOS system preferences, per-project Python versions) is
# documented in README.md as a manual step instead of automated here.
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

# curl | bash gives the script no real source file, unlike running it directly
if [ -z "${BASH_SOURCE[0]:-}" ]; then
    RUNNING_FROM_CURL=true
else
    RUNNING_FROM_CURL=false
fi

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

# Runs a setup step without letting its failure abort the rest of setup
run_step() {
    local step_name="$1"
    shift
    if ! "$@"; then
        error "$step_name failed - continuing with remaining setup steps"
    fi
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

            # Load Homebrew into this session; .zshrc (from the dotfiles repo)
            # already handles it permanently for future shells
            if [[ $(uname -m) == "arm64" ]]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
            else
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

# Backs up any tracked dotfile path that already exists on disk as a real
# file (not a symlink), so `git checkout` never silently clobbers it. The
# file list is derived from the repo itself so it can't drift out of sync.
backup_existing_dotfiles() {
    log "Backing up existing dotfiles..."

    local tracked_files
    tracked_files=$(/usr/bin/git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" ls-tree -r --name-only HEAD)

    local backup_needed=false
    while IFS= read -r file; do
        if [ -e "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
            backup_needed=true
            break
        fi
    done <<< "$tracked_files"

    if [ "$backup_needed" = true ]; then
        mkdir -p "$BACKUP_DIR"
        while IFS= read -r file; do
            if [ -e "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
                log "Backing up $file to $BACKUP_DIR/"
                mkdir -p "$(dirname "$BACKUP_DIR/$file")"
                mv "$HOME/$file" "$BACKUP_DIR/$file"
            fi
        done <<< "$tracked_files"
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

setup_hammerspoon() {
    if [ "$OS" = "macOS" ] && [ -d "/Applications/Hammerspoon.app" ]; then
        log "Reloading Hammerspoon configuration..."
        osascript -e 'tell application "Hammerspoon" to reload config'
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
        # curl | bash feeds the script itself over stdin, leaving nothing left
        # to read for sudo/git prompts; reclaim the real terminal if one exists
        if ! exec < /dev/tty 2>/dev/null; then
            info "No interactive terminal available - prompts will be skipped"
        fi
    fi

    # Detect operating system
    detect_os

    # Ask for sudo password upfront
    if [ "$OS" = "macOS" ]; then
        log "Requesting sudo access (you may need to enter your password)..."
        sudo -v
        # Keep sudo alive
        while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
    fi

    # Run setup steps
    info "Starting setup process..."

    run_step "Xcode tools setup" setup_xcode_tools
    run_step "Homebrew setup" setup_homebrew
    run_step "Dotfiles setup" setup_dotfiles
    run_step "Homebrew package installation" install_homebrew_packages
    run_step "Tmux setup" setup_tmux
    run_step "Hammerspoon reload" setup_hammerspoon
    run_step "Directory structure creation" create_directory_structure

    # Final message
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════╗"
    echo "║       SETUP COMPLETED SUCCESSFULLY!      ║"
    echo "╚══════════════════════════════════════════╝"
    echo -e "${NC}"

    info "Please restart your terminal or run: source ~/.zshrc"
    info ""
    info "Remaining manual steps (see README.md):"
    if [ -z "$(git config --global user.name 2>/dev/null)" ] || [ -z "$(git config --global user.email 2>/dev/null)" ]; then
        info "  - Set your git identity: git config --global user.name 'Your Name' && git config --global user.email 'you@example.com'"
    fi
    info "  - Optional: apply macOS system preferences with ./macos-preferences.sh"
    info "  - Optional: pin a Python version per project with: uv python install <version> && uv python pin <version>"

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
