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
  };
}
