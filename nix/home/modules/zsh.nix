{
  pkgs,
  ...
}:
{
  home = {
    packages = with pkgs; [
      zsh
    ];
    file = {
      ".zshenv" = ../../../../home/.zshenv;
    };
  };

  xdg.configFile.zsh = {
    source = ../../../config/zsh;
    recursive = true;
  };
}
