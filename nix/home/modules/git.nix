{
  pkgs,
  ...
}:
{
  home = {
    packages = with pkgs; [
      git
    ];
  };
  xdg.configFile.git = {
    source = ../../../config/git;
    recursive = true;
  };
}
