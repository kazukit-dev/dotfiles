_: {

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
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
      "1password-cli"
      # Browser
      "google-chrome"
      # "zen"
      # Terminal
      "ghostty"
      "cmux"
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
