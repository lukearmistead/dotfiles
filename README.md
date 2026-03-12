# Dotfiles

Personal configuration files managed with a [bare Git repository](https://www.atlassian.com/git/tutorials/dotfiles).

## Setup

```bash
curl -fsSL https://raw.githubusercontent.com/lukearmistead/dotfiles/main/setup.sh | bash
```

This clones the repo, installs Homebrew packages from the Brewfile, and configures the shell, editor, and terminal.

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
