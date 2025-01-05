{
  description = "Dan's latest dotfiles flake";
  # TODO
  # fonts not working in Zed
  # check for others to migrate from dotfiles
  # Alfred setup

  inputs = {
    # nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # nix-darwin
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # home manager
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
            anonymousPro
            coreutils
            curl
            helix
            jq
            kitty
            mas
            nil
            nixd
            nixfmt-rfc-style
            powerline-symbols
            ripgrep
            vim
            wget
            zed-editor
            uv
          ];
          fonts.packages = with pkgs; [
            anonymousPro
            powerline-symbols
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
              "netnewswire"
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
            appswitcher-all-displays = false; # Whether to display the appswitcher on all displays or only the main one. The default is false.
            autohide = true; # Whether to automatically hide and show the dock.
            autohide-delay = 0.1; # Sets the speed of the autohide delay. The default is
            autohide-time-modifier = 0.5; # Sets the speed of the animation when hiding/showing the Dock. The default is given in the example.
            dashboard-in-overlay = false; # Whether to hide Dashboard as a Space. The default is false.
            enable-spring-load-actions-on-all-items = false; # Enable spring loading for all Dock items. The default is false.
            expose-group-apps = false; # Whether to group windows by application in Mission Control's Exposé. The default is true.
            launchanim = false; # Animate opening applications from the Dock. The default is true.
            mineffect = null; # Set the minimize/maximize window effect. The default is genie.
            minimize-to-application = false; # Whether to minimize windows into their application icon. The default is false.
            mouse-over-hilite-stack = false; # Enable highlight hover effect for the grid view of a stack in the Dock.
            mru-spaces = true; # Whether to automatically rearrange spaces based on most recent use. The default is true.
            orientation = "bottom"; # Position of the dock on screen. The default is "bottom".
            show-process-indicators = true;
            show-recents = false;
            showhidden = false; # Whether to make icons of hidden applications tranclucent. The default is false.
            # static-only = true; # Show only open applications in the Dock
            tilesize = 64; # Size of the icons in the dock. The default is 64.
            wvous-bl-corner = 1; # Hot corner action 1 Disabled
            wvous-br-corner = 1; # Hot corner action 1 Disabled
            wvous-tl-corner = 4; # Hot corner action 4 Desktop
            wvous-tr-corner = 1; # Hot corner action 1 Disabled
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
                prompt.theme = "powerline";
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
          # nix-homebrew.darwinModules.nix-homebrew
          # {
          #   nix-homebrew = {
          #     autoMigrate = true;
          #     enable = true;
          #     onActivation = {
          #       autoUpdate = true;
          #       cleanup = "zap";
          #       upgrade = true;
          #     };
          #     user = "dan";
          #   };
          # }
        ];
      };
    };
}
