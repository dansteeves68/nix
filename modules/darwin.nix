{
  config,
  pkgs,
  self,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    aria2 # bittorrent client
    azure-cli
    bash-language-server
    choose
    coreutils
    curl
    dust
    ffmpeg
    gawk
    gnumake
    gnused
    gping
    graph-easy
    helix
    httpie
    hugo
    jq-lsp
    kitty
    marksman
    mas
    meld
    net-news-wire
    nil
    nixd
    nixfmt
    prettier
    procs
    rustup
    somafm-cli
    taplo
    tenv
    terraform-docs
    terraform-ls
    toml-sort
    wget
    yaml-language-server
    yt-dlp
  ];
  fonts.packages = with pkgs; [
    nerd-fonts.anonymice
    nerd-fonts.blex-mono
    nerd-fonts.inconsolata
    nerd-fonts.jetbrains-mono
  ];
  ids.gids.nixbld = 30000;
  nix.enable = false; # false because using Determinate nix
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "x86_64-darwin";
  programs.bash.enable = true;
  programs.zsh.enable = true;
  security.pam.services.sudo_local.touchIdAuth = true;
  users.users.dan = {
    description = "Dan Steeves";
    home = "/Users/dan";
    name = "dan";
  };
  system.primaryUser = "dan";
  system.activationScripts.applications.text = ''
    echo "setting up /Applications/Nix Apps..." >&2
    rm -rf /Applications/Nix\ Apps
    mkdir -p /Applications/Nix\ Apps
    find ${config.system.build.applications}/Applications -maxdepth 1 -type l | while read -r app; do
      src="$(/usr/bin/stat -f%Y "$app")"
      cp -r "$src" /Applications/Nix\ Apps
    done
  '';
  # system.activationScripts.postUserActivation.text = ''
  # /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  # '';
  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.defaults.alf = {
    # globalstate = 1;
    # allowsignedenabled = 1;
    # allowdownloadsignedenabled = 1;
    # stealthenabled = 1;
  };
  system.defaults.dock = {
    appswitcher-all-displays = false;
    autohide = true;
    autohide-delay = 0.1;
    autohide-time-modifier = 0.5;
    dashboard-in-overlay = false;
    enable-spring-load-actions-on-all-items = false;
    expose-group-apps = false;
    largesize = null;
    launchanim = false;
    magnification = false;
    mineffect = "suck";
    minimize-to-application = true;
    mouse-over-hilite-stack = false;
    mru-spaces = true;
    orientation = "bottom";
    # persistent-apps = [ ];
    # persistent-others = [ ];
    show-process-indicators = true;
    show-recents = false;
    showhidden = false;
    # static-only = true;
    tilesize = 64;
    wvous-bl-corner = 1;
    wvous-br-corner = 1;
    wvous-tl-corner = 1;
    wvous-tr-corner = 4;
  };
  system.defaults.finder = {
    AppleShowAllExtensions = true;
    AppleShowAllFiles = true;
    CreateDesktop = false; # Whether to show icons on the desktop or not.
    FXDefaultSearchScope = "SCcf";
    FXEnableExtensionChangeWarning = true;
    FXPreferredViewStyle = "Nlsv";
    ShowPathbar = true;
    ShowStatusBar = true;
    QuitMenuItem = true;
  };
  system.defaults.loginwindow = {
    GuestEnabled = false;
    DisableConsoleAccess = true;
  };
  system.defaults.screencapture.location = "~/Screenshots/";
  system.defaults.spaces.spans-displays = false;
  system.defaults.trackpad = {
    Clicking = true; # true to enable tap-to-click
    TrackpadRightClick = true;
  };
  system.defaults.NSGlobalDomain = {
    # "com.apple.trackpad.scaling" = 3.0;
    AppleInterfaceStyleSwitchesAutomatically = true;
    # AppleMeasurementUnits = "Centimeters";
    # AppleMetricUnits = 1;
    AppleShowScrollBars = "Automatic";
    # AppleTemperatureUnit = "Celsius";
    InitialKeyRepeat = 15;
    KeyRepeat = 2;
    NSAutomaticCapitalizationEnabled = false;
    NSAutomaticDashSubstitutionEnabled = false;
    NSAutomaticPeriodSubstitutionEnabled = false;
    # _HIHideMenuBar = true;
  };
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };
  system.stateVersion = 5;
}
