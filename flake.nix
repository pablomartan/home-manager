{
  description = "Home Manager configuration of pablo";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:pablomartan/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs.url = "github:pablomartan/emacs-config?ref=home";
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    nixvim,
    emacs,
    nixgl,
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
              emacs = emacs.packages.${system}.default;
            })
          ];
        }
      ];
    };
  };
}
