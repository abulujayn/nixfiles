{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    citrix-workspace
  ];
}
