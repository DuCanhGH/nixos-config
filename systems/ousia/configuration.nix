# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ config, lib, ... }: {
  imports = [
    ../../modules
    ./hardware-configuration.nix
  ];

  boot = {
    loader.systemd-boot.enable = false;
    # Use the grub EFI boot loader.
    loader.grub.enable = true;
    loader.grub.useOSProber = true;
    loader.grub.device = "nodev";
    loader.grub.efiSupport = true;
    loader.efi.canTouchEfiVariables = true;
  };

  fileSystems = {
    "/swap".options = [ "noatime" ];
  };

  swapDevices = [ { device = "/swap/swapfile"; } ];

  networking.hostName = "ousia"; # Define your hostname.

  hardware.nvidia = {
    powerManagement.enable = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  home-manager.users.ducanh = {
    programs.git = {
      signing.key = "96A86117534CA6B8";
    };
  };
}