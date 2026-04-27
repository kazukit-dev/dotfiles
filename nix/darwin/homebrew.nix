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
      # Beta until 1password-cli stable 2.33.1+ ships a fix for the desktop
      # integration regression (https://github.com/1Password/shell-plugins/issues/587).
      "1password-cli@beta"
      # Browser
      "google-chrome"
      "thebrowsercompany-dia"
      "zen"
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
      "codex-app"
      # AI-powered translator
      "nani"
      # IDE
      "visual-studio-code"
      "datagrip"
      # IME
      "azookey"
    ];

    masApps = {
      "RunCat" = 1429033973;
      "Amazon Prime Video" = 545519333;
      "DaisyDisk" = 411643860;
    };
  };
}
