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

    ```sh
    mkdir -p ~/ghq/github.com/kazukit-dev
    git clone git@github.com:kazukit-dev/dotfiles.git > ~/ghq/github.com/kazukit-dev/
    ```

3. Apply the nix-darwin configuration:

   ```sh
   sudo nix run nix-darwin -- switch --flake .#<hostname>
   ```

4. Enable 1Password SSH agent:

   Open 1Password > Settings > Developer and enable "Use the SSH agent".
   This allows SSH keys stored in 1Password to be used for Git signing and SSH authentication.

5. Setup git signing key:

   ```sh
   ./scripts/setup-git-signing-key.sh
   git config --file ~/.config/git/config.local user.name "your name"
   git config --file ~/.config/git/config.local user.email "your email"
   ```
## Available Nix Apps

- `nix run .#switch` - Apply nix-darwin and home-manager configuration changes
- `nix run .#update` - Update flake.lock dependencies
- `nix run .#secrets` - Scan repository for hardcoded secrets using gitleaks
