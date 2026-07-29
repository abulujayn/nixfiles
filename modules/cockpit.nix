{ config, ... }:

{
  services.cockpit = {
    enable = true;
    allowed-origins = [
      "http://${config.networking.hostName}:9090"
    ];
    settings.WebService.AllowUnencrypted = true;
  };
}
