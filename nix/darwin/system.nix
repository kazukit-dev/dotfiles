_: {
  system = {
    stateVersion = 5;
    primaryUser = "kazuki";

    defaults = {
      controlcenter = {
        BatteryShowPercentage = true;
        Sound = true;
        NowPlaying = true;
      };

      dock = {
        autohide = true; # Automatically hide and show the Dock
        tilesize = 45; # Icon size
        persistent-apps = [ ];
        show-recents = false; # Don't show recent applications
        mineffect = "genie";
        orientation = "bottom"; # Dock position
      };

      finder = {
        AppleShowAllExtensions = true; # Show all file extensions
        AppleShowAllFiles = true; # Show hidden files
        ShowPathbar = true; # Show path breadcrumbs
        FXPreferredViewStyle = "Nlsv"; # List view
      };

      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark"; # Use dark mode

        # Keyboard settings
        KeyRepeat = 2; # Faster key repeat
        InitialKeyRepeat = 25; # Initial key repeat delay

        # Trackpad settings
        "com.apple.trackpad.scaling" = 3.0; # Trackpad tracking speed (0 to 3)
        "com.apple.swipescrolldirection" = true; # Natural scrolling
      };

      trackpad = {
        Clicking = true; # Enable tap to click
        TrackpadRightClick = true; # Enable trackpad right click (two-finger tap/click)
        TrackpadTwoFingerDoubleTapGesture = true; # Enable two-finger double tap to zoom
        TrackpadPinch = true; # Enable pinch to zoom
        TrackpadRotate = true; # Enable rotate gesture
        TrackpadFourFingerVertSwipeGesture = 2; # Enable four-finger swipe down for Mission Control, up for App Expose
        TrackpadFourFingerHorizSwipeGesture = 2; # Enable four-finger swipe left/right to switch full-screen apps
        TrackpadThreeFingerDrag = true; # Enable three-finger drag
      };

      screencapture = {
        location = "~/Pictures/Screenshots";
        type = "png";
      };
    };
  };
}
