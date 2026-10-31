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
    {
      darwinConfigurations.ibish = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit self; };
        modules = [
          ./modules/darwin.nix
          ./modules/homebrew.nix
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              user = "dan";
              autoMigrate = true;
            };
          }
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              backupFileExtension = "backup";
              useGlobalPkgs = true;
              useUserPackages = true;
              users.dan = ./modules/home.nix;
            };
          }
        ];
      };
    };
}
