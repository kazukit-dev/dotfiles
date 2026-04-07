# CLI tools and development environment packages
# Installed via Nixpkgs (cross-platform CLI tools)
# For GUI apps and macOS-specific tools, see nix/darwin/homebrew.nix
{
  pkgs,
  ...
}:
{
  home = {
    packages =
      (with pkgs; [
        # Cloud & Infrastructure
        awscli2 # AWS command line interface

        # CLI Tools
        curl # HTTP client
        eza # Modern replacement for ls with colors and git integration
        jq # Command-line JSON processor
        lazygit # Terminal UI for git commands
        zoxide # Smarter cd command that learns your habits
        tree # Directory tree visualization
        fzf # Fuzzy finder for command-line
        git # version control
        gomi # Trash CLI for safely deleting files
        gh # GitHub CLI
        ghq # GitHub repository management CLI
        direnv # Environment switcher
        neovim # Vim-based text editor
        tree-sitter # Parser generator tool (required by nvim-treesitter)

        # File Manager
        yazi # file manager
        file # file type detection
        fd # file searching
        ripgrep # file content searching

        # Package Managers
        mise # Universal package manager for CLI tools

        # Shell
        zsh # Z shell
        starship # Cross-shell prompt
        sheldon # Shell plugin manager

        # Containerization
        colima # Container runtime
        docker
        docker-compose

        # AI Tools
        ollama
      ])
      ++ (with pkgs; [
        # Neovim Language Servers
        lua-language-server # Lua language server
        nixd # Nix language server
        sqls # SQL language server
        typescript-language-server # TypeScript/JavaScript language server
        typos-lsp # Typos spell checker language server
        vscode-langservers-extracted # HTML/CSS/JSON/ESLint language servers
        yaml-language-server # YAML language server

        # Neovim Formatters & Linters
        nixfmt # Nix formatter
        stylua # Lua formatter
        typos # Source code spell checker
      ])
      ++ (with pkgs.llm-agents; [
        claude-code # Anthropic Claude Code CLI
        codex # Codex CLI
      ]);
  };
}
