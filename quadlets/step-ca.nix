{ config, lib, ... }:

let
  cfg = config.quadlets.step-ca;
in
{
  options.quadlets.step-ca.publishAddress = lib.mkOption {
    type = lib.types.str;
    description = "IPv4 address on which step-ca publishes its HTTPS port.";
  };

  config.services.podman = {
    enable = true;

    containers.step-ca = {
      description = "step-ca certificate authority";
      image = "docker.io/smallstep/step-ca";
      autoStart = true;

      ports = [ "${cfg.publishAddress}:7837:443" ];
      volumes = [ "step-ca:/home/step" ];

      extraConfig.Container.Pull = "missing";
    };
  };
}
