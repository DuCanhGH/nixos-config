# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ config, lib, pkgs, ... }: {
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
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "575.51.02";
      sha256_64bit = "sha256-XZ0N8ISmoAC8p28DrGHk/YN1rJsInJ2dZNL8O+Tuaa0=";
      openSha256 = "sha256-NQg+QDm9Gt+5bapbUO96UFsPnz1hG1dtEwT/g/vKHkw=";
      settingsSha256 = "sha256-6n9mVkEL39wJj5FB1HBml7TTJhNAhS/j5hqpNGFQE4w=";
      usePersistenced = false;
    };
  };

  home-manager.users.ducanh = {
    programs.git = {
      signing.key = "96A86117534CA6B8";
    };
  };
}