{ homedir }:
{

  homebrew = {
    enable = true;
    onActivation = {
      # Workaround for https://github.com/zhaofengli/nix-homebrew/issues/131
      # (masApps install fails during activation when brew auto-update runs).
      # Re-enable once #131 is fixed upstream.
      autoUpdate = false;
      cleanup = "zap";
      # nix-darwin invokes brew through `sudo --preserve-env=PATH`, which drops
      # XDG_CONFIG_HOME from ~/.zshenv; brew then falls back to ~/.homebrew for
      # its trust store (see zhaofengli/nix-homebrew#161). extraEnv is applied
      # after sudo, so the variable survives.
      extraEnv.XDG_CONFIG_HOME = "${homedir}/.config";
    };

    brews = [
      "mas"
    ];

    casks = [
      # Password manager
      "1password"
      "1password-cli"
      # Browser
      "google-chrome"
      # Terminal
      "ghostty"
      # Note
      "obsidian"
      # Utilities
      "karabiner-elements"
      "raycast"
      "logi-options+"
      # AI
      "claude"
      "chatgpt"
      # AI-powered translator
      "nani"
      # IDE
      "visual-studio-code"
      "datagrip"
      # IME
      "azookey"
    ];

    masApps = {
      "RunCat Neo" = 6757801838;
      "Amazon Prime Video" = 545519333;
      "DaisyDisk" = 411643860;
      "moomoo" = 6758005700;
    };
  };
}
