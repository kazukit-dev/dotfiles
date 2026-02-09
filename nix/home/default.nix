{
  username,
  homedir,
  ...
}:
{
  home = {
    stateVersion = "25.11";
    inherit username;
    homeDirectory = homedir;
  };
  programs.home-manager.enable = true;

  imports = [
    ./modules
    ./packages.nix
  ];
}
