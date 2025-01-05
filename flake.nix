{
  description = "Dan's latest dotfiles flake";
  # TODO
  # prompt
  # faster completions
  # link .config folders
  # link GUI Applications for Spotlight/Alfred

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      home-manager,
      nix-darwin,
      nixpkgs,
      ...
    }:
    let
      configuration =
        { pkgs, config, ... }:
        {
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = with pkgs; [ vim ];

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Enable alternative shell support in nix-darwin.
          programs.bash.enable = true;
          programs.zsh.enable = true;

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 5;

          users.users = {
            dan = {
              description = "Dan Steeves";
              home = /Users/dan;
              name = "dan";
            };
          };

          # nixpkgs.config.allowBroken = true;
          # The platform the configuration will be used on
          nixpkgs.hostPlatform = "x86_64-darwin";
        };
      home =
        { pkgs, ...}:
        {
          home.stateVersion = "24.11";

          home.packages = with pkgs; [
            uv
          ];

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

            helix.enable = true;
            kitty.enable = true;

            zed-editor.enable = true;

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
              prezto.enable = true;
            };

          };
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake ".#stolen"
      darwinConfigurations."stolen" = nix-darwin.lib.darwinSystem { modules =
        [
          configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.backupFileExtension = "backup";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.dan = home;
          }
        ]; };
    };
}
