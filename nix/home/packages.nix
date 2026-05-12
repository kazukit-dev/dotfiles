# CLI tools and development environment packages
# Installed via Nixpkgs (cross-platform CLI tools)
# For GUI apps and macOS-specific tools, see nix/darwin/homebrew.nix
{
  pkgs,
  ...
}:
let
  czg = pkgs.writeShellScriptBin "czg" ''
    exec ${pkgs.bun}/bin/bunx czg@1.12.0 "$@"
  '';
  difit = pkgs.writeShellScriptBin "difit" ''
    exec ${pkgs.bun}/bin/bunx difit@4.0.3 "$@"
  '';
in
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
        nb # Note taking CLI
        ast-grep # code search CLI

        # File Manager
        yazi # file manager
        file # file type detection
        fd # file searching
        ripgrep # file content searching

        # Development
        python314
        uv # Python package manager
        nodejs_25
        pnpm # JavaScript package manager
        bun # JavaScript runtime and toolkit
        deno # JavaScript runtime

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

        # Git Tools
        czg
        difit
      ])
      ++ (with pkgs; [
        # Neovim Dependencies
        tree-sitter # Parser generator tool (required by nvim-treesitter)

        # Neovim Language Servers
        efm-langserver # Integrate formatters and linters via LSP
        dockerfile-language-server # Dockerfile language server
        lua-language-server # Lua language server
        marksman # Markdown language server
        nixd # Nix language server
        sqls # SQL language server
        typescript-language-server # TypeScript/JavaScript language server
        typos-lsp # Typos spell checker language server
        vscode-langservers-extracted # HTML/CSS/JSON/ESLint language servers
        vue-language-server # Vue.js language server (Volar)
        bash-language-server # Bash/Shell language server
        yaml-language-server # YAML language server

        # Neovim Formatters & Linters
        shellcheck # Shell script linter
        actionlint # GitHub Actions workflow linter
        hadolint # Dockerfile linter
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
