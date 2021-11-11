{ machineName ? "Default"
, hardwareConfiguration ? ./hardware-configuration.nix
, commonConfiguration ? ./common-configuration.nix
}:

let
  machineConfiguration = ../machines/${machineName}/configuration.nix;
  pkgs = import <nixpkgs> { };
  lib = pkgs.lib;
  eval = import <nixpkgs/nixos/lib/eval-config.nix> {
    system = pkgs.system;
    modules =
      [ machineConfiguration hardwareConfiguration commonConfiguration ];
    inherit pkgs;
  };
in
import <nixpkgs/nixos/lib/make-zfs-image.nix> {
  inherit lib pkgs;
  includeChannel = false;
  config = eval.config;
  contents = [
    {
      source = ./common-configuration.nix;
      target = "/etc/nixos/common-configuration.nix";
    }
    {
      source = ./hardware-configuration.nix;
      target = "/etc/nixos/hardware-configuration.nix";
    }
    {
      source = ./configuration.nix;
      target = "/etc/nixos/configuration.nix";
    }
    {
      source = machineConfiguration;
      target = "/etc/nixos/machine-configuration.nix";
    }
    {
      source = ../machines/${machineName}/secrets/ssh_host_ed25519_key;
      target = "/etc/ssh/ssh_host_ed25519_key";
    }
    {
      source = ../machines/${machineName}/secrets/ssh_host_ed25519_key.pub;
      target = "/etc/ssh/ssh_host_ed25519_key.pub";
    }
  ];
  datasets = {
    "tank/system/root".mount = "/";
  };

  rootSize = 50000;
  bootSize = 1000;
  rootPoolProperties = {
    ashift = 12;
    autoexpand = "on";
  };
  format = "qcow2";
}
