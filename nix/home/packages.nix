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

        # File Manager
        yazi # file manager
        file # file type detection
        fd # file searching
        ripgrep # file content searching

        # Language Servers
        nixd # Nix language server

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
      ])
      ++ (with pkgs.llm-agents; [
        claude-code # Anthropic Claude Code CLI
        # FIXME: gemini-cli build fails due to node-pty forkpty conflicting types
        # between darwinOpenptyHook shim and Apple SDK 14.4
        # https://github.com/numtide/llm-agents.nix
        # gemini-cli # Google Gemini CLI
      ]);
  };
}
