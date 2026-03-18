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
      "codex-app"
      # AI-powered translator
      "nani"
      # IDE
      "thebrowsercompany-dia"
      "visual-studio-code"
      "datagrip"
    ];

    masApps = {
      "RunCat" = 1429033973;
      "Amazon Prime Video" = 545519333;
    };
  };
}
