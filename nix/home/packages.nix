{
  pkgs,
  ...
}:
{
  home = {
    packages = with pkgs; [
      curl
      awscli2
      jq
      tree
      pnpm
      nodejs_24
      eza # modern ls alternative
      zoxide # smarter cd command
      fzf # fuzzy finder for zoxide
      lazygit # terminal UI for git
      nixd # nix lsp server
    ];
  };
}
