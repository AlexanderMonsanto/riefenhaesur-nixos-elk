{ config, pkgs, ... }:

{
  imports = [ ./secrets.nix ];

  networking.hostName = "monitoring-server";
  networking.firewall.allowedTCPPorts = [ 80 443 9200 5601 3000 9090 9093 ];
  networking.firewall.allowedUDPPorts = [ 51820 ]; # WireGuard

  # Enable Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.autoPrune.enable = true;

  # System packages
  environment.systemPackages = with pkgs; [
    docker-compose
    git
    vim
    htop
    sops
  ];

  # WireGuard Server
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.1/24" ];
      listenPort = 51820;
      privateKeyFile = config.sops.secrets."wireguard/server_private_key".path;
      peers = [
        { # Client 1
          publicKey = "CLIENT_PUBLIC_KEY_PLACEHOLDER";
          allowedIPs = [ "10.100.0.2/32" ];
        }
      ];
    };
  };

  system.stateVersion = "24.05";
}
