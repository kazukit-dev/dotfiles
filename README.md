# dotfiles

Personal dotfiles configuration managed with Nix, nix-darwin, and home-manager.

## Overview

This repository provides a declarative and reproducible development environment configuration for macOS using:

- **Nix** - Functional package manager for reproducible builds
- **nix-darwin** - Declarative macOS system configuration
- **home-manager** - User environment and dotfiles management

## Initial setup

1. Install [Determinate Nix](https://github.com/DeterminateSystems/nix-installer):

   ```sh
   curl -fsSL https://install.determinate.systems/nix | sh -s -- install
   ```

2. Clone this repository:

3. Apply the nix-darwin configuration:

   ```sh
   sudo nix run nix-darwin -- switch --flake .#<hostname>
   ```

4. Setup git signing config:

   ```sh
   ./scripts/setup-git-signing.sh
   git config --file ~/.config/git/config.local user.name "your name"
   git config --file ~/.config/git/config.local user.email "your email"
   ```

## Architecture

```
├── config/              # Application configurations (symlinked to "$HOME/.config")
├── home/                # Files to be placed in "$HOME"
│   └── .zshenv          # Zsh environment variables
├── flake.lock
├── flake.nix            # Main flake configuration with apps and pre-commit hooks
├── nix/
│   ├── darwin/          # nix-darwin configuration
│   │   ├── default.nix
│   │   ├── homebrew.nix # Homebrew packages (GUI apps and macOS-specific tools)
│   │   └── system.nix   # macOS system settings
│   └── home/            # home-manager configuration
│       ├── default.nix
│       ├── dotfiles.nix # Symlink definitions for config files
│       └── packages.nix # Nixpkgs packages (CLI tools)
└── scripts/
    └── setup-git-signing.sh
```

## Available Nix Apps

- `nix run .#switch` - Apply nix-darwin and home-manager configuration changes
- `nix run .#update` - Update flake.lock dependencies
- `nix run .#secrets` - Scan repository for hardcoded secrets using gitleaks
