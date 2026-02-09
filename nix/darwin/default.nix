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
  # Disable nix-darwin's Nix management (using Determinate Nix)
  nix.enable = false;
}
