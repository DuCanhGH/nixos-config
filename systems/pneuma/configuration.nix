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
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };

  networking.hostName = "pneuma"; # Define your hostname.

  services.xserver.dpi = 192;

  services.aero.wayland.enable = true;

  services.asusd = {
    enable = true;
    enableUserService = true;
  };

  services.supergfxd.enable = true;

  services.amdgpu.enable = true;

  hardware.bluetooth.enable = true;

  hardware.nvidia.prime = {
    amdgpuBusId = "PCI:0@65:00:0";
    nvidiaBusId = "PCI:0@01:0:0";
  };
}
