# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ pkgs, config, lib, ... }: {
  imports = [
    ../../modules
    ./hardware-configuration.nix
  ];

  time.timeZone = "America/Indianapolis";

  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    loader.systemd-boot.consoleMode = "max";
    loader.efi.canTouchEfiVariables = true;
    loader.efi.efiSysMountPoint = "/boot";
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };

  swapDevices = [ { device = "/swap/swapfile"; } ];

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
      signing.key = "607B0B2E637FFFFF";
    };
  };
}
