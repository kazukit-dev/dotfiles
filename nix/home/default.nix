{
  username,
  homedir,
  inputs,
  lib,
  config,
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
    inputs.nix-index-database.homeModules.nix-index
    ./dotfiles.nix
    ./packages.nix
  ];

  # nix-index-database: weekly updated package search database
  programs.nix-index-database.comma.enable = true;

  home.activation.createScreenShotsDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p "${config.home.homeDirectory}/Pictures/Screenshots"
  '';

  home.activation.createProjectDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # create my project directories if they don't exist
    run mkdir -p "${config.home.homeDirectory}/i"
    # create experiments directory if it doesn't exist
    run mkdir -p "${config.home.homeDirectory}/x"
    # create cloned repositories directory if it doesn't exist
    run mkdir -p "${config.home.homeDirectory}/r"
  '';
}
