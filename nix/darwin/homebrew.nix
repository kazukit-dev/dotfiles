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

    taps = [
      "manaflow-ai/cmux"
    ];

    brews = [
      "mas"
    ];

    casks = [
      # Password manager
      "1password"
      # Beta until 1password-cli stable 2.33.1+ ships a fix for the desktop
      # integration regression (https://github.com/1Password/shell-plugins/issues/587).
      "1password-cli@beta"
      # Browser
      "google-chrome"
      # Terminal
      "ghostty"
      "cmux"
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
