{ config, lib, ... }:

let
  cfg = config.quadlets.npm;
in
{
  options.quadlets.npm.publishAddress = lib.mkOption {
    type = lib.types.str;
    default = "0.0.0.0";
    description = "Address on which Nginx Proxy Manager publishes ports 80 and 443.";
  };

  config.services.podman = {
    enable = true;

    containers.npm = {
      description = "Nginx Proxy Manager container";
      image = "docker.io/jc21/nginx-proxy-manager";
      autoStart = true;

      ports = [
        "${cfg.publishAddress}:80:80"
        "${cfg.publishAddress}:443:443"
        "127.0.0.1:2777:81"
      ];
      volumes = [
        "/home/abulujayn/.config/containers/data/npm/data/:/data:Z"
        "/home/abulujayn/.config/containers/data/npm/letsencrypt/:/etc/letsencrypt:Z"
      ];

      extraConfig.Container = {
        HealthCmd = "curl -fSs http://localhost:81/";
        Pull = "missing";
      };
    };
  };
}
