{
  username,
  homedir,
  ...
}:
{
  imports = [
    ./homebrew.nix
    ./system.nix
    ./fonts.nix
  ];
  users.users.${username} = {
    home = homedir;
  };
  # GUI apps are launched by launchd, not zsh, so they never read
  # ~/.zshenv. Register the npm XDG variables with launchd too, or MCP
  # servers spawned via npx by Claude Desktop / Codex fall back to ~/.npm.
  launchd.user.envVariables = {
    NPM_CONFIG_USERCONFIG = "${homedir}/.config/npm/npmrc";
    NPM_CONFIG_CACHE = "${homedir}/.cache/npm";
  };

  # Disable nix-darwin's compinit; managed by sheldon in .zshrc
  programs.zsh = {
    enable = true;
    enableCompletion = false;
    enableBashCompletion = false;
  };

  # Configure Determinate Nix with automatic garbage collection
  determinateNix = {
    enable = true;
    determinateNixd = {
      garbageCollector.strategy = "automatic";
    };
    customSettings = {
      extra-trusted-substituters = [
        "https://kazukit.cachix.org"
        "https://nix-community.cachix.org"
        "https://cache.numtide.com"
      ];
      extra-trusted-public-keys = [
        "kazukit.cachix.org-1:pL0zV9aaRVYz0wdxKhfwFXISwTDb10wK7hxbuaxL93Q="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      ];
    };
  };
}
