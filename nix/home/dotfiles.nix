# Symlink dotfiles from this repository to the appropriate locations.
# Application configs go to "$HOME/.config" via xdg.configFile,
# and home directory files go to "$HOME" via home.file.
{
  home.file = {
    ".zshenv".source = ../../home/.zshenv;
  };

  xdg.configFile = {
    # Claude Code
    claude = {
      source = ../../config/claude;
      recursive = true;
    };
    # xdg.configFile with recursive + executable doesn't work,
    # so scripts are placed individually with executable = true.
    "claude/statusline.sh" = {
      source = ../../scripts/claude-statusline.sh;
      executable = true;
    };

    # Ghostty
    ghostty = {
      source = ../../config/ghostty;
      recursive = true;
    };

    # Zsh
    zsh = {
      source = ../../config/zsh;
      recursive = true;
    };

    # Git
    git = {
      source = ../../config/git;
      recursive = true;
    };

    # Starship
    "starship.toml".source = ../../config/starship.toml;

    # Sheldon
    sheldon = {
      source = ../../config/sheldon;
      recursive = true;
    };
  };
}
