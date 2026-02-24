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

        # File Manager
        yazi # file manager
        file # file type detection
        fd # file searching
        ripgrep # file content searching

        # Languages
        nodejs_24 # JavaScript runtime
        python3 # Python interpreter

        # Language Servers
        nixd # Nix language server

        # Package Managers
        bun # JavaScript runtime and package manager
        pnpm # Node.js package manager
        uv # Python package installer

        # Shell
        zsh # Z shell
        starship # Cross-shell prompt
        sheldon # Shell plugin manager
      ])
      ++ (with pkgs.llm-agents; [
        claude-code # Anthropic Claude Code CLI
        gemini-cli # Google Gemini CLI
      ]);
  };
}
