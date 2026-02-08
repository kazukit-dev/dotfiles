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
   git config --global user.name "your name"
   git config --global user.email "your email"
   ```

## Available Nix Apps

- `nix run .#switch` - Apply nix-darwin and home-manager configuration changes
- `nix run .#update` - Update flake.lock dependencies
- `nix run .#secrets` - Scan repository for hardcoded secrets using gitleaks
