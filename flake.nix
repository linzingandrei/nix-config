{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    lsfg-vk-flake.url = "github:pabloaul/lsfg-vk-flake/main";
    lsfg-vk-flake.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, self, lsfg-vk-flake, ... }@inputs:
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = {
        inherit self inputs;
      };
      modules = [
        ./configuration.nix

        lsfg-vk-flake.nixosModules.default
      ];
    };
  };
}
