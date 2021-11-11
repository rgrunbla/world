{ config, pkgs, lib, ... }:

{
  services.sshd.enable = true;

  networking.firewall.allowedTCPPorts = [ 80 ];

  users.users.root.password = "nixos";
  services.openssh.permitRootLogin = lib.mkDefault "yes";
  services.getty.autologinUser = lib.mkDefault "root";
}
