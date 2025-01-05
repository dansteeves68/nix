{
  description = "Dan's latest dotfiles flake";
  # TODO
  # kitty config overwritten
  # link GUI Applications for Spotlight/Alfred
  # warning: /Applications/Nix Apps is not owned by nix-darwin, skipping App linking...
  # faster completions
  # link .config folders

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
          environment.systemPackages = with pkgs; [ vim ];
          fonts.packages = with pkgs; [
            anonymousPro
          ];
          nix.settings.experimental-features = "nix-command flakes";
          nixpkgs.hostPlatform = "x86_64-darwin";
          programs.bash.enable = true;
          programs.zsh.enable = true;
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
      home =
        { pkgs, ... }:
        {
          fonts.fontconfig.enable = true;
          home.packages = with pkgs; [
            nixfmt-rfc-style
            uv
          ];
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
            helix.enable = true;
            kitty.enable = true;
            zed-editor.enable = true;
            zed-editor.extraPackages = with pkgs; [ nixd ];
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
              };
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
