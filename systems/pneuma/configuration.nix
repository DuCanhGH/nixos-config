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

  hardware.nvidia = {
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "575.51.02";
      sha256_64bit = "sha256-XZ0N8ISmoAC8p28DrGHk/YN1rJsInJ2dZNL8O+Tuaa0=";
      openSha256 = "sha256-NQg+QDm9Gt+5bapbUO96UFsPnz1hG1dtEwT/g/vKHkw=";
      settingsSha256 = "sha256-6n9mVkEL39wJj5FB1HBml7TTJhNAhS/j5hqpNGFQE4w=";
      usePersistenced = false;
    };
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