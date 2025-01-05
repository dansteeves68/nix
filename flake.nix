{
  description = "Dan's latest dotfiles flake";
  # TODO
  # fonts not working in Zed
  # homebrew applications - add zap feature
  # darwin macOS settings
  # check for others to migrate from dotfiles

  inputs = {
    # nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # nix-darwin
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # homebrew
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    # home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      home-manager,
      nix-darwin,
      nix-homebrew,
      homebrew-bundle,
      homebrew-cask,
      homebrew-core,
      nixpkgs,
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
            helix
            jq
            kitty
            nil
            nixd
            nixfmt-rfc-style
            powerline-symbols
            vim
            zed-editor
          ];
          fonts.packages = with pkgs; [
            anonymousPro
            powerline-symbols
          ];
          homebrew = {
            casks = [
              "1password"
              "alfred"
              "fantastical"
              "marked"
              "moom"
              "multiviewer-for-f1"
              "netnewswire"
              "soulver"
              "steermouse"
              "zoom"
            ];
          };
          nix.settings.experimental-features = "nix-command flakes";
          nixpkgs.hostPlatform = "x86_64-darwin";
          programs.bash.enable = true;
          programs.zsh.enable = true;
          system.activationScripts.applications.text = ''
            echo "setting up /Applications/Nix Apps..." >&2
            rm -rf /Applications/Nix\ Apps
            mkdir -p /Applications/Nix\ Apps
            find ${config.system.build.applications}/Applications -maxdepth 1 -type l | while read -r app; do
              src="$(/usr/bin/stat -f%Y "$app")"
              cp -r "$src" /Applications/Nix\ Apps
            done
          '';
          system.configurationRevision = self.rev or self.dirtyRev or null;
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
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              autoMigrate = true;
              enable = true;
              user = "dan";
            };
          }
        ];
      };
    };
}
