{
  description = "Dan's latest dotfiles flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      home-manager,
      nix-darwin,
      nix-homebrew,
      nixpkgs,
      ...
    }:
    let
      inherit (nixpkgs) lib;

      my-nix-darwin-with-homebrew =
        { pkgs, config, ... }:
        {
          environment.systemPackages = with pkgs; [
            azure-cli
            bash-language-server
            choose
            coreutils
            curl
            dust
            gawk
            gnused
            gping
            helix
            httpie
            jq-lsp
            kitty
            marksman
            mas
            net-news-wire
            nil
            nixd
            nixfmt-rfc-style
            nodePackages.prettier
            procs
            somafm-cli
            taplo-lsp
            tenv
            terraform-ls
            toml-sort
            wget
            yaml-language-server
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
              # everywhere
              "1password"
              "alfred"
              "cardhop"
              "fantastical"
              "firefox"
              "marked-app"
              "moom"
              "steermouse"
            ]
            ++ (
              if config.system.primaryUser == "dan" then
                [
                  # personal only
                  "discord"
                  "multiviewer-for-f1"
                  "ungoogled-chromium"
                ]
              else
                [ ]
            )
            ++ (
              if config.system.primaryUser == "c079373" then
                [
                  # work only
                ]
              else
                [ ]
            );
            taps = [
              "nrlquaker/createzap"
            ];
          };
          ids.gids.nixbld = 30000;
          nix.enable = false;
          # nix.optimise.automatic = true;
          # nix.settings.experimental-features = "nix-command flakes";
          nixpkgs.config.allowUnfree = true;
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
        };

      my-home-manager =
        {
          git-username,
          git-email,
        }:
        { pkgs, ... }:

        {
          fonts.fontconfig.enable = true;
          home.packages = [ ];
          home.sessionPath = [ "$HOME/.local/bin" ];
          home.sessionVariables = {
            EDITOR = "hx";
            HOMEBREW_AUTO_UPDATE_SECS = 50000;
            VISUAL = "hx";
          };
          home.stateVersion = "24.11";
          programs = {
            home-manager.enable = true;
            awscli.enable = true;
            bat = {
              config = {
                theme = "Nord";
              };
              enable = true;
            };
            btop = {
              settings = {
                color_theme = "Nord";
              };
              themes = {
                Nord = ''
                  theme[available_end]="#ECEFF4"
                  theme[available_mid]="#88C0D0"
                  theme[available_start]="#81A1C1"
                  theme[cached_end]="#ECEFF4"
                  theme[cached_mid]="#88C0D0"
                  theme[cached_start]="#81A1C1"
                  theme[cpu_box]="#4C566A"
                  theme[cpu_end]="#ECEFF4"
                  theme[cpu_mid]="#88C0D0"
                  theme[cpu_start]="#81A1C1"
                  theme[div_line]="#4C566A"
                  theme[download_end]="#ECEFF4"
                  theme[download_mid]="#88C0D0"
                  theme[download_start]="#81A1C1"
                  theme[free_end]="#ECEFF4"
                  theme[free_mid]="#88C0D0"
                  theme[free_start]="#81A1C1"
                  theme[hi_fg]="#5E81AC"
                  theme[inactive_fg]="#4C566A"
                  theme[main_bg]="#2E3440"
                  theme[main_fg]="#D8DEE9"
                  theme[mem_box]="#4C566A"
                  theme[net_box]="#4C566A"
                  theme[proc_box]="#4C566A"
                  theme[proc_misc]="#5E81AC"
                  theme[selected_bg]="#4C566A"
                  theme[selected_fg]="#ECEFF4"
                  theme[temp_end]="#ECEFF4"
                  theme[temp_mid]="#88C0D0"
                  theme[temp_start]="#81A1C1"
                  theme[title]="#8FBCBB"
                  theme[upload_end]="#ECEFF4"
                  theme[upload_mid]="#88C0D0"
                  theme[upload_start]="#81A1C1"
                  theme[used_end]="#ECEFF4"
                  theme[used_mid]="#88C0D0"
                  theme[used_start]="#81A1C1"
                '';
              };
              enable = true;
            };
            eza = {
              colors = "auto";
              enableZshIntegration = true;
              enable = true;
            };
            fd.enable = true;
            gh.enable = true;
            gh.extensions = [ pkgs.gh-copilot ];
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
            htop.enable = true;
            jq.enable = true;
            lsd = {
              enable = true;
              enableZshIntegration = true;
            };
            mcfly.enable = true;
            ripgrep.enable = true;
            ripgrep-all.enable = true;
            ssh = {
              enable = true;
              addKeysToAgent = "yes";
              forwardAgent = true;
              extraConfig = ''
                AddKeysToAgent yes
                UseKeychain yes
              '';
            };
            uv.enable = true;
            vim = {
              enable = true;
              plugins = [ pkgs.vimPlugins.nord-vim ];
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
                ghrw = ''
                  gh run watch $(gh run list --workflow lambda_on_push.yml --limit 1 --json databaseId --jq ".[0].databaseId")
                '';
                gst = "git status";
                gstg = "git stage";
                vi = "vim";
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
        ibish = {
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
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                enableRosetta = if machineConfig.platform == "x86_64-darwin" then false else true;
                user = machineConfig.user.username;
                autoMigrate = true;
              };
            }
            my-nix-darwin-with-homebrew
            {
              options.machine.platform = lib.mkOption {
                type = lib.types.str;
                description = "The platform architecture for this machine";
              };
              config.machine.platform = machineConfig.platform;
              config.system.primaryUser = machineConfig.user.username;
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
