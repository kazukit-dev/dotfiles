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
      "karabiner-elements"
      "raycast"
      # AI
      "claude"
      # AI-powered translator
      "nani"
    ];

    masApps = {
      "RunCat" = 1429033973;
      "Amazon Prime Video" = 545519333;
    };
  };
}
