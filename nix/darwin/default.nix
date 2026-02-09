{
  username,
  homedir,
  ...
}:
{
  imports = [
    ./homebrew.nix
    ./system.nix
  ];
  users.users.${username} = {
    home = homedir;
  };
  # Configure Determinate Nix with automatic garbage collection
  determinateNix = {
    enable = true;
    determinateNixd = {
      garbageCollector.strategy = "automatic";
    };
  };
}
