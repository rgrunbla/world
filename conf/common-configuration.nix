{ config, pkgs, lib, options, ... }:

{
  # mount tmpfs on /tmp
  boot.tmpOnTmpfs = lib.mkDefault true;

  # install basic packages
  environment.systemPackages = with pkgs; [
    tmux
    tcpdump
    dnsutils
    wget
    curl
    htop
    vim
  ];

  #Allow proxmox to reboot the images
  services.acpid.enable = true;

  # Size reduction

  ## Limit the locales we use
  i18n = {
    supportedLocales = [ "fr_FR.UTF-8/UTF-8" ];
    defaultLocale = "fr_FR.UTF-8";
    glibcLocales = pkgs.glibcLocales.override {
      allLocales = false;
      locales = [ "fr_FR.UTF-8/UTF-8" ];
    };
  };

  programs.bash.enableCompletion = true;
  # Enable the serial console on ttyS0
  systemd.services."serial-getty@ttyS0".enable = true;

  ## Remove polkit. It depends on spidermonkey !
  security.polkit.enable = false;

  ## Remove documentation
  documentation.enable = false;
  documentation.nixos.enable = false;
  documentation.man.enable = false;
  documentation.info.enable = false;
  documentation.doc.enable = false;

  ## Disable udisks, sounds, …
  services.udisks2.enable = false;
  xdg.sounds.enable = false;

  ## Optimize store
  nix.autoOptimiseStore = true;

  # Enable time sync
  services.timesyncd.enable = true;

  # Enable the firewall
  networking = {
    useDHCP = false;
    usePredictableInterfaceNames = false;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };
  };

  # SSH
  services.sshd.enable = true;
  services.openssh = { passwordAuthentication = false; };
  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDwZm6kUsK/FrgJPzFi5AgvqIIYfy5S/Se4/rZgB4Edx remy@typhoon"
    ];
  };

  # Sops-nix
  imports = [
    "${
      builtins.fetchTarball
      "https://github.com/Mic92/sops-nix/archive/master.tar.gz"
    }/modules/sops"
  ];

  # compatible NixOS release
  system.stateVersion = "21.05";
}
