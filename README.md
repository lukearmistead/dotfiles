# Dotfiles

Personal configuration files managed with a [bare Git repository](https://www.atlassian.com/git/tutorials/dotfiles).

## Setup

```bash
curl -fsSL https://raw.githubusercontent.com/lukearmistead/dotfiles/main/setup.sh | bash
```

This clones the repo, installs Homebrew packages from the Brewfile, and installs tmux plugins.
It's idempotent — safe to re-run any time. Anything one-time or a matter of personal
judgment isn't automated; see "Manual steps" below.

If a Homebrew package fails to install (network blip, etc.), the script logs an error
and keeps going rather than aborting. Check with `brew bundle check --file=Brewfile`
and fix up with `brew bundle install --file=Brewfile`.

## Manual steps

Not automated by `setup.sh` on purpose — one-time or a matter of taste:

```bash
# Git identity
git config --global user.name "Your Name"
git config --global user.email "you@example.com"

# macOS system preferences (optional)
./macos-preferences.sh

# Python version, per project (uv, not pyenv)
uv python install 3.12
uv python pin 3.12
```

## Usage

The `dotfiles` alias wraps Git against your home directory:

```bash
dotfiles status
dotfiles add .config/starship.toml
dotfiles commit -m "Update starship config"
dotfiles push
```

Only explicitly added files are tracked.

## Syncing across machines

```bash
# Push from one machine
dotfiles add -u && dotfiles commit -m "Update configs" && dotfiles push

# Pull on another
dotfiles pull
```
