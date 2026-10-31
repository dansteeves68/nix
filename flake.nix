{
  description = "Dan's latest dotfiles flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
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
      machines = {
        LN7YNX3G7 = {
          platform = "aarch64-darwin";
          username = "c079373";
          git = {
            username = "dan-steeves_thrivent";
            email = "dan.steeves@thrivent.com";
          };
        };
        ibish = {
          platform = "x86_64-darwin";
          username = "dan";
          git = {
            username = "dansteeves68";
            email = "dan@thesteeves.org";
          };
        };
      };

      mkDarwinConfig =
        machine:
        nix-darwin.lib.darwinSystem {
          specialArgs = { inherit self machine; };
          modules = [
            ./modules/darwin.nix
            ./modules/homebrew.nix
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                enableRosetta = machine.platform != "x86_64-darwin";
                user = machine.username;
                autoMigrate = true;
              };
            }
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                backupFileExtension = "backup";
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit machine; };
                users.${machine.username} = ./modules/home.nix;
              };
            }
          ];
        };
    in
    {
      darwinConfigurations = builtins.mapAttrs (_: mkDarwinConfig) machines;
    };
}
