{
  username,
  homedir,
  inputs,
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
    inputs.nix-index-database.hmModules.nix-index
    ./modules
    ./packages.nix
  ];

  # nix-index-database: weekly updated package search database
  programs.nix-index-database.comma.enable = true;
}
