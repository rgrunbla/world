{ config, pkgs, lib, ... }:

{
  imports = [
    ./common-configuration.nix
    ./hardware-configuration.nix
    ./machine-configuration.nix
  ];
}
