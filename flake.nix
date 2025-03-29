{
  description = "Dan's latest dotfiles flake";

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
      nixpkgs,
      ...
    }:
    let
      inherit (nixpkgs) lib;

      my-nix-darwin-with-homebrew =
        { pkgs, config, ... }:
        {
          environment.systemPackages = with pkgs; [
            awscli2
            choose
            coreutils
            curl
            duf
            dust
            eza
            gping
            helix
            htop
            jq
            kitty
            lsd
            mas
            net-news-wire
            nil
            nixd
            nixfmt-rfc-style
            nodePackages.prettier
            procs
            ripgrep
            somafm-cli
            tenv
            tldr
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
            brews = [ ];
            casks = [
              "1password"
              "alfred"
              "fantastical"
              "firefox"
              "marked"
              "moom"
              "multiviewer-for-f1"
              "soulver"
              "steermouse"
            ];
            masApps = { };
            taps = [
              "homebrew/bundle"
              "homebrew/cask"
              "homebrew/core"
              "homebrew/services"
              "nrlquaker/createzap"
            ];
          };
          ids.gids.nixbld = 30000;
          nix.optimise.automatic = true;
          nix.settings.experimental-features = "nix-command flakes";
          nixpkgs.hostPlatform = config.machine.platform;
          programs.bash.enable = true;
          programs.zsh.enable = true;
          security.pam.services.sudo_local.touchIdAuth = true;
          security.sudo.extraConfig = ""; # TODO: would love to not enter password when running darwin-rebuild
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
            /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
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
            largesize = null;
            launchanim = false;
            magnification = false;
            mineffect = "suck";
            minimize-to-application = true;
            mouse-over-hilite-stack = false;
            mru-spaces = true;
            orientation = "bottom";
            # persistent-apps = [ ];
            persistent-others = [
              "~/Downloads"
              "~/Screenshots"
            ];
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
            _HIHideMenuBar = false;
          };
          system.keyboard = {
            enableKeyMapping = true;
            remapCapsLockToEscape = true;
          };
          system.stateVersion = 5;
        };

      my-home-manager =
        {
          git-username,
          git-email,
        }:
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
            bat.enable = true;
            fd.enable = true;
            gh.enable = true;
            git = {
              enable = true;
              extraConfig = {
                branch.sort = "-committerdate";
                column.ui = "auto";
                diff.algorithm = "histogram";
                diff.colorMoved = "plain";
                diff.mnemonicPrefix = true;
                diff.renames = true;
                fetch.all = true;
                fetch.prune = true;
                fetch.pruneTags = true;
                push.autoSetupRemote = true;
                push.default = "simple";
                push.followTags = true;
                tag.sort = "version:refname";
              };
              ignores = [ ".DS_Store" ];
              userEmail = git-email;
              userName = git-username;
            };
            mcfly.enable = true;
            ssh = {
              enable = true;
              addKeysToAgent = "yes";
              forwardAgent = true;
              extraConfig = ''
                AddKeysToAgent yes
                UseKeychain yes
              '';
            };
            zoxide = {
              enable = true;
              enableZshIntegration = true;
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
                # order of pmodules matters, see prezto documentation
                pmodules = [
                  "git"
                  "prompt"
                  "spectrum"
                  "ssh"
                  "terminal"
                  "utility"
                  "completion"
                ];
                prompt.theme = "steeef";
                ssh.identities = [
                  "id_rsa"
                  "id_rsa_bastion"
                ];
                terminal.autoTitle = true;
              };
              shellAliases = {
                cat = "bat";
                drs = ''darwin-rebuild switch --flake ".#$(uname -n)"'';
                ls = "eza";
              };
              syntaxHighlighting.enable = true;
            };
          };
        };

      machines = {
        LN7YNX3G7 = {
          platform = "aarch64-darwin";
          user = {
            username = "c079373";
            git = {
              username = "dan-steeves_thrivent";
              email = "dan.steeves@thrivent.com";
            };
          };
        };
        stolen = {
          platform = "x86_64-darwin";
          user = {
            git = {
              username = "dansteeves68";
              email = "dan@thesteeves.org";
            };
            username = "dan";
          };
        };
      };

      mkMachineConfig =
        { git, username }:
        {
          users.users.${username} = {
            description = "Dan Steeves";
            home = "/Users/${username}";
            name = username;
          };
        };

      mkDarwinConfig =
        name: machineConfig:
        nix-darwin.lib.darwinSystem {
          modules = [
            my-nix-darwin-with-homebrew
            {
              options.machine.platform = lib.mkOption {
                type = lib.types.str;
                description = "The platform architecture for this machine";
              };
              config.machine.platform = machineConfig.platform;
            }
            (mkMachineConfig machineConfig.user)
            home-manager.darwinModules.home-manager
            {
              home-manager.backupFileExtension = "backup";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${machineConfig.user.username} = my-home-manager {
                git-username = machineConfig.user.git.username;
                git-email = machineConfig.user.git.email;
              };
            }
          ];
        };

    in
    {
      darwinConfigurations = builtins.mapAttrs (
        name: machineConfig: mkDarwinConfig name machineConfig
      ) machines;
    };
}
