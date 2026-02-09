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
      ".zshenv".source = ../../../home/.zshenv;
    };
  };

  xdg.configFile.zsh = {
    source = ../../../config/zsh;
    recursive = true;
  };
}
