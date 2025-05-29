# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ pkgs, config, lib, ... }: {
  imports = [
    ../../modules
    ./hardware-configuration.nix
  ];

  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    loader.systemd-boot.consoleMode = "max";
    loader.systemd-boot.xbootldrMountPoint = "/boot";
    loader.efi.canTouchEfiVariables = true;
    loader.efi.efiSysMountPoint = "/efi";
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };

  fileSystems = {
    "/efi/EFI/Linux" = {
      device = "/boot/EFI/Linux";
      options = ["bind"];
    };
    "/efi/EFI/nixos" = {
      device = "/boot/EFI/nixos";
      options = ["bind"];
    };
  };

  networking.hostName = "pneuma"; # Define your hostname.

  services.asusd = {
    enable = true;
    enableUserService = true;
  };

  services.supergfxd.enable = true;

  hardware.nvidia = {
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      amdgpuBusId = "PCI:0@65:00:0";
      nvidiaBusId = "PCI:0@01:0:0";
    };
  };

  home-manager.users.ducanh = {
    programs.git = {
      signing.key = "F2C058932165560A";
    };
  };
}