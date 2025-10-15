# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ config, lib, pkgs, ... }: {
  imports = [
    ../../modules/nixos
    ./hardware-configuration.nix
  ];

  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    # Use the grub EFI boot loader.
    loader.grub.enable = true;
    loader.grub.useOSProber = true;
    loader.grub.device = "nodev";
    loader.grub.efiSupport = true;
    loader.grub.splashImage = null;
    loader.grub.theme = pkgs.stdenv.mkDerivation {
      pname = "HyperFluent";
      version = "1.0.1";
      src = pkgs.fetchFromGitHub {
        owner = "Coopydood";
        repo = "HyperFluent-GRUB-Theme";
        rev = "50a69ef1c020d1e4e69a683f6f8cf79161fb1a92";
        hash = "sha256-l6oZqo6ATv9DWUKAe3fgx3c12SOX0qaqfwd3ppcdUZk=";
      };
      installPhase = "cp -r $src/nixos $out";
    };
    loader.efi.canTouchEfiVariables = true;
  };

  fileSystems = {
    "/swap".options = [ "noatime" ];
  };

  swapDevices = [ { device = "/swap/swapfile"; } ];

  networking.hostName = "ousia"; # Define your hostname.

  hardware.nvidia = {
    powerManagement.enable = false;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  home-manager.users.ducanh = {
    programs.git = {
      signing.key = "96A86117534CA6B8";
    };
  };
}
