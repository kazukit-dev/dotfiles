_: {
  # Enable Touch ID authentication for sudo
  security.pam.services.sudo_local.touchIdAuth = true;
  security.pam.services.sudo_local.watchIdAuth = true;

  system = {
    stateVersion = 5;
    primaryUser = "kazuki";

    defaults = {
      # -------------------------------------------------------------------------
      # Menu Bar Clock
      # -------------------------------------------------------------------------
      menuExtraClock = {
        # Use 24-hour clock
        Show24Hour = true;
        # Show the full date (0 = when space allows)
        ShowDate = 0;
        # Show day of week
        ShowDayOfWeek = true;
      };

      # -------------------------------------------------------------------------
      # Control Center
      # -------------------------------------------------------------------------
      controlcenter = {
        BatteryShowPercentage = true;
        Sound = true;
        NowPlaying = true;
      };

      # -------------------------------------------------------------------------
      # Dock
      # -------------------------------------------------------------------------
      dock = {
        # Whether to automatically hide/show the dock
        autohide = true;
        # Size of the icons in the dock
        tilesize = 45;
        # Persistent applications in the dock
        persistent-apps = [
          "/System/Applications/System Settings.app"
          "/System/Applications/Mail.app"
        ];
        # Whether to show recent applications in the dock
        show-recents = false;
        # Enable magnification on hover
        magnification = true;
        # Icon size when magnified (16-128)
        largesize = 64;
        # Set the minimize/maximize window effect
        mineffect = "genie";
        # Dock position
        orientation = "bottom";
      };

      # -------------------------------------------------------------------------
      # Finder
      # -------------------------------------------------------------------------
      finder = {
        # Whether to always show file extensions
        AppleShowAllExtensions = true;
        # Whether to always show hidden files
        AppleShowAllFiles = true;
        # Show path breadcrumbs in finder windows
        ShowPathbar = true;
        # Default finder view ("Nlsv" = List view)
        FXPreferredViewStyle = "Nlsv";
      };

      # --------------------------------------------------------------------------
      # Global settings
      # --------------------------------------------------------------------------
      NSGlobalDomain = {
        # Dark mode
        AppleInterfaceStyle = "Dark";

        # Keyboard
        ## Key repeat rate (lower is faster, 0 is fastest)
        KeyRepeat = 2;
        # Initial key repeat delay
        InitialKeyRepeat = 25;

        # Trackpad
        ## Trackpad tracking speed (0 to 3)
        "com.apple.trackpad.scaling" = 3.0;
        ## Natural scrolling
        "com.apple.swipescrolldirection" = true;
      };

      # --------------------------------------------------------------------------
      # Trackpad
      # --------------------------------------------------------------------------
      trackpad = {
        # Enable tap to click
        Clicking = true;
        # Enable trackpad right click (two-finger tap/click)
        TrackpadRightClick = true;
        # Enable two-finger double tap to zoom
        TrackpadTwoFingerDoubleTapGesture = true;
        # Enable pinch to zoom
        TrackpadPinch = true;
        # Enable rotate gesture
        TrackpadRotate = true;
        # Enable four-finger swipe down for Mission Control, up for App Expose
        TrackpadFourFingerVertSwipeGesture = 2;
        # Enable four-finger swipe left/right to switch full-screen apps
        TrackpadFourFingerHorizSwipeGesture = 2;
        # Enable three-finger drag
        TrackpadThreeFingerDrag = true;
      };

      # --------------------------------------------------------------------------
      # Mouse (GlobalPreferences)
      # --------------------------------------------------------------------------
      ".GlobalPreferences" = {
        ## Mouse tracking speed (0 to 3)
        "com.apple.mouse.scaling" = 3.0;
      };

      # --------------------------------------------------------------------------
      # WindowManager
      # --------------------------------------------------------------------------
      WindowManager = {
        # Stage Manager
        GloballyEnabled = false;
      };

      # --------------------------------------------------------------------------
      # Screen Capture
      # --------------------------------------------------------------------------
      screencapture = {
        location = "~/Pictures/Screenshots";
        type = "png";
      };
    };
  };
}
