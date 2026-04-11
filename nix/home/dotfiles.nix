# Symlink dotfiles from this repository to the appropriate locations.
# Uses mkOutOfStoreSymlink to create direct symlinks to the repository,
# so changes take effect immediately without running `nix run .#switch`.
{
  config,
  ...
}:
let
  dotfilesPath = "${config.home.homeDirectory}/dotfiles";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${path}";
in
{
  home.file = {
    ".zshenv".source = mkLink "home/.zshenv";
  };

  xdg.configFile = {
    # 1password
    "1Password/ssh".source = mkLink "config/1Password/ssh";
    # Claude Code
    "claude/settings.json".source = mkLink "config/claude/settings.json";
    "claude/statusline.sh".source = mkLink "config/claude/statusline.sh";
    "claude/skills".source = mkLink "config/claude/skills";
    # cspell (referenced from VSCode settings etc.)
    "cspell".source = mkLink "config/cspell";
    # Ghostty
    "ghostty".source = mkLink "config/ghostty";
    # Zsh
    "zsh".source = mkLink "config/zsh";
    # Git
    "git".source = mkLink "config/git";
    # Lazygit
    "lazygit".source = mkLink "config/lazygit";
    # Starship
    "starship.toml".source = mkLink "config/starship.toml";
    # Sheldon
    "sheldon".source = mkLink "config/sheldon";
    # Gomi
    "gomi".source = mkLink "config/gomi";
    # Karabiner-Elements
    "karabiner".source = mkLink "config/karabiner";
    # Zeno
    "zeno".source = mkLink "config/zeno";
    # Neovim
    "nvim".source = mkLink "config/nvim";
  };
}
