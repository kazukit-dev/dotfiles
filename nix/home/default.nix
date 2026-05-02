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
  imports = [
    inputs.nix-index-database.homeModules.nix-index
    inputs.agent-skills.homeManagerModules.default
    ./dotfiles.nix
    ./packages.nix
    ./agent-skills.nix
  ];

  programs = {
    home-manager.enable = true;

    # nix-index-database: weekly updated package search database
    nix-index-database.comma.enable = true;

    # direnv: automatically load/unload dev environments
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      config.global = {
        log_format = "-";
        log_filter = "^$";
      };
    };
  };

  home.activation.createScreenShotsDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p "${config.home.homeDirectory}/Pictures/Screenshots"
  '';
  home.activation.createGhqDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p "${config.home.homeDirectory}/ghq"
  '';
  home.activation.createTmpDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p "${config.home.homeDirectory}/tmp"
  '';

}
