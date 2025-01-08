{
  description = "Dan's latest dotfiles flake";
  # TODO
  # Alfred setup
  # what homebrew apps can I move to nixpkgs?

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      home-manager,
      nix-darwin,
      ...
    }:
    let
      # nix darwin
      configuration =
        { pkgs, config, ... }:
        {
          environment.systemPackages = with pkgs; [
            coreutils
            curl
            helix
            jq
            kitty
            mas
            net-news-wire
            nil
            nixd
            nixfmt-rfc-style
            ripgrep
            somafm-cli
            vim
            wget
            zed-editor
            uv
          ];
          fonts.packages = with pkgs; [
            nerd-fonts.anonymice
            nerd-fonts.blex-mono
            nerd-fonts.inconsolata
            nerd-fonts.jetbrains-mono
          ];
          homebrew = {
            onActivation.autoUpdate = true;
            onActivation.cleanup = "zap";
            onActivation.upgrade = true;
            enable = true;
            casks = [
              "1password"
              "alfred"
              "discord"
              "fantastical"
              "marked"
              "moom"
              "multiviewer-for-f1"
              # "netnewswire"
              "soulver"
              "steermouse"
              "zoom"
            ];
            taps = [
              "homebrew/services"
              "nrlquaker/createzap"
            ];
          };
          nix.optimise.automatic = true;
          nix.settings.experimental-features = "nix-command flakes";
          nixpkgs.hostPlatform = "x86_64-darwin";
          programs.bash.enable = true;
          programs.zsh.enable = true;
          security.pam.enableSudoTouchIdAuth = true;
          system.activationScripts.applications.text = ''
            echo "setting up /Applications/Nix Apps..." >&2
            rm -rf /Applications/Nix\ Apps
            mkdir -p /Applications/Nix\ Apps
            find ${config.system.build.applications}/Applications -maxdepth 1 -type l | while read -r app; do
              src="$(/usr/bin/stat -f%Y "$app")"
              cp -r "$src" /Applications/Nix\ Apps
            done
          '';
          system.activationScripts.postUserActivation.text = ''
            # Following line should allow us to avoid a logout/login cycle
            /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
            # Note when working on Dock enable this line or run manually after switch
            # killall Dock
          '';
          system.configurationRevision = self.rev or self.dirtyRev or null;
          system.defaults.alf = {
            globalstate = 1;
            allowsignedenabled = 1;
            allowdownloadsignedenabled = 1;
            stealthenabled = 1;
          };
          system.defaults.dock = {
            appswitcher-all-displays = false;
            autohide = true;
            autohide-delay = 0.1;
            autohide-time-modifier = 0.5;
            dashboard-in-overlay = false;
            enable-spring-load-actions-on-all-items = false;
            expose-group-apps = false;
            launchanim = false;
            mineffect = null;
            minimize-to-application = false;
            mouse-over-hilite-stack = false;
            mru-spaces = true;
            orientation = "bottom";
            show-process-indicators = true;
            show-recents = false;
            showhidden = false;
            tilesize = 64;
            wvous-bl-corner = 1;
            wvous-br-corner = 1;
            wvous-tl-corner = 4;
            wvous-tr-corner = 1;
          };
          system.defaults.finder = {
            AppleShowAllExtensions = true;
            AppleShowAllFiles = true;
            CreateDesktop = false; # Whether to show icons on the desktop or not.
            FXEnableExtensionChangeWarning = true;
            FXPreferredViewStyle = "Nlsv";
            ShowPathbar = true;
            ShowStatusBar = false;
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
            _HIHideMenuBar = false;
          };
          system.keyboard = {
            enableKeyMapping = true;
            remapCapsLockToEscape = true;
          };
          system.stateVersion = 5;
          users.users = {
            dan = {
              description = "Dan Steeves";
              home = /Users/dan;
              name = "dan";
            };
          };
        };
      # home manager
      home =
        { ... }:
        {
          fonts.fontconfig.enable = true;
          home.packages = [ ];
          home.sessionVariables = {
            EDITOR = "hx";
            HOMEBREW_AUTO_UPDATE_SECS = 50000;
            VISUAL = "zeditor";
          };
          home.stateVersion = "24.11";
          programs = {
            home-manager.enable = true;
            gh.enable = true;
            git = {
              enable = true;
              extraConfig = {
                push.autoSetupRemote = true;
              };
              ignores = [ ".DS_Store" ];
              userEmail = "dan@thesteeves.org";
              userName = "dansteeves68";
            };
            zsh = {
              enable = true;
              autocd = true;
              autosuggestion.enable = true;
              enableCompletion = true;
              defaultKeymap = "viins"; # emacs, vicmd, or viins
              history = {
                expireDuplicatesFirst = true;
                extended = true;
                ignoreDups = true;
                ignorePatterns = [ ];
                ignoreSpace = true;
                save = 10000;
                share = true;
                size = 10000;
              };
              prezto = {
                enable = true;
                caseSensitive = false;
                color = true;
                editor.keymap = "vi";
                prompt.theme = "steeef";
                ssh.identities = [ ];
                terminal.tabTitleFormat = "%m: %s";
              };
              # syntaxHighlighting.enable = true;
            };
          };
        };

    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake ".#stolen"
      darwinConfigurations."stolen" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.backupFileExtension = "backup";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.dan = home;
          }
        ];
      };
    };
}
