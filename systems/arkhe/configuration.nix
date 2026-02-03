# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ pkgs, config, lib, ... }: {
  imports = [
    ../../modules/nixos
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

  networking.hostName = "arkhe"; # Define your hostname.

  hardware.bluetooth.enable = true;

  hardware.nvidia = {
    powerManagement.enable = false;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
}
