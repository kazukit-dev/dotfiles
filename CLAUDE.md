# dotfiles

Personal dotfiles configuration managed with Nix, nix-darwin, and home-manager.

## Key Features

- **Nix** - Functional package manager for reproducible system configuration
- **nix-darwin** - Nix-based configuration management for macOS system settings
- **home-manager** - Declarative dotfile and user environment management

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
│       ├── modules/     # Modular configuration for tools (git, zsh, etc.)
│       └── packages.nix # Nixpkgs packages (CLI tools)
└── scripts/
    └── setup-git-signing.sh
```

## Available Nix Apps

- `nix run .#switch` - Apply nix-darwin and home-manager configuration changes
- `nix run .#update` - Update flake.lock dependencies
- `nix run .#secrets` - Scan repository for hardcoded secrets using gitleaks
