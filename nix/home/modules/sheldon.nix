{
  pkgs,
  ...
}:
{
  home = {
    packages = with pkgs; [
      sheldon
    ];
  };
  xdg.configFile.sheldon = {
    source = ../../../config/sheldon;
    recursive = true;
  };
}
