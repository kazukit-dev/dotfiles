_: {

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
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
      # "zen"
      # Terminal
      "ghostty"
      # Note
      "obsidian"
      # Utilities
      "raycast"
      # AI
      "claude"
      # Font
      "font-hack-nerd-font"
    ];

    masApps = {
      "Magnet" = 441258766;
      "RunCat" = 1429033973;
      "Amazon Prime Video" = 545519333;
    };
  };
}
