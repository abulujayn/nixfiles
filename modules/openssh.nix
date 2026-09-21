{ lib, ... }:

{
  services.openssh = {
    enable = true;
    settings.KbdInteractiveAuthentication = false;
    extraConfig = lib.mkAfter ''
      Match all
        PasswordAuthentication no
    '';
  };
}
