{ config, lib, pkgs, ... }: {

  fileSystems."/" = {
    device = "tank/system/root";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/ESP";
    fsType = "vfat";
  };

  networking.hostId = "00000000";

  services.zfs.expandOnBoot = "all";

  boot = {
    zfs.devNodes = "/dev/";
    growPartition = true;

    loader.grub = {
      version = 2;
      device = "nodev";
      efiSupport = true;
      efiInstallAsRemovable = true;
      font = "${pkgs.grub2_efi}/share/grub/unicode.pf2";
      extraConfig = ''
        serial --unit=0 --speed=115200 --word=8 --parity=no --stop=1
        terminal_output serial
        terminal_input serial
      '';
    };

    initrd = {
      network.enable = false;
      availableKernelModules = [
        "virtio_net"
        "virtio_pci"
        "virtio_mmio"
        "virtio_blk"
        "virtio_scsi"
        "kvm-amd"
        "kvm-intel"
        "xhci_pci"
        "ehci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
    };
  };
}
