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
  xdg.configFile = {
    claude = {
      source = ../../../config/claude;
      recursive = true;
    };
    # xdg.configFile with recursive + executable doesn't work,
    # so scripts are placed individually with executable = true.
    "claude/statusline.sh" = {
      source = ../../../scripts/claude-statusline.sh;
      executable = true;
    };
  };
}
