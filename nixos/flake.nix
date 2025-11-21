{
  description = "Industrial Monitoring Stack NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { self, nixpkgs, sops-nix, ... }@inputs: {
    nixosConfigurations.monitoring-server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./server/configuration.nix
        ./server/hardware-configuration.nix
        sops-nix.nixosModules.sops
      ];
    };

    nixosConfigurations.monitoring-client = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./client/configuration.nix
        ./client/hardware-configuration.nix
        sops-nix.nixosModules.sops
      ];
    };
  };
}
