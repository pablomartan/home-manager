{
  description = "Home Manager configuration of pablo";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:pablomartan/nixvim";
    };
    nixgl.url = "github:nix-community/nixGL";
    autofirma.url = "github:pablomartan/cliente-autofirma";
  };

  outputs = {
    nixpkgs,
    home-manager,
    nixvim,
    nixgl,
    autofirma,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations."pablo" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [
        ./home.nix
        ./config.nix
        {
          nixpkgs.overlays = [
            nixgl.overlay
            (final: prev: {
              neovim = nixvim.packages.${system}.default;
              autofirma = autofirma.packages.${system}.default;
            })
          ];
        }
      ];
    };
  };
}
