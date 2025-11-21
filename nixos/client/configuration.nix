{ config, pkgs, ... }:

{
  imports = [ ./secrets.nix ];

  networking.hostName = "monitoring-client-1";

  # WireGuard Client
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.2/24" ];
      listenPort = 51820;
      privateKeyFile = config.sops.secrets."wireguard/client1_private_key".path;
      peers = [
        { # Server
          publicKey = "SERVER_PUBLIC_KEY_PLACEHOLDER";
          allowedIPs = [ "10.100.0.0/24" ];
          endpoint = "server.example.com:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  # Filebeat (Logs)
  services.filebeat = {
    enable = true;
    inputs = {
      journald = {
        id = "everything";
        type = "journald";
        include_matches = [];
      };
    };
    output.logstash = {
      hosts = ["10.100.0.1:5044"];
    };
  };

  # Node Exporter (Metrics)
  services.prometheus.exporters.node = {
    enable = true;
    port = 9100;
    enabledCollectors = [ "systemd" ];
  };

  networking.firewall.allowedTCPPorts = [ 9100 ];

  system.stateVersion = "24.05";
}
