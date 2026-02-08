{
  pkgs,
  ...
}:
{
  home = {
    packages = with pkgs; [
      claude-code
    ];
  };
  xdg.configFile.claude = {
    source = ../../../config/claude;
    recursive = true;
  };
}
